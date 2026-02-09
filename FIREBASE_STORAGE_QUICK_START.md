# Firebase Storage Upload - Quick Start Guide

**Sprint #2: Firebase Storage Integration**  
**Team Nova**

---

## 🚀 Quick Setup (5 Minutes)

### 1. Install Dependencies

```bash
cd openshelf_app
flutter pub get
```

**Packages Added:**

- `firebase_storage: ^12.0.0`
- `image_picker: ^1.0.0`

---

### 2. Run the App

```bash
flutter run
```

---

### 3. Navigate to Demo

```
AuthGate → Sign In → Demo Hub → Firebase Storage Upload
```

Or use direct route:

```dart
Navigator.pushNamed(context, '/firebase-storage-demo');
```

---

## 📸 Test Upload Flow

### Step-by-Step

1. **Choose Image**
   - Tap "Choose Image" button
   - Select "Choose from Gallery" or "Take a Photo"
   - Pick an image

2. **Preview**
   - Selected image appears in preview area
   - "Upload Image" button becomes enabled

3. **Upload**
   - Tap "Upload Image"
   - Watch progress bar: 0% → 100%
   - See success message: "✓ Image uploaded successfully!"

4. **View Results**
   - Image appears in gallery grid
   - Download URL is stored

5. **Verify in Firebase**
   - Open [Firebase Console](https://console.firebase.google.com)
   - Go to Storage
   - Navigate to `uploads/user_images/`
   - Find uploaded image

---

## 🎯 Key Features Demonstrated

✅ **Image Picker** — Gallery & Camera support  
✅ **File Upload** — Secure upload to Firebase Storage  
✅ **Progress Tracking** — Real-time upload progress  
✅ **Download URLs** — Retrieve permanent file URLs  
✅ **Image Display** — Show uploaded images from Firebase  
✅ **Delete Functionality** — Remove files from storage

---

## 📁 Files Created

| File                                     | Purpose                    |
| ---------------------------------------- | -------------------------- |
| `lib/services/storage_service.dart`      | Storage operations service |
| `lib/screens/firebase_storage_demo.dart` | Upload demo UI             |
| `FIREBASE_STORAGE_README.md`             | Full documentation         |
| `FIREBASE_STORAGE_PR_DESCRIPTION.md`     | PR description             |
| `FIREBASE_STORAGE_QUICK_START.md`        | This file                  |

---

## 🔧 Code Snippets

### Upload an Image

```dart
import 'package:firebase_storage/firebase_storage.dart';

final storageService = StorageService();

// Upload file
final downloadURL = await storageService.uploadFile(
  file: File('/path/to/image.jpg'),
  folder: 'uploads/user_images',
);

print('Image uploaded: $downloadURL');
```

### Display Uploaded Image

```dart
Image.network(
  downloadURL,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
)
```

### Delete Image

```dart
await storageService.deleteFileByURL(downloadURL);
```

---

## 🔒 Security Rules

### Current Rules (Development)

```javascript
allow read, write: if request.auth != null;
```

### Recommended for Production

```javascript
match /uploads/user_images/{userId}/{fileName} {
  allow read: if true;
  allow write: if request.auth != null
               && request.auth.uid == userId
               && request.resource.size < 5 * 1024 * 1024;
}
```

---

## 🐛 Troubleshooting

### Issue: "Permission denied" when accessing camera

**Solution:** Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

---

### Issue: Large images fail to upload

**Solution:** Image picker already compresses:

```dart
final XFile? image = await _picker.pickImage(
  source: ImageSource.gallery,
  maxWidth: 1800,
  maxHeight: 1800,
  imageQuality: 85,  // 0-100
);
```

---

### Issue: Image.network() shows broken image

**Causes:**

- Network error
- Invalid URL
- File deleted from storage

**Solution:** Always use error handling:

```dart
Image.network(
  url,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image);
  },
)
```

---

## 📊 Where to Store Download URLs

After uploading, store URLs in Firestore:

### User Profile

```dart
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({
    'profileImageUrl': downloadURL,
    'updatedAt': FieldValue.serverTimestamp(),
  });
```

### Book Document

```dart
await FirebaseFirestore.instance
  .collection('books')
  .doc(bookId)
  .update({
    'coverImageUrl': downloadURL,
  });
```

### Chat Message

```dart
await FirebaseFirestore.instance
  .collection('messages')
  .add({
    'imageUrl': downloadURL,
    'senderId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  });
```

---

## 🎓 Learning Objectives

By completing this task, you learned:

✅ How to integrate Firebase Storage SDK  
✅ How to use image_picker for native file selection  
✅ How to upload files with progress tracking  
✅ How to retrieve and use download URLs  
✅ How to display network images in Flutter  
✅ How to delete files from storage  
✅ How to implement security rules  
✅ How to handle permissions and errors

---

## 📚 Next Steps

1. **Integrate with User Profiles**
   - Upload profile pictures
   - Store URL in user document

2. **Add Image Caching**
   - Install `cached_network_image`
   - Reduce network calls

3. **Multiple Image Upload**
   - Allow selecting multiple images
   - Batch upload functionality

4. **Image Cropping**
   - Integrate `image_cropper`
   - Let users edit before upload

5. **Cloud Functions**
   - Automatic thumbnail generation
   - Image resizing
   - Content moderation

---

## 📸 Screenshot Checklist

Before submitting, capture:

- [ ] Image picker modal (Gallery/Camera options)
- [ ] Selected image preview
- [ ] Upload progress bar (50-75%)
- [ ] Firebase Console showing uploaded file
- [ ] Uploaded image displaying in app
- [ ] Gallery grid with multiple images
- [ ] Success SnackBar message
- [ ] VS Code showing `storage_service.dart`

---

## 🎬 Video Demo Requirements

**Duration:** 1-2 minutes

**Must Show:**

1. Selecting an image
2. Uploading it (with progress)
3. Firebase Console storage view
4. Image displaying in app
5. Brief code explanation

**Upload to:** Google Drive / Loom / YouTube (unlisted)  
**Access:** Anyone with the link

---

## ✅ Submission Checklist

### Code

- [x] Dependencies added (`pubspec.yaml`)
- [x] Storage service created
- [x] Upload UI implemented
- [x] Navigation integrated
- [x] No compilation errors

### Documentation

- [x] README created
- [x] PR description written
- [x] Quick start guide created
- [x] Code snippets included
- [x] Reflection answered

### Testing

- [x] Upload from gallery works
- [x] Upload from camera works
- [x] Progress tracking works
- [x] Images display correctly
- [x] Delete works
- [x] Verified in Firebase Console

### Submission

- [ ] Screenshots captured (8 required)
- [ ] Video demo recorded (1-2 min)
- [ ] Video uploaded with public link
- [ ] Code committed to Git
- [ ] PR created with description

---

## 📝 Commit Message

```bash
git add .
git commit -m "feat: Firebase Storage integration with image upload

- Added firebase_storage and image_picker dependencies
- Created StorageService for upload/delete operations
- Built FirebaseStorageDemo screen with image picker
- Implemented upload with progress tracking
- Added download URL retrieval and display
- Integrated with demo hub navigation
- Created comprehensive documentation

Sprint #2 - Team Nova"
```

---

## 🌟 Key Takeaways

**Technical:**

- Firebase Storage provides scalable file hosting
- Progress tracking improves UX
- Download URLs link storage with Firestore
- Image compression reduces upload time
- Security rules protect your storage

**Best Practices:**

- Always compress images before upload
- Use unique filenames (timestamps)
- Store URLs in Firestore for easy retrieval
- Handle permissions gracefully
- Implement loading and error states

**Real-World Applications:**

- Profile pictures
- Product images
- Chat attachments
- Document storage
- Media galleries

---

**Team Nova** | Sprint #2 | Firebase Storage Integration  
OpenShelf — Building Smart Mobile Experiences with Flutter & Firebase

**Ready to Test!** 🚀
