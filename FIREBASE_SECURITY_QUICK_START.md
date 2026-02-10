# Firebase Security - Quick Start Guide

**Get up and running with secure authentication and Firestore rules in 10 minutes** ⚡

---

## 📦 Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.14.0
```

Run:
```bash
flutter pub get
```

---

## 🚀 Step 2: Initialize Firebase

In `main.dart`:

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

## 🔑 Step 3: Enable Authentication

In Firebase Console:
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. Done!

---

## 📱 Step 4: Create AuthService

Create `lib/services/auth_service.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Sign up
  Future<void> signUp(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Create user document
    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'displayName': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Check if logged in
  bool get isLoggedIn => _auth.currentUser != null;
}
```

---

## 🔒 Step 5: Set Firestore Security Rules

In Firebase Console:
1. Go to **Firestore** → **Rules**
2. Replace everything with:

```firestore
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profiles - owner only
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

3. Click **PUBLISH**

---

## ✅ Step 6: Test It Works

```dart
// Sign up
await AuthService().signUp('user@test.com', 'password123', 'John Doe');

// Read own profile (works!)
final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

print(doc.data()); // Shows user profile
```

---

## 🎯 Rule Patterns

### Public Read, Authenticated Write
```firestore
match /posts/{postId} {
  allow read: if true;
  allow write: if request.auth != null;
}
```

### Admin Only
```firestore
match /admin/{doc=**} {
  allow read, write: if request.auth.token.role == 'admin';
}
```

---

## 🐛 Troubleshooting

| Issue | Fix |
|-------|-----|
| PERMISSION_DENIED | Make sure rules are PUBLISHED (not just saved) |
| Can't create user doc | Check that `/users/{uid}` rule exists |
| User not authenticated | Call sign-in before reading/writing |

---

## 📚 Learn More

- [Full Guide](./FIREBASE_SECURITY_README.md)
- [Code Examples](./FIREBASE_SECURITY_CODE_EXAMPLES.md)
- [Implementation Checklist](./FIREBASE_SECURITY_IMPLEMENTATION_CHECKLIST.md)

---

**That's it! You now have secure authentication + database rules! 🎉**
