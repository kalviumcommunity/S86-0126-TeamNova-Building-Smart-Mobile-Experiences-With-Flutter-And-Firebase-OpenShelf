# [Sprint-2] Cloud Functions Trigger Implementation – TeamNova

## 📋 PR Summary

This PR implements **Firebase Cloud Functions** for the OpenShelf app, adding serverless backend capabilities for both callable functions (invoked from Flutter) and event-based triggers (automatic Firestore responses).

## 🎯 What's Included

### Backend Functions (5 total)

#### Callable Functions (2)

1. **`sayHello`** - Simple greeting function demonstrating basic callable function pattern
2. **`addBookRecommendation`** - Complex function with validation, authentication, and Firestore integration

#### Event-Based Functions (3)

3. **`onUserCreated`** - Triggers when new user document created (initializes profile, sends welcome)
4. **`onBookUpdated`** - Triggers when book updated (tracks analytics, updates user stats)
5. **`onBookDeleted`** - Triggers when book deleted (cleanup orphaned reviews)

### Flutter Integration

#### New Files

- `lib/services/cloud_functions_service.dart` - Service class for calling functions
- `lib/screens/cloud_functions_demo_screen.dart` - UI demonstration screen

#### Modified Files

- `pubspec.yaml` - Added `cloud_functions: ^5.0.0` dependency
- `firebase.json` - Added functions configuration

### Functions Code

#### Directory Structure

```
functions/
├── index.js          # All function definitions
├── package.json      # Node.js dependencies
└── .gitignore       # Ignore node_modules
```

## 💻 Code Highlights

### Callable Function Example

**Backend** (`functions/index.js`):

```javascript
exports.sayHello = functions.https.onCall((data, context) => {
  const name = data.name || "User";
  console.log(`sayHello function called with name: ${name}`);

  return {
    message: `Hello, ${name}! Welcome to OpenShelf 📚`,
    timestamp: new Date().toISOString(),
    userId: context.auth ? context.auth.uid : "anonymous",
  };
});
```

**Flutter** (`cloud_functions_service.dart`):

```dart
Future<Map<String, dynamic>> sayHello(String name) async {
  final callable = _functions.httpsCallable('sayHello');
  final result = await callable.call<Map<String, dynamic>>({'name': name});
  return result.data as Map<String, dynamic>;
}
```

### Event-Based Function Example

```javascript
exports.onUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    const userId = context.params.userId;

    // Initialize profile
    await admin.firestore().collection("users").doc(userId).update({
      booksRead: 0,
      booksShared: 0,
      joinedAt: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
    });

    // Send welcome notification
    await admin
      .firestore()
      .collection("notifications")
      .add({
        userId: userId,
        type: "welcome",
        title: "Welcome to OpenShelf! 📚",
        message: `Hi ${userData.displayName}! Start exploring books.`,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        read: false,
      });

    return null;
  });
```

## 📸 Screenshots

### 1. Functions Deployed to Firebase

![Functions Dashboard](screenshots/cloud_functions_deployed.png)
_Shows all 5 functions successfully deployed_

### 2. Function Logs - Callable Function

![Callable Function Logs](screenshots/cloud_functions_callable_logs.png)
_Shows sayHello execution with parameters and response_

### 3. Function Logs - Event Trigger

![Event Trigger Logs](screenshots/cloud_functions_event_logs.png)
_Shows onUserCreated triggered by new document creation_

### 4. App UI - sayHello Response

![App UI Hello](screenshots/cloud_functions_app_hello.png)
_Demo screen showing function call and response_

### 5. App UI - Book Recommendation

![App UI Book](screenshots/cloud_functions_app_book.png)
_Demo screen showing book recommendation form and success_

## 🚀 How to Test

### Prerequisites

```bash
# Install Firebase Tools
npm install -g firebase-tools

# Login to Firebase
firebase login
```

### Deploy Functions

```bash
cd openshelf_app/functions
npm install
cd ..
firebase deploy --only functions
```

### Test in Flutter

```bash
flutter pub get
flutter run
```

### Test Flow

1. Open Cloud Functions Demo screen
2. Test sayHello:
   - Enter your name
   - Click "Call sayHello()"
   - See personalized greeting
3. Test addBookRecommendation:
   - Fill in book details
   - Click "Add Recommendation"
   - Verify success message with book ID
4. View Logs:
   - Open Firebase Console → Functions → Logs
   - See execution details in real-time

### Test Event Triggers

1. Create a new user document in Firestore
2. Watch logs for `onUserCreated` execution
3. Verify notifications collection has welcome message
4. Update a book status
5. Watch logs for `onBookUpdated` execution
6. Verify analytics updated

## 🎓 Learning Outcomes

### Technical Skills Gained

- ✅ Setting up Firebase Cloud Functions project
- ✅ Creating callable functions with authentication
- ✅ Implementing Firestore event triggers (onCreate, onUpdate, onDelete)
- ✅ Error handling and input validation
- ✅ Integrating Cloud Functions with Flutter
- ✅ Monitoring function execution via logs
- ✅ Deploying serverless backend code

### Key Concepts

- **Serverless Architecture**: No server management, auto-scaling, pay-per-use
- **Callable Functions**: Direct invocation from client with automatic auth context
- **Event Triggers**: Automatic execution on Firestore changes
- **Function Types**: HTTP, Firestore, Auth, Storage, PubSub triggers

## 💡 Reflection

### Why Serverless Functions Reduce Backend Overhead

**Traditional Backend Challenges**:

- Server provisioning and maintenance
- Manual scaling for traffic spikes
- Security patch management
- Infrastructure costs during idle time
- DevOps overhead

**Cloud Functions Benefits**:

- ✅ **Zero Server Management**: Firebase handles all infrastructure
- ✅ **Auto-Scaling**: Handles 1 or 1,000,000 requests automatically
- ✅ **Cost Efficient**: Pay only for execution time (not idle)
- ✅ **Built-in Security**: Integrated with Firebase Authentication
- ✅ **Easy Deployment**: Single command deploys all functions
- ✅ **Instant Monitoring**: Logs and metrics out of the box

### Function Choice: Callable vs Event-Triggered

**We implemented BOTH types** to demonstrate different use cases:

**Callable Functions** (sayHello, addBookRecommendation):

- **Use When**: User initiates an action requiring immediate response
- **Examples**: Process payment, search books, fetch recommendations
- **Benefits**: Direct control, parameter passing, return values to client

**Event-Triggered Functions** (onUserCreated, onBookUpdated, onBookDeleted):

- **Use When**: Automatic actions needed on data changes
- **Examples**: Send notifications, update analytics, maintain data integrity
- **Benefits**: Runs reliably in background, no client code, maintains consistency

### Real-World Use Cases

**In OpenShelf:**

1. **User Onboarding**: Auto-initialize profiles, send welcome messages
2. **Analytics**: Track book status changes, reading statistics
3. **Data Integrity**: Clean up related data when books deleted
4. **Validation**: Verify book data before storing

**Beyond OpenShelf:**

1. **E-Commerce**: Process orders, send receipts, update inventory
2. **Social Apps**: Send push notifications, moderate content
3. **Media Apps**: Generate thumbnails, transcode videos
4. **IoT**: Process sensor data, trigger alerts

## 📚 Resources Used

- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Callable Functions Guide](https://firebase.google.com/docs/functions/callable)
- [Firestore Triggers](https://firebase.google.com/docs/functions/firestore-events)
- [Flutter cloud_functions Package](https://pub.dev/packages/cloud_functions)

## 📹 Video Demo

**Video Link**: [Insert your Loom/Drive/YouTube link here]

**Video Contents** (1-2 minutes):

- Cloud Function files in VS Code
- Deploying functions to Firebase
- Demo screen in running app
- Calling sayHello function
- Adding book recommendation
- Firebase Console logs updating in real-time
- Explanation of function purposes

## ✅ Checklist

- [x] Created callable Cloud Functions (sayHello, addBookRecommendation)
- [x] Created event-based functions (onUserCreated, onBookUpdated, onBookDeleted)
- [x] Integrated cloud_functions in Flutter
- [x] Created service class for function calls
- [x] Built demo UI screen
- [x] Configured firebase.json for functions
- [x] Added comprehensive documentation
- [x] Included code examples
- [ ] Deployed functions to Firebase
- [ ] Captured required screenshots
- [ ] Recorded video demo
- [ ] Tested all functions

## 🔄 Files Changed

### New Files

```
functions/
  ├── index.js                           # 5 Cloud Functions
  ├── package.json                       # Dependencies
  └── .gitignore                        # Node.js ignores

lib/
  ├── services/
  │   └── cloud_functions_service.dart  # Flutter service
  └── screens/
      └── cloud_functions_demo_screen.dart  # UI demo
```

### Modified Files

```
pubspec.yaml           # Added cloud_functions dependency
firebase.json          # Added functions configuration
```

### Documentation

```
CLOUD_FUNCTIONS_README.md              # Complete implementation guide
CLOUD_FUNCTIONS_PR_DESCRIPTION.md      # This file
CLOUD_FUNCTIONS_QUICK_START.md         # Quick reference guide
```

## 🎯 Next Steps

1. **Deploy**: Run `firebase deploy --only functions`
2. **Test**: Use demo screen to test functions
3. **Logs**: Verify execution in Firebase Console
4. **Screenshots**: Capture all required images
5. **Video**: Record demo walkthrough
6. **Submit**: Update this PR with links

---

**Submitted by**: TeamNova  
**Sprint**: Sprint-2  
**Feature**: Cloud Functions Integration  
**Date**: February 2026  
**Status**: Ready for Review (after deployment and screenshots)
