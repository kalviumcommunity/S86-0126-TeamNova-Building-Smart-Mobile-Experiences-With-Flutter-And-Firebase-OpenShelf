# Firebase Security: Authentication & Firestore Rules — OpenShelf

**Sprint #6: Securing Cloud Data with Authentication & Security Rules**  
**Team Nova** | **Date:** February 10, 2026

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Why Firebase Security Matters](#why-firebase-security-matters)
3. [Architecture & Security Model](#architecture--security-model)
4. [Firebase Authentication Setup](#firebase-authentication-setup)
5. [Firestore Security Rules](#firestore-security-rules)
6. [Implementation Guide](#implementation-guide)
7. [Code Walkthrough](#code-walkthrough)
8. [Testing & Verification](#testing--verification)
9. [Common Issues & Solutions](#common-issues--solutions)
10. [Best Practices](#best-practices)
11. [Security Patterns](#security-patterns)
12. [Resources](#resources)

---

## Overview

Firebase Security combines **Authentication** (identifying who users are) with **Firestore Security Rules** (controlling what data they can access). Together, they protect sensitive user data in your cloud database.

**This implementation demonstrates:**

- ✅ Firebase Authentication (Email, Google, Phone)
- ✅ User registration and sign-in flows
- ✅ Secure Firestore rules for different data levels
- ✅ Role-based access control (RBAC)
- ✅ Rule testing and verification
- ✅ Common security patterns
- ✅ Production-ready configurations

---

## Why Firebase Security Matters

### 1. **Data Protection**
- Prevents unauthorized access to sensitive user information
- Ensures only authenticated users can read/write data
- Protects against malicious attacks and data breaches

### 2. **Enforces User Privacy**
- Users can only see their own data
- Personal information remains confidential
- Complies with privacy regulations (GDPR, CCPA)

### 3. **Prevents Abuse**
- Blocks anonymous spam writes
- Prevents data deletion by unauthorized users
- Stops resource exhaustion attacks
- Controls who can perform administrative operations

### 4. **Enables Role-Based Features**
- Admin users can moderate content
- Regular users have limited permissions
- Different features for different user types
- Scales securely with growing user base

### 5. **Required for Production**
- App stores require secure authentication
- Firebase databases default to "test mode" (fully open)
- Production deployments demand security rules
- User trust depends on data protection

---

## Architecture & Security Model

### Three Layers of Security

```
┌─────────────────────────────────────────────────┐
│ Layer 1: Client Authentication                  │
│ - Firebase Auth SDK in Flutter                  │
│ - User credentials validation                   │
│ - Session token management                      │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────v────────────────────────────────┐
│ Layer 2: Network Security                       │
│ - HTTPS encryption in transit                   │
│ - Firebase backend validation                   │
│ - Token verification                            │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────v────────────────────────────────┐
│ Layer 3: Database Rules Engine                  │
│ - Firestore security rules evaluation           │
│ - Document-level access control                 │
│ - Field-level permissions                       │
│ - Server-side enforcement                       │
└─────────────────────────────────────────────────┘
```

### Authentication vs. Authorization

| Aspect | Authentication | Authorization |
|--------|----------------|---------------|
| **Purpose** | Verify WHO you are | Control WHAT you can access |
| **Tool** | Firebase Auth | Firestore Rules |
| **Question** | Are you who you claim? | Do you have permission? |
| **Example** | Sign-in with email | Can read user's profile |

### Security Rule Evaluation Flow

```
┌─────────────────────┐
│ User Request        │
│ (Read/Write Data)   │
└──────────┬──────────┘
           │
           v
┌─────────────────────────────────────────┐
│ Is User Authenticated?                  │
│ (Has valid Firebase Auth token)         │
└──────────┬──────────────────────────────┘
           │
     YES   │  NO
           │
      ┌────v──────┐     ┌──────────────┐
      │ Load Auth  │     │ Permission   │
      │ Context    │     │ DENIED       │
      └────┬───────┘     └──────────────┘
           │
           v
┌──────────────────────────────────────────────┐
│ Evaluate Firestore Rule                      │
│ match /path/to/document {                   │
│   allow action: if condition                │
│ }                                            │
└──────────┬───────────────────────────────────┘
           │
     TRUE  │  FALSE
           │
      ┌────v──────┐     ┌──────────────┐
      │ Permission │    │ Permission   │
      │ ALLOWED    │    │ DENIED       │
      └────────────┘    └──────────────┘
```

---

## Firebase Authentication Setup

### Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  google_sign_in: ^6.2.0  # For Google sign-in
  cloud_firestore: ^4.14.0
```

Install:
```bash
flutter pub get
```

### Step 2: Initialize Firebase

**File: `lib/main.dart`**

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

### Step 3: Enable Authentication Methods

In Firebase Console:
1. Go to **Authentication** → **Sign-in method**
2. Enable desired providers:
   - ✅ Email/Password
   - ✅ Google Sign-In
   - ✅ Phone Authentication
   - ✅ Anonymous (only if needed)

### Step 4: Create AuthService

**File: `lib/services/auth_service.dart`**

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;
  
  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      await _createUserDocument(userCredential.user!);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown error');
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown error');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('sign_out_failed', e.toString());
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown error');
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? 'Anonymous',
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'role': 'user', // Default role
      });
    } catch (e) {
      print('Error creating user document: $e');
    }
  }
}

/// Custom exception for auth errors
class AuthException implements Exception {
  final String code;
  final String? message;

  AuthException(this.code, this.message);

  @override
  String toString() => 'AuthException: $code - $message';
}
```

---

## Firestore Security Rules

### Rule Basics

Firestore rules are defined in a specific format:

```
service cloud.firestore {
  match /databases/{database}/documents {
    // Rules go here
  }
}
```

### Rule Components

```dart
match /path/to/document {
  allow read, write: if condition;
}
```

- **`match`** - Path pattern to document/collection
- **`allow`** - Action(s) to permit: `read`, `write`, `create`, `update`, `delete`
- **`if`** - Condition that must be true

### Request Context Variables

Available in rule conditions:

| Variable | Type | Example |
|----------|------|---------|
| `request.auth` | Object | `request.auth != null` |
| `request.auth.uid` | String | `request.auth.uid == userId` |
| `request.auth.token.email` | String | Email of authenticated user |
| `request.time` | Timestamp | Current server time |
| `request.resource` | Document | Incoming write data |
| `resource` | Document | Existing document data |

### Common Rule Patterns

#### 1. **Authenticated Users Only**

```
match /users/{uid} {
  allow read, write: if request.auth != null;
}
```

- Only authenticated users can access
- No specific ownership check

#### 2. **User Owns Document**

```
match /users/{uid} {
  allow read, write: if request.auth.uid == uid;
}
```

- User can only access their own document
- Most secure for user data

#### 3. **Public Read, Authenticated Write**

```
match /posts/{postId} {
  allow read: if true;
  allow write: if request.auth != null;
}
```

- Anyone can read posts
- Only authenticated users can create/update

#### 4. **Admin Only**

```
match /admin/{document=**} {
  allow read, write: if isAdmin();
}

function isAdmin() {
  return request.auth.token.role == 'admin';
}
```

- Only users with admin role
- Requires custom claims

#### 5. **Nested Collections**

```
match /users/{uid}/posts/{postId} {
  allow read, write: if request.auth.uid == uid;
}
```

- Access restricted to collection owner

#### 6. **Timestamp Validation**

```
match /posts/{postId} {
  allow create: if request.auth != null 
    && request.resource.data.createdAt == request.time;
  allow update: if request.auth.uid == resource.data.authorId
    && request.resource.data.updatedAt == request.time;
}
```

- Enforce server timestamps
- Prevent data tampering

---

## Implementation Guide

### Security Rule Structure for OpenShelf

```firestore
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profiles - owner only
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Public posts - read all, write own
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.authorId;
    }
    
    // User's orders - owner only
    match /users/{uid}/orders/{orderId} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Admin panel - admin only
    match /admin/{document=**} {
      allow read, write: if isAdmin();
    }
  }
  
  // Helper functions
  function isAdmin() {
    return request.auth.token.role == 'admin';
  }
}
```

### Step-by-Step Implementation

**Step 1: Create AuthService**
- Follow code in [Code Walkthrough](#code-walkthrough) section

**Step 2: Update Firebase Console Rules**
1. Go to Firestore → **Rules** tab
2. Replace default rules with secure rules
3. Click **Publish**

**Step 3: Test Rules**
1. Use **Rules Playground** in Firebase Console
2. Simulate authenticated and unauthenticated requests
3. Verify correct access control

**Step 4: Implement in App**
```dart
// Sign up
await AuthService().signUp(
  email: 'user@example.com',
  password: 'password123',
  displayName: 'John Doe',
);

// Sign in
await AuthService().signIn(
  email: 'user@example.com',
  password: 'password123',
);

// Access protected data (now allowed by rules)
final userDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();
```

---

## Code Walkthrough

### Complete AuthService Implementation

See [Code Examples](#code-examples) section for full `AuthService` class

### Sign Up Flow

```dart
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);
    
    try {
      await AuthService().signUp(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _nameController.text,
      );
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
```

### Secure Data Access

```dart
class UserProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Get current user profile (secure - owner only)
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;

      return UserProfile.fromJson(doc.data()!);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  /// Update user profile (secure - owner only)
  Future<void> updateProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
            'displayName': profile.displayName,
            'bio': profile.bio,
            'photoUrl': profile.photoUrl,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  /// Delete user account and data
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Delete user document
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Delete user account
      await user.delete();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }
}

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? bio;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.bio,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'Anonymous',
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
```

---

## Testing & Verification

### Method 1: Firebase Console Rules Playground

**Steps:**
1. Go to Firebase Console → Firestore → **Rules** tab
2. Click **Rules Playground** button
3. Select a path (e.g., `/users/user123`)
4. Choose action: **Read** or **Write**
5. Set auth context:
   - **Authenticated:** UID: `user123`
   - **Unauthenticated:** Leave blank
6. Click **Run** to test

**Test Cases:**

| Scenario | Path | Action | Auth | Expected |
|----------|------|--------|------|----------|
| User reads own profile | `/users/user123` | read | UID: user123 | Allow |
| User reads other profile | `/users/user456` | read | UID: user123 | Deny |
| Unauthenticated read | `/users/user123` | read | None | Deny |
| User writes own profile | `/users/user123` | write | UID: user123 | Allow |
| User writes other profile | `/users/user456` | write | UID: user123 | Deny |

### Method 2: Testing in Flutter

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Firestore Security Rules', () {
    test('User can read own profile', () async {
      // Sign in as user1
      await auth.signInWithEmailAndPassword(
        email: 'user1@test.com',
        password: 'password123',
      );

      // Should succeed - reading own document
      final doc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      expect(doc.exists, true);
    });

    test('User cannot read other profile', () async {
      // Sign in as user1
      await auth.signInWithEmailAndPassword(
        email: 'user1@test.com',
        password: 'password123',
      );

      // Should fail - trying to read user2's document
      expect(
        () => firestore.collection('users').doc('user2').get(),
        throwsA(isA<FirebaseException>()),
      );
    });

    test('Unauthenticated user cannot read', () async {
      // Don't sign in
      
      // Should fail - no authentication
      expect(
        () => firestore.collection('users').doc('user1').get(),
        throwsA(isA<FirebaseException>()),
      );
    });
  });
}
```

### Method 3: Manual Testing Checklist

```
[ ] User A signs up successfully
[ ] User A can read own profile
[ ] User A cannot read User B's profile
[ ] User A can update own profile
[ ] User A cannot delete User B's profile
[ ] Unauthenticated user cannot read any profiles
[ ] Admin user can access /admin collection
[ ] Regular user cannot access /admin collection
[ ] User cannot escalate own role to admin
[ ] Public posts readable by all
[ ] Only post author can delete own post
```

---

## Common Issues & Solutions

### Issue 1: Permission Denied on Own Data

**Symptom:** `PERMISSION_DENIED` error when reading own profile

**Causes:**
- Rules not published
- UID mismatch
- User not authenticated
- Wrong collection path

**Solutions:**
```dart
// ❌ WRONG - Rules not applied
// Firebase Console shows "Saved" but not "Published"

// ✅ CORRECT - Rules published
// 1. Go to Firebase Console → Firestore → Rules
// 2. Make changes
// 3. Click "PUBLISH" (not "Save")
// 4. Wait 30 seconds for rules to deploy

// Verify user is authenticated
if (FirebaseAuth.instance.currentUser == null) {
  print('User not authenticated');
  return;
}

// Verify correct UID
print('Current UID: ${FirebaseAuth.instance.currentUser!.uid}');

// Check rule condition
// Rule: allow read: if request.auth.uid == uid;
// This means /users/{uid} where uid = current user's ID
```

### Issue 2: Rules Too Restrictive

**Symptom:** `PERMISSION_DENIED` for operations that should work

**Causes:**
- Overly strict conditions
- Typos in UID field names
- Incorrect nested collection paths

**Solutions:**
```firestore
// ❌ TOO RESTRICTIVE
match /users/{uid} {
  allow read: if request.auth.uid == uid && request.auth.token.emailVerified;
  // Denies unverified emails
}

// ✅ BETTER - Gradual enforcement
match /users/{uid} {
  allow read: if request.auth.uid == uid;
  allow write: if request.auth.uid == uid && request.auth.token.emailVerified;
  // Read allowed without verification, write requires it
}
```

### Issue 3: Test Mode Never Ends

**Symptom:** App works in test mode but fails after deploying rules

**Cause:** Developed with open rules (allow all)

**Solution:**
```firestore
// ❌ TEST MODE (DO NOT USE IN PRODUCTION)
match /{document=**} {
  allow read, write: if true;
}

// ✅ PRODUCTION
match /databases/{database}/documents {
  // Specific rules for each collection
  match /users/{uid} {
    allow read, write: if request.auth.uid == uid;
  }
}
```

### Issue 4: Can't Access Data After Sign In

**Symptom:** Sign-in works but Firestore reads fail

**Causes:**
- User document not created
- Firestore initialization order
- Rules block creation

**Solutions:**
```dart
// ✅ CORRECT ORDER
Future<void> signUp() async {
  // 1. Create auth user
  final credential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  // 2. Create Firestore document IMMEDIATELY
  await FirebaseFirestore.instance
      .collection('users')
      .doc(credential.user!.uid)
      .set({
        'uid': credential.user!.uid,
        'email': email,
        // ... other fields
      });
}

// ✅ UPDATE RULES - Allow user creation
match /users/{uid} {
  allow read, write: if request.auth.uid == uid;
  // User can create document with their own UID - rule allows this
}
```

### Issue 5: Custom Claims Not Working

**Symptom:** Admin rules don't work even with role field

**Cause:** Role field in Firestore is not same as custom claims in token

**Solution:**
```dart
// ❌ WRONG - Using Firestore field in rules
// Rule: allow write: if resource.data.role == 'admin';
// This checks document data, not auth token

// ✅ CORRECT - Use custom claims
// Step 1: Set custom claims on backend (Cloud Function)
admin.auth().setCustomUserClaims(uid, { role: 'admin' })
  .then(() => console.log('Claims updated'));

// Step 2: Use in rules
match /admin/{document=**} {
  allow read, write: if request.auth.token.role == 'admin';
}

// Step 3: Force token refresh in Flutter
await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
```

---

## Best Practices

### 1. **Always Require Authentication**
```firestore
// ❌ NEVER DO THIS
match /users/{uid} {
  allow read: if true;  // Anyone can read
}

// ✅ ALWAYS DO THIS
match /users/{uid} {
  allow read: if request.auth != null;  // Must be authenticated
}
```

### 2. **Verify Ownership Before Write**
```firestore
// ✅ CORRECT
match /users/{uid} {
  allow write: if request.auth.uid == uid;
  // Only user with matching UID can write
}
```

### 3. **Use Custom Claims for Roles**
```firestore
// ✅ CORRECT - For admin access
function isAdmin() {
  return request.auth.token.role == 'admin';
}

// Store role in auth claims, not Firestore
// Prevents users from changing role locally
```

### 4. **Validate Data Structure**
```firestore
// ✅ VALIDATE REQUIRED FIELDS
match /posts/{postId} {
  allow create: if request.resource.data.keys().hasAll(['title', 'content', 'authorId'])
    && request.resource.data.authorId == request.auth.uid;
}
```

### 5. **Use Timestamps for Security**
```firestore
// ✅ PREVENT TAMPERING
match /posts/{postId} {
  allow update: if request.resource.data.createdAt == resource.data.createdAt
    && request.resource.data.updatedAt == request.time;
    // Ensure creation date doesn't change, update time must be now
}
```

### 6. **Deny by Default, Allow Explicitly**
```firestore
// ✅ SECURE PATTERN
service cloud.firestore {
  match /databases/{database}/documents {
    // Default: deny all
    match /{document=**} {
      allow read, write: if false;
    }
    
    // Explicitly allow specific paths
    match /public/{document=**} {
      allow read: if true;
    }
  }
}
```

### 7. **Test Rules Thoroughly**
- Test authenticated and unauthenticated users
- Test with correct and incorrect UIDs
- Test all CRUD operations
- Test nested collections
- Test edge cases

---

## Security Patterns

### Pattern 1: User-Owned Data

```firestore
match /users/{uid} {
  allow read, write: if request.auth.uid == uid;
  
  // Nested: user's personal collection
  match /documents/{docId} {
    allow read, write: if request.auth.uid == uid;
  }
}
```

**Use Case:** User profiles, personal documents, private settings

### Pattern 2: Public Read, Authenticated Write

```firestore
match /posts/{postId} {
  allow read: if true;
  allow create: if request.auth != null;
  allow update, delete: if request.auth.uid == resource.data.authorId;
}
```

**Use Case:** Blog posts, public comments, community content

### Pattern 3: Admin Only

```firestore
match /admin/{document=**} {
  allow read, write: if isAdmin();
}

function isAdmin() {
  return request.auth.token.role == 'admin';
}
```

**Use Case:** Admin panel, system settings, content moderation

### Pattern 4: Role-Based Access

```firestore
function hasRole(role) {
  return request.auth.token.role == role;
}

match /moderations/{docId} {
  allow read: if hasRole('moderator') || hasRole('admin');
  allow write: if hasRole('admin');
}
```

**Use Case:** Different permissions for different user types

### Pattern 5: Published Content

```firestore
match /articles/{articleId} {
  allow read: if resource.data.published == true || request.auth.uid == resource.data.authorId;
  allow write: if request.auth.uid == resource.data.authorId;
}
```

**Use Case:** Draft/published separation

---

## Common Firestore Rule Errors

### Error: `service.rules.2:4 - Invalid rule`

**Cause:** Syntax error in rules

**Fix:** Check for:
- Missing semicolons
- Unclosed braces
- Invalid function names

### Error: `PERMISSION_DENIED`

**Cause:** User lacks permission

**Fix:**
- Check if user is authenticated
- Verify UID matches
- Check rule conditions

### Error: `INVALID_ARGUMENT`

**Cause:** Invalid field names or conditions

**Fix:**
- Verify field names exist
- Check condition syntax
- Test with Rules Playground

---

## Conclusion

Firebase Security with Authentication and Firestore Rules provides **robust protection** for your cloud data. By implementing proper authentication flows and security rules, you create a foundation of trust with your users.

**Key Takeaways:**
- ✅ Always authenticate users before database access
- ✅ Use security rules to enforce fine-grained access control
- ✅ Test rules thoroughly in Firebase Console
- ✅ Default to secure, least-privilege access
- ✅ Never deploy with open test mode rules

---

## Resources

### Official Documentation
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Firebase Console](https://console.firebase.google.com)

### Related OpenShelf Features
- [Cloud Functions](./CLOUD_FUNCTIONS_README.md)
- [Firestore Real-time Sync](./FIRESTORE_REALTIME_SYNC_README.md)
- [Firebase Storage](./FIREBASE_STORAGE_README.md)

---

**Document Version:** 1.0  
**Last Updated:** February 10, 2026  
**Status:** ✅ Complete & Ready for Production
