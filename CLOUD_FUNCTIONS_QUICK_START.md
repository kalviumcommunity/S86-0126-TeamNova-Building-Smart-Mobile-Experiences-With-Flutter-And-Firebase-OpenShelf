# Cloud Functions Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### 1. Install Dependencies

```bash
cd openshelf_app/functions
npm install
```

### 2. Deploy Functions

```bash
cd ..
firebase deploy --only functions
```

### 3. Update Flutter

```bash
flutter pub get
```

### 4. Run App

```bash
flutter run
```

## 📱 Test Functions

### In App

1. Navigate to Cloud Functions Demo screen
2. Test sayHello function with your name
3. Test addBookRecommendation with book details

### In Firebase Console

1. Go to Firebase Console → Functions
2. Click "Logs" tab
3. Watch logs update as you trigger functions

## 🔧 Available Functions

### Callable Functions

| Function                | Purpose                  | Parameters             | Returns                        |
| ----------------------- | ------------------------ | ---------------------- | ------------------------------ |
| `sayHello`              | Personalized greeting    | `name: String`         | `{message, timestamp, userId}` |
| `addBookRecommendation` | Add book with validation | `title, author, genre` | `{success, bookId, message}`   |

### Event Triggers

| Function        | Trigger      | Action                           |
| --------------- | ------------ | -------------------------------- |
| `onUserCreated` | New user doc | Initialize profile, send welcome |
| `onBookUpdated` | Book updated | Update analytics, user stats     |
| `onBookDeleted` | Book deleted | Cleanup related reviews          |

## 📸 Screenshot Checklist

- [ ] Firebase Console - Functions deployed
- [ ] Firebase Console - Callable function logs
- [ ] Firebase Console - Event trigger logs
- [ ] App UI - sayHello response
- [ ] App UI - Book recommendation success

## 🎬 Video Demo Points

1. Show `functions/index.js` file
2. Run `firebase deploy --only functions`
3. Open app demo screen
4. Call sayHello function
5. Add book recommendation
6. Show Firebase Console logs updating
7. Explain function purposes (30 seconds)

## 📝 Quick Commands

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:sayHello

# View logs in terminal
firebase functions:log

# Test locally with emulator
firebase emulators:start --only functions

# Update Flutter dependencies
flutter pub get

# Run app
flutter run
```

## 🆘 Common Issues

### Function deployment fails

```bash
# Make sure you're logged in
firebase login

# Check project
firebase projects:list

# Re-deploy
firebase deploy --only functions
```

### Flutter can't find functions

```bash
# Update dependencies
flutter pub get

# Clean build
flutter clean
flutter pub get
```

### Emulator connection

```dart
// Add to service initialization for local testing
if (kDebugMode) {
  CloudFunctionsService().useEmulator('localhost', 5001);
}
```

## 🔗 Quick Links

- [Full README](CLOUD_FUNCTIONS_README.md)
- [PR Description](CLOUD_FUNCTIONS_PR_DESCRIPTION.md)
- [Firebase Console](https://console.firebase.google.com)
- [Functions Docs](https://firebase.google.com/docs/functions)

---

**Ready to deploy?** Run `firebase deploy --only functions` and test! 🚀
