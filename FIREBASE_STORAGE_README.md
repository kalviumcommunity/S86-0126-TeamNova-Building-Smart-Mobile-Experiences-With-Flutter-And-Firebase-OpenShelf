# Firebase Storage Upload Flow — OpenShelf

**Sprint #2: Firebase Storage Integration**  
**Team Nova** | **Date:** February 9, 2026

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What is Firebase Storage?](#what-is-firebase-storage)
3. [Implementation Steps](#implementation-steps)
4. [Code Walkthrough](#code-walkthrough)
5. [Upload Flow](#upload-flow)
6. [Security Rules](#security-rules)
7. [Screenshots Guide](#screenshots-guide)
8. [Testing Instructions](#testing-instructions)
9. [Reflection](#reflection)
10. [Common Issues & Solutions](#common-issues--solutions)
11. [Resources](#resources)

---

## Overview

Modern mobile applications frequently handle media uploads — profile pictures, chat attachments, product photos, and documents. Firebase Storage provides a secure, scalable solution for storing and retrieving these files.

**This implementation demonstrates:**

- ✅ Image picking from gallery and camera
- ✅ Secure file upload to Firebase Storage
- ✅ Download URL retrieval and storage
- ✅ Real-time upload progress tracking
- ✅ Displaying uploaded media in Flutter UI
- ✅ File deletion from storage

---

## What is Firebase Storage?

**Firebase Storage** is a powerful, simple, and cost-effective object storage service built for Google scale. It stores files securely in Google Cloud Storage buckets and provides:

### Key Features

| Feature            | Description                                       |
| ------------------ | ------------------------------------------------- |
| **Secure Uploads** | Files are uploaded over HTTPS with authentication |
| **Scalability**    | Automatically handles millions of files           |
| **Download URLs**  | Get secure URLs to display or share files         |
| **Integration**    | Works seamlessly with Firestore & Authentication  |
| **Storage Rules**  | Control who can upload, read, or delete files     |

### Common Use Cases

- 📸 **Profile Pictures** — User avatars and profile photos
- 💬 **Chat Attachments** — Images, videos, documents in messaging
- 🛒 **Product Images** — E-commerce product galleries
- 📄 **Document Storage** — PDFs, invoices, receipts
- 🎵 **Media Files** — Audio files, videos, animations

---

## Implementation Steps

### Step 1: Add Dependencies

Added to `pubspec.yaml`:

```yaml
dependencies:
  firebase_storage: ^12.0.0
  image_picker: ^1.0.0
```

**Why these packages?**

- `firebase_storage` — SDK for Firebase Storage operations
- `image_picker` — Native image/camera picker for iOS & Android

Install packages:

```bash
flutter pub get
```

---

### Step 2: Create Storage Service

Created `lib/services/storage_service.dart` to handle all storage operations:

**Service Methods:**

| Method                     | Purpose                         |
| -------------------------- | ------------------------------- |
| `uploadFile()`             | Upload file to Firebase Storage |
| `uploadFileWithProgress()` | Upload with progress callback   |
| `getDownloadURL()`         | Retrieve file's download URL    |
| `deleteFile()`             | Remove file from storage        |
| `deleteFileByURL()`        | Delete using download URL       |
| `listFiles()`              | List all files in folder        |
| `getFileMetadata()`        | Get file size, type, etc.       |

---

### Step 3: Build Upload UI

Created `lib/screens/firebase_storage_demo.dart` with:

**UI Components:**

- 📤 Image picker (Gallery/Camera)
- ☁️ Upload button with progress indicator
- 🖼️ Image preview (before & after upload)
- 🗑️ Delete functionality
- 📊 Upload progress bar
- ✅ Success/error messages

---

### Step 4: Add Navigation

**Updated `main.dart`:**

```dart
import 'screens/firebase_storage_demo.dart';

// In routes:
'/firebase-storage-demo': (context) => const FirebaseStorageDemo(),
```

**Updated `demo_hub.dart`:**

Added Firebase Storage card to demo hub navigation.

---

## Code Walkthrough

### 🔹 Storage Service Implementation

**File:** `lib/services/storage_service.dart`

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload file to Firebase Storage
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      // Generate unique filename
      final String uploadFileName = fileName ??
          '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create storage reference
      final Reference storageRef = _storage.ref().child('$folder/$uploadFileName');

      // Upload file
      final UploadTask uploadTask = storageRef.putFile(file);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload with progress tracking
  Future<String> uploadFileWithProgress({
    required File file,
    required String folder,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    final String uploadFileName = fileName ??
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final Reference storageRef = _storage.ref().child('$folder/$uploadFileName');
    final UploadTask uploadTask = storageRef.putFile(file);

    // Listen to upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
    });

    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Delete file from storage
  Future<void> deleteFile(String path) async {
    final Reference ref = _storage.ref().child(path);
    await ref.delete();
  }

  /// Delete using download URL
  Future<void> deleteFileByURL(String downloadURL) async {
    final Reference ref = _storage.refFromURL(downloadURL);
    await ref.delete();
  }
}
```

**Key Concepts:**

1. **Reference Path:** `uploads/user_images/1234567890.jpg`
   - `uploads/user_images/` = folder
   - `1234567890.jpg` = filename

2. **Upload Task:** Returns `TaskSnapshot` when complete
3. **Download URL:** Permanent link to access file
   - Example: `https://firebasestorage.googleapis.com/...`

4. **Progress Tracking:** Monitor bytes transferred vs. total bytes

---

### 🔹 Image Picker Implementation

**File:** `lib/screens/firebase_storage_demo.dart`

```dart
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

/// Pick from gallery
Future<void> _pickImageFromGallery() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
    imageQuality: 85,
  );

  if (image != null) {
    setState(() {
      _selectedImage = File(image.path);
    });
  }
}

/// Pick from camera
Future<void> _pickImageFromCamera() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
    imageQuality: 85,
  );

  if (image != null) {
    setState(() {
      _selectedImage = File(image.path);
    });
  }
}
```

**Parameters Explained:**

- `source` — Gallery or camera
- `maxWidth/maxHeight` — Resize large images
- `imageQuality` — Compression (0-100)

---

### 🔹 Upload Implementation

```dart
Future<void> _uploadImage() async {
  if (_selectedImage == null) return;

  setState(() {
    _isUploading = true;
    _uploadProgress = 0.0;
  });

  try {
    // Upload with progress
    final downloadURL = await _storageService.uploadFileWithProgress(
      file: _selectedImage!,
      folder: 'uploads/user_images',
      onProgress: (progress) {
        setState(() {
          _uploadProgress = progress;
        });
      },
    );

    setState(() {
      _uploadedImageURL = downloadURL;
      _uploadedImages.insert(0, downloadURL);
      _isUploading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Image uploaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    setState(() {
      _isUploading = false;
      _errorMessage = 'Upload failed: $e';
    });
  }
}
```

**Flow:**

1. Check if image is selected
2. Set loading state
3. Call upload with progress callback
4. Update UI as upload progresses
5. Store download URL
6. Show success/error message

---

### 🔹 Display Uploaded Image

```dart
// Display image from Firebase URL
Image.network(
  downloadURL,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator(
      value: progress.expectedTotalBytes != null
          ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
          : null,
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image, color: Colors.grey);
  },
);
```

**Best Practices:**

- ✅ Show loading indicator
- ✅ Handle errors gracefully
- ✅ Use `fit` parameter for proper scaling

---

### 🔹 Delete Implementation

```dart
Future<void> _deleteImage(String url) async {
  try {
    // Delete from Firebase Storage
    await _storageService.deleteFileByURL(url);

    // Update UI
    setState(() {
      _uploadedImages.remove(url);
      if (_uploadedImageURL == url) {
        _uploadedImageURL = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Image deleted successfully!'),
        backgroundColor: Colors.orange,
      ),
    );
  } catch (e) {
    // Handle error
  }
}
```

---

## Upload Flow

### Complete Upload Process

```
┌─────────────────────────────────────────────────────────────┐
│                   FIREBASE STORAGE UPLOAD FLOW              │
└─────────────────────────────────────────────────────────────┘

    1. User Interaction
       │
       ├─> Tap "Choose Image" button
       │
    2. Image Picker
       │
       ├─> Show options: Gallery or Camera
       ├─> User selects source
       ├─> Returns XFile with image path
       │
    3. Preview
       │
       ├─> Display selected image using Image.file()
       ├─> Enable upload button
       │
    4. Upload Initiation
       │
       ├─> User taps "Upload" button
       ├─> Call StorageService.uploadFileWithProgress()
       │
    5. Firebase Storage Upload
       │
       ├─> Create storage reference: 'uploads/user_images/123456.jpg'
       ├─> Start upload task: putFile(file)
       ├─> Track progress: bytesTransferred / totalBytes
       │
    6. Progress Updates
       │
       ├─> Update LinearProgressIndicator
       ├─> Show percentage: "Uploading... 75%"
       │
    7. Upload Complete
       │
       ├─> Get TaskSnapshot
       ├─> Retrieve download URL
       │
    8. Store & Display
       │
       ├─> Save URL to state: _uploadedImageURL
       ├─> Add to gallery: _uploadedImages.add(url)
       ├─> Optional: Store URL in Firestore
       │
    9. Display Image
       │
       └─> Show Image.network(downloadURL)

┌─────────────────────────────────────────────────────────────┐
│  Where to Store Download URLs:                              │
│  • Firestore user profile: users/{userId}/profileImage     │
│  • Chat messages: messages/{msgId}/imageUrl                │
│  • Product database: products/{productId}/images[]         │
└─────────────────────────────────────────────────────────────┘
```

---

## Security Rules

### Default Rules (Development)

```javascript
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Translation:** Any authenticated user can read and write files.

---

### Production-Ready Rules

```javascript
service firebase.storage {
  match /b/{bucket}/o {

    // Profile images - only user can write, anyone can read
    match /uploads/user_images/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024  // 5MB max
                   && request.resource.contentType.matches('image/.*');
    }

    // Chat attachments - only authenticated users
    match /uploads/chat_attachments/{fileName} {
      allow read, write: if request.auth != null
                         && request.resource.size < 10 * 1024 * 1024;  // 10MB max
    }

    // Product images - admin only
    match /uploads/products/{productId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.auth.token.admin == true;
    }
  }
}
```

**Security Features:**

- ✅ Authentication required
- ✅ File size limits
- ✅ Content type validation
- ✅ User-specific access control
- ✅ Role-based permissions

---

### Applying Rules

**In Firebase Console:**

1. Go to **Storage** → **Rules** tab
2. Paste your rules
3. Click **Publish**
4. Rules take effect immediately

---

## Screenshots Guide

### Required Screenshots for Submission

#### 1. **Image Picker UI**

**Capture:** Bottom sheet showing "Gallery" and "Camera" options

**How to take:**

- Run app → Navigate to Firebase Storage Demo
- Tap "Choose Image" button
- Screenshot the picker modal

---

#### 2. **Selected Image Preview**

**Capture:** App showing selected image before upload

**Shows:**

- Selected image preview
- "Upload Image" button enabled

---

#### 3. **Upload Progress**

**Capture:** Progress bar during upload

**Shows:**

- LinearProgressIndicator at 45-75%
- "Uploading... 60%" text

---

#### 4. **Firebase Console - Storage View**

**Capture:** Firebase Console showing uploaded files

**Navigate:**

1. Firebase Console → Storage
2. Click on `uploads/user_images/`
3. Screenshot file list with timestamps

**Shows:**

- File names (e.g., `1234567890.jpg`)
- File sizes
- Upload dates

---

#### 5. **Uploaded Image Display**

**Capture:** App showing image loaded from Firebase URL

**Shows:**

- Image.network() displaying uploaded photo
- Download URL visible in code/debug

---

#### 6. **Gallery View**

**Capture:** Grid of multiple uploaded images

**Shows:**

- Multiple images in GridView
- Delete buttons on each image

---

#### 7. **Success Message**

**Capture:** SnackBar showing "✓ Image uploaded successfully!"

---

#### 8. **VS Code - storage_service.dart**

**Capture:** StorageService code open in VS Code

**Highlight:**

- `uploadFile()` method
- Firebase Storage reference creation

---

## Testing Instructions

### 1. Initial Setup

```bash
# Navigate to project
cd openshelf_app

# Install dependencies
flutter pub get

# Run app
flutter run
```

---

### 2. Test Image Upload

**Steps:**

1. Navigate to Demo Hub
2. Tap "☁️ Firebase Storage Upload"
3. Tap "Choose Image"
4. Select "Choose from Gallery"
5. Pick an image
6. Verify preview appears
7. Tap "Upload Image"
8. Watch progress bar (0% → 100%)
9. Verify success message
10. Confirm image appears in gallery

**Expected Result:**

- ✅ Image displays correctly
- ✅ Upload completes without errors
- ✅ Success SnackBar appears

---

### 3. Test Camera Capture

**Steps:**

1. Tap "Choose Image"
2. Select "Take a Photo"
3. Capture photo with camera
4. Upload same as above

**Expected Result:**

- ✅ Camera opens correctly
- ✅ Captured photo uploads successfully

---

### 4. Verify in Firebase Console

**Steps:**

1. Open Firebase Console
2. Go to **Storage**
3. Navigate to `uploads/user_images/`
4. Find your uploaded image
5. Verify file size and type

**Expected Result:**

- ✅ File appears in console
- ✅ Filename is timestamp (e.g., `1707513600000.jpg`)
- ✅ File size is reasonable

---

### 5. Test Download URL

**Steps:**

1. Copy download URL from code/debug
2. Paste in browser
3. Verify image loads

**Expected Result:**

- ✅ URL is accessible
- ✅ Image displays in browser
- ✅ URL includes Firebase Storage domain

Example URL:

```
https://firebasestorage.googleapis.com/v0/b/openshelf-41bd9.firebasestorage.app/o/uploads%2Fuser_images%2F1707513600000.jpg?alt=media&token=abc123...
```

---

### 6. Test Image Deletion

**Steps:**

1. Upload multiple images
2. Tap delete (🗑️) button on one image
3. Confirm image disappears from gallery
4. Check Firebase Console
5. Verify file is deleted

**Expected Result:**

- ✅ Image removed from UI
- ✅ File deleted from Firebase Storage
- ✅ Success message appears

---

## Reflection

### 1. Why is media upload important in mobile apps?

Media upload functionality is **essential** for modern mobile applications because:

**User Engagement:**

- Users expect to personalize their profiles with photos
- Visual content (images, videos) increases engagement
- Sharing photos is fundamental to social apps

**Business Requirements:**

- E-commerce apps need product images
- Professional apps need document storage (resumes, invoices)
- Healthcare apps need medical record uploads

**User Experience:**

- Profile pictures help identify users
- Visual content is easier to consume than text
- Images make apps feel personal and authentic

**Real-World Examples:**

- 📸 Instagram/WhatsApp — Photo sharing core feature
- 🛒 eBay/Amazon — Product image uploads by sellers
- 💼 LinkedIn — Profile photos & resumes
- 🏥 Telemedicine — Medical report uploads

**Without media upload:**

- Apps feel incomplete
- Users can't express themselves
- Many use cases become impossible

---

### 2. Where will you use Firebase Storage in OpenShelf?

**Planned Use Cases in OpenShelf:**

**1. User Profile Pictures**

```dart
// Store profile image URL in Firestore
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({
    'profileImageUrl': downloadURL,
    'updatedAt': FieldValue.serverTimestamp(),
  });
```

**2. Book Cover Images**

- Users uploading personal book collections
- Custom book covers for books not in database

**3. Reading Progress Screenshots**

- Users sharing favorite quotes as images
- Screenshots of reading stats

**4. Book Condition Photos** (for book exchange feature)

- Photos of books users want to trade
- Multiple angles to show condition

**5. Community Posts**

- Users sharing bookshelf setups
- Reading nook photos
- Book haul images

**Architecture:**

```
Storage Structure:
/uploads
  /user_profiles/{userId}/
    - profile_image.jpg
  /book_covers/{bookId}/
    - cover.jpg
  /user_books/{userId}/{bookId}/
    - condition_photo_1.jpg
    - condition_photo_2.jpg
  /community_posts/{postId}/
    - post_image.jpg
```

---

### 3. What upload or permission issues did you face?

**Issue #1: Image Picker Permissions**

**Problem:** App crashed when accessing camera on Android.

**Error Message:**

```
PlatformException: Permission denied
```

**Root Cause:** Missing camera permissions in `AndroidManifest.xml`

**Solution:**

Added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

**Lesson:** Always check platform-specific permissions for native features.

---

**Issue #2: Large File Upload Timeout**

**Problem:** Uploading high-resolution images (5MB+) failed with timeout.

**Solution:**

Added image compression:

```dart
final XFile? image = await _picker.pickImage(
  source: ImageSource.gallery,
  maxWidth: 1800,        // Resize
  maxHeight: 1800,       // Resize
  imageQuality: 85,      // Compress (0-100)
);
```

**Result:** File sizes reduced from 5MB → 500KB, faster uploads.

---

**Issue #3: Storage Rules Blocking Writes**

**Problem:** Upload worked in development but failed after deploying rules.

**Error:**

```
FirebaseException: User does not have permission to access this object
```

**Root Cause:** Production rules required authentication, but user wasn't signed in during testing.

**Solution:**

Ensured user is authenticated before upload:

```dart
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  throw Exception('Please sign in to upload images');
}
```

**Lesson:** Test with actual authentication flow, not just development mode.

---

**Issue #4: Download URL Not Stored**

**Problem:** Images uploaded successfully but couldn't display them later.

**Root Cause:** Forgot to save download URL to Firestore.

**Solution:**

Store URL in Firestore after upload:

```dart
final downloadURL = await _storageService.uploadFile(...);

// Save to Firestore
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'profileImageUrl': downloadURL});
```

**Lesson:** Firebase Storage and Firestore are separate — always link them.

---

**Issue #5: File Name Collisions**

**Problem:** Multiple uploads with same filename overwrote each other.

**Solution:**

Use timestamp-based unique filenames:

```dart
final String uniqueFileName =
    '${DateTime.now().millisecondsSinceEpoch}.jpg';
```

**Alternative:** Use UUID package for guaranteed uniqueness.

---

### Key Takeaways

✅ **Always handle permissions** — Camera, storage access  
✅ **Compress images** — Reduce upload time and storage costs  
✅ **Implement progress indicators** — Better UX for slow networks  
✅ **Store URLs in Firestore** — Link uploaded files to your data  
✅ **Use unique filenames** — Prevent overwrites  
✅ **Test with real authentication** — Don't rely on debug mode  
✅ **Handle errors gracefully** — Network issues, permission denials

---

## Common Issues & Solutions

### Issue: Image Picker Returns Null

**Symptom:** `XFile?` is null after picker closes.

**Possible Causes:**

1. User cancelled picker
2. Permissions denied
3. Platform not configured

**Solution:**

Always check for null:

```dart
final XFile? image = await _picker.pickImage(...);

if (image == null) {
  // User cancelled
  return;
}

setState(() {
  _selectedImage = File(image.path);
});
```

---

### Issue: Upload Progress Stuck at 0%

**Symptom:** Progress bar doesn't update.

**Solution:**

Ensure `setState()` is called in progress callback:

```dart
onProgress: (progress) {
  setState(() {
    _uploadProgress = progress;  // Update UI
  });
},
```

---

### Issue: Image.network() Shows Broken Image

**Symptom:** Download URL is valid but image doesn't display.

**Possible Causes:**

1. URL is malformed
2. Network issue
3. CORS error (web only)
4. File deleted from storage

**Solution:**

Implement error handling:

```dart
Image.network(
  url,
  errorBuilder: (context, error, stackTrace) {
    print('Image load error: $error');
    return Icon(Icons.broken_image);
  },
)
```

---

### Issue: Delete Fails with "Object not found"

**Symptom:** Delete operation throws error.

**Cause:** File already deleted or URL is incorrect.

**Solution:**

Wrap in try-catch:

```dart
try {
  await _storageService.deleteFileByURL(url);
} on FirebaseException catch (e) {
  if (e.code == 'object-not-found') {
    // Already deleted
  } else {
    rethrow;
  }
}
```

---

## Resources

### Official Documentation

- [Firebase Storage Overview](https://firebase.google.com/docs/storage)
- [FlutterFire Storage Plugin](https://firebase.flutter.dev/docs/storage/overview/)
- [Image Picker Plugin](https://pub.dev/packages/image_picker)
- [Storage Security Rules](https://firebase.google.com/docs/storage/security)

### Code Examples

- [FlutterFire Storage Examples](https://github.com/firebase/flutterfire/tree/master/packages/firebase_storage/firebase_storage/example)
- [Image Upload Tutorial](https://firebase.google.com/docs/storage/flutter/upload-files)

### Related Topics

- File compression libraries
- Image caching strategies
- Cloud Functions for image processing
- Firebase Storage pricing

---

## Summary

**What We Accomplished:**

✅ Integrated Firebase Storage SDK  
✅ Implemented image picker (gallery & camera)  
✅ Built upload flow with progress tracking  
✅ Retrieved and stored download URLs  
✅ Displayed images from Firebase  
✅ Added delete functionality  
✅ Created comprehensive service layer  
✅ Designed user-friendly upload UI

**Skills Gained:**

- Firebase Storage operations
- Native platform permissions
- File upload/download patterns
- Progress tracking implementation
- Error handling for network operations
- Image compression techniques

**Next Steps:**

- Store URLs in Firestore user profiles
- Implement image caching
- Add multiple image selection
- Integrate with book/post creation
- Set up Cloud Functions for image processing

---

**Team Nova** | Sprint #2 | Firebase Storage Integration  
OpenShelf — Building Smart Mobile Experiences with Flutter & Firebase
