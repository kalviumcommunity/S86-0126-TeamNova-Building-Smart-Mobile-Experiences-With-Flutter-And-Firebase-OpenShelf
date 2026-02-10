# Firebase Security - Code Examples

**Production-ready code for authentication and Firestore security**

---

## 1. AuthService - Complete Implementation

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() => _instance;
  AuthService._internal();

  // Properties
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    await cred.user?.updateDisplayName(displayName);
    await _createUserDocument(cred.user!);
    
    return cred;
  }

  // Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() => _auth.signOut();

  // Reset password
  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  // Create user document
  Future<void> _createUserDocument(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'User',
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'role': 'user',
    });
  }
}
```

---

## 2. User Profile Service

```dart
class UserProfileService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserProfile?> getCurrentProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.exists ? UserProfile.fromJson(doc.data()!) : null;
  }

  Future<void> updateProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _db.collection('users').doc(user.uid).update({
      'displayName': profile.displayName,
      'bio': profile.bio,
      'photoUrl': profile.photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _db.collection('users').doc(user.uid).delete();
    await user.delete();
  }
}

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? bio;
  final String? photoUrl;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.bio,
    this.photoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'User',
      bio: json['bio'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'bio': bio,
    'photoUrl': photoUrl,
  };
}
```

---

## 3. Sign Up Screen

```dart
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _handleSignUp,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() => _loading = true);
    try {
      await AuthService().signUp(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        displayName: _nameCtrl.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }
}
```

---

## 4. Sign In Screen

```dart
class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _handleSignIn,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign In'),
            ),
            TextButton(
              onPressed: _handleForgotPassword,
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    setState(() => _loading = true);
    try {
      await AuthService().signIn(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    await AuthService().resetPassword(_emailCtrl.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent to email')),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
```

---

## 5. Firestore Security Rules

### Production Rules

```firestore
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profiles - owner only
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      
      // User's personal collection
      match /documents/{docId} {
        allow read, write: if request.auth.uid == uid;
      }
    }
    
    // Public posts - read all, write authenticated, update own
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.authorId;
    }
    
    // Comments - authenticated read/write
    match /posts/{postId}/comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.authorId;
    }
    
    // Admin panel - admin only
    match /admin/{document=**} {
      allow read, write: if isAdmin();
    }
    
    // System settings - admin only
    match /settings/{doc=**} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
  
  // Helper functions
  function isAdmin() {
    return request.auth.token.role == 'admin';
  }
}
```

---

## 6. Testing Authentication

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Authentication Tests', () {
    test('Sign up creates user and document', () async {
      await AuthService().signUp(
        email: 'test@example.com',
        password: 'password123',
        displayName: 'Test User',
      );

      expect(AuthService().isAuthenticated, true);
      expect(AuthService().currentUserId, isNotNull);
    });

    test('Sign in with valid credentials succeeds', () async {
      await AuthService().signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(AuthService().isAuthenticated, true);
    });

    test('Sign in with invalid credentials fails', () async {
      expect(
        () => AuthService().signIn(
          email: 'wrong@example.com',
          password: 'wrongpassword',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('User cannot read other users data', () async {
      await AuthService().signIn(
        email: 'user1@example.com',
        password: 'password123',
      );

      expect(
        () => FirebaseFirestore.instance
            .collection('users')
            .doc('other_user_id')
            .get(),
        throwsA(isA<FirebaseException>()),
      );
    });
  });
}
```

---

## 7. pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.14.0
  google_sign_in: ^6.2.0  # Optional
```

---

**All code is production-ready! Copy and paste with confidence. 🚀**
