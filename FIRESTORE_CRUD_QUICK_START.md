# Firestore CRUD Flow: 10-Minute Quick Start

Get a fully functional CRUD app running in just 10 minutes.

---

## Step 1: Add Dependencies (2 minutes)

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.20.0
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.14.0
```

Run: `flutter pub get`

---

## Step 2: Configure Firebase (2 minutes)

**In Firebase Console**:
1. Create/select your Firebase project
2. Enable Email/Password authentication
3. Create Firestore database in Production Mode

**In your app's `main.dart`**:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## Step 3: Create Auth & CRUD Services (3 minutes)

Create `lib/services/auth_service.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          'email': email,
          'displayName': email.split('@')[0],
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
      return true;
    } catch (e) {
      print('Sign-up error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  String? getCurrentUserId() => _auth.currentUser?.uid;
  bool isLoggedIn() => _auth.currentUser != null;

  Future<void> logout() async {
    await _auth.signOut();
  }
}
```

Create `lib/services/crud_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudItem {
  final String id;
  final String title;
  final String description;
  final String priority;
  final int createdAt;

  CrudItem({
    required this.id,
    required this.title,
    required this.description,
    this.priority = 'medium',
    required this.createdAt,
  });

  factory CrudItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CrudItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      priority: data['priority'] ?? 'medium',
      createdAt: data['createdAt'] ?? 0,
    );
  }
}

class CrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _userItems {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('items');
  }

  // CREATE
  Future<void> createItem({
    required String title,
    required String description,
    String priority = 'medium',
  }) async {
    await _userItems.add({
      'title': title,
      'description': description,
      'priority': priority,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // READ
  Stream<List<CrudItem>> getUserItemsStream() {
    return _userItems
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CrudItem.fromFirestore(doc))
            .toList());
  }

  // UPDATE
  Future<void> updateItem(String itemId, String title, String description, String priority) async {
    await _userItems.doc(itemId).update({
      'title': title,
      'description': description,
      'priority': priority,
    });
  }

  // DELETE
  Future<void> deleteItem(String itemId) async {
    await _userItems.doc(itemId).delete();
  }
}
```

---

## Step 4: Build UI (3 minutes)

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/crud_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final CrudService _crudService = CrudService();

  @override
  Widget build(BuildContext context) {
    if (!_authService.isLoggedIn()) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.logout();
              setState(() {});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<CrudItem>>(
        stream: _crudService.getUserItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('No items. Create one!'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () => _showEditDialog(item),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () => _crudService.deleteItem(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _crudService.createItem(
                title: titleCtrl.text,
                description: descCtrl.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(CrudItem item) {
    final titleCtrl = TextEditingController(text: item.title);
    final descCtrl = TextEditingController(text: item.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _crudService.updateItem(
                item.id,
                titleCtrl.text,
                descCtrl.text,
                item.priority,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = isSignUp
                    ? await _authService.signUp(emailCtrl.text, passCtrl.text)
                    : await _authService.login(emailCtrl.text, passCtrl.text);

                if (success) {
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication failed')),
                  );
                }
              },
              child: Text(isSignUp ? 'Sign Up' : 'Login'),
            ),
            TextButton(
              onPressed: () => setState(() => isSignUp = !isSignUp),
              child: Text(isSignUp ? 'Have account? Login' : 'No account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 5: Update Firestore Rules (1 minute)

In Firebase Console → Firestore → Rules:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      match /items/{itemId} {
        allow read, write: if request.auth.uid == uid;
      }
    }
  }
}
```

---

## Test Your CRUD App

✅ **Create**: Tap +, add item, see it appear instantly
✅ **Read**: Items stream auto-update with real-time sync
✅ **Update**: Tap edit, change details, save
✅ **Delete**: Tap delete, item vanishes from list
✅ **Auth**: Logout, login again, see only your items

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| PERMISSION_DENIED | Check Firestore rules updated |
| Items not appearing | Verify user logged in (check UID) |
| Can't sign up | Email/password auth might be disabled |
| UI not updating | Ensure using StreamBuilder, not `.get()` |

---

## Next Steps

- Review [Code Examples](#code-examples) for advanced patterns
- Check [Implementation Checklist](#implementation-checklist) for verification
- Read [Complete README](#readme) for deep dives on each operation
