# How to Deploy Cloud Functions to Firebase

## Prerequisites

### 1. Install Node.js

Download and install from [nodejs.org](https://nodejs.org/)

Verify installation:

```bash
node --version
npm --version
```

### 2. Install Firebase Tools

```bash
npm install -g firebase-tools
```

Verify installation:

```bash
firebase --version
```

### 3. Login to Firebase

```bash
firebase login
```

This will open a browser for authentication. Login with your Google account.

## Deployment Steps

### Step 1: Navigate to Project

```bash
cd openshelf_app
```

### Step 2: Install Function Dependencies

```bash
cd functions
npm install
cd ..
```

Expected output:

```
added 200+ packages
```

### Step 3: Deploy Functions

```bash
firebase deploy --only functions
```

Expected output:

```
=== Deploying to 'openshelf-41bd9'...

i  deploying functions
i  functions: ensuring required API cloudfunctions.googleapis.com is enabled...
i  functions: ensuring required API cloudbuild.googleapis.com is enabled...
✔  functions: required API cloudfunctions.googleapis.com is enabled
✔  functions: required API cloudbuild.googleapis.com is enabled
i  functions: preparing functions directory for uploading...
i  functions: packaged functions (XX.XX KB) for uploading
✔  functions: functions folder uploaded successfully
i  functions: creating Node.js 18 function sayHello(us-central1)...
i  functions: creating Node.js 18 function addBookRecommendation(us-central1)...
i  functions: creating Node.js 18 function onUserCreated(us-central1)...
i  functions: creating Node.js 18 function onBookUpdated(us-central1)...
i  functions: creating Node.js 18 function onBookDeleted(us-central1)...
✔  functions[sayHello(us-central1)]: Successful create operation.
✔  functions[addBookRecommendation(us-central1)]: Successful create operation.
✔  functions[onUserCreated(us-central1)]: Successful create operation.
✔  functions[onBookUpdated(us-central1)]: Successful create operation.
✔  functions[onBookDeleted(us-central1)]: Successful create operation.

✔  Deploy complete!
```

### Step 4: Verify Deployment

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (openshelf-41bd9)
3. Click "Functions" in left menu
4. You should see 5 functions listed:
   - sayHello
   - addBookRecommendation
   - onUserCreated
   - onBookUpdated
   - onBookDeleted

## Testing Functions

### Test Callable Functions in Flutter

1. Run your app:

```bash
flutter pub get
flutter run
```

2. Navigate to Cloud Functions Demo screen
3. Test sayHello function
4. Test addBookRecommendation function

### View Logs

1. In Firebase Console, click "Functions" → "Logs"
2. Trigger functions from your app
3. Watch logs appear in real-time

Or view logs in terminal:

```bash
firebase functions:log
```

## Common Issues & Solutions

### Issue: Permission Denied

**Error**: `Error: HTTP Error: 403, The caller does not have permission`

**Solution**:

1. Make sure you're logged into the correct Google account
2. Verify you have Owner/Editor role on the Firebase project
3. Re-login: `firebase logout` then `firebase login`

### Issue: API Not Enabled

**Error**: `Cloud Functions API has not been used`

**Solution**:
Firebase will prompt you to enable the API. Type `y` and press Enter.

### Issue: Billing Required

**Error**: `This project requires billing to be enabled`

**Solution**:
Cloud Functions require the Blaze (pay-as-you-go) plan. Enable in Firebase Console → Settings → Usage and Billing.

**Note**: Free tier includes:

- 2M invocations/month
- 400K GB-seconds/month
- 200K CPU-seconds/month

Most development usage stays within free tier.

### Issue: Function Timeout

**Error**: `Function execution took too long`

**Solution**:
Increase timeout in function config:

```javascript
exports.myFunction = functions
  .runWith({ timeoutSeconds: 300 })
  .https.onCall(...)
```

### Issue: Dependency Errors

**Error**: `Cannot find module 'firebase-admin'`

**Solution**:

```bash
cd functions
rm -rf node_modules package-lock.json
npm install
cd ..
firebase deploy --only functions
```

## Updating Functions

When you modify function code:

```bash
firebase deploy --only functions
```

To deploy a specific function:

```bash
firebase deploy --only functions:sayHello
```

To delete a function:

```bash
firebase functions:delete functionName
```

## Local Testing with Emulator

Test functions locally before deploying:

### 1. Start Emulator

```bash
firebase emulators:start --only functions
```

### 2. Update Flutter Code

```dart
import 'package:flutter/foundation.dart';

void initFirebase() async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Use local emulator
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }
}
```

### 3. Test Functions

Call functions from your app. They'll execute locally instead of in the cloud.

### 4. View Emulator Logs

Logs appear in the terminal where you ran the emulator.

## Monitoring & Debugging

### View Function Metrics

Firebase Console → Functions → Dashboard

Shows:

- Invocations
- Errors
- Execution time
- Memory usage

### View Detailed Logs

Firebase Console → Functions → Logs

Filter by:

- Function name
- Severity (Info, Warning, Error)
- Time range

### Export Logs

For analysis, export logs to Google Cloud Logging.

## Best Practices

### 1. Use Environment Variables

```javascript
const functions = require("firebase-functions");
const apiKey = functions.config().myapi.key;
```

Set config:

```bash
firebase functions:config:set myapi.key="YOUR_KEY"
```

### 2. Handle Errors Properly

```javascript
exports.myFunction = functions.https.onCall((data, context) => {
  try {
    // Function logic
    return { success: true };
  } catch (error) {
    console.error("Error:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});
```

### 3. Add Timeouts

```javascript
exports.longFunction = functions
  .runWith({ timeoutSeconds: 300, memory: "1GB" })
  .https.onCall(async (data, context) => {
    // Long-running task
  });
```

### 4. Use TypeScript (Optional)

For better type safety, convert to TypeScript:

```bash
cd functions
npm install --save-dev typescript @types/node
```

## Cost Optimization

### Free Tier Limits

- 2M invocations/month
- 400K GB-seconds compute time
- 200K CPU-seconds
- 5GB outbound networking

### Tips to Stay in Free Tier

1. Optimize function code for speed
2. Reduce unnecessary function calls
3. Use caching when possible
4. Batch operations instead of individual calls
5. Monitor usage in Firebase Console

### Estimated Costs (Beyond Free Tier)

- Invocations: $0.40 per million
- Compute time: $0.0000025 per GB-second
- Networking: $0.12 per GB

Typical app usage rarely exceeds free tier.

## Production Checklist

Before going live:

- [ ] Test all functions thoroughly
- [ ] Add error handling
- [ ] Implement retry logic for critical operations
- [ ] Set appropriate timeouts
- [ ] Add logging for debugging
- [ ] Review security rules
- [ ] Test with production data
- [ ] Monitor performance metrics
- [ ] Set up alerts for errors
- [ ] Document all functions

## Next Steps

1. ✅ Deploy functions: `firebase deploy --only functions`
2. ✅ Test in app
3. ✅ View logs in console
4. ✅ Take screenshots for documentation
5. ✅ Record video demo
6. ✅ Submit PR

## Resources

- [Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Pricing Calculator](https://firebase.google.com/pricing)
- [Best Practices](https://firebase.google.com/docs/functions/best-practices)
- [Troubleshooting Guide](https://firebase.google.com/docs/functions/troubleshooting)

---

Need help? Check the [troubleshooting section](#common-issues--solutions) or consult Firebase documentation.
