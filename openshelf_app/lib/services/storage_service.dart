import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service class for handling Firebase Storage operations
///
/// This service provides methods for:
/// - Uploading files to Firebase Storage
/// - Retrieving download URLs
/// - Deleting files from storage
/// - Managing storage references
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  ///
  /// [file] - The file to upload
  /// [folder] - The folder path in storage (e.g., 'uploads', 'profile_images')
  /// [fileName] - Optional custom file name. If null, uses timestamp
  ///
  /// Returns the download URL of the uploaded file
  ///
  /// Example:
  /// ```dart
  /// final url = await storageService.uploadFile(
  ///   file: File('/path/to/image.jpg'),
  ///   folder: 'profile_images',
  /// );
  /// ```
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      // Generate unique filename if not provided
      final String uploadFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create storage reference
      final Reference storageRef = _storage.ref().child(
        '$folder/$uploadFileName',
      );

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

  /// Upload a file with progress tracking
  ///
  /// [file] - The file to upload
  /// [folder] - The folder path in storage
  /// [fileName] - Optional custom file name
  /// [onProgress] - Callback for upload progress (0.0 to 1.0)
  ///
  /// Returns the download URL of the uploaded file
  Future<String> uploadFileWithProgress({
    required File file,
    required String folder,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final String uploadFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference storageRef = _storage.ref().child(
        '$folder/$uploadFileName',
      );
      final UploadTask uploadTask = storageRef.putFile(file);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Get download URL for a file in storage
  ///
  /// [path] - Full path to the file in storage
  ///
  /// Example:
  /// ```dart
  /// final url = await storageService.getDownloadURL(
  ///   'uploads/user_images/1234567890.jpg'
  /// );
  /// ```
  Future<String> getDownloadURL(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      final String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Delete a file from Firebase Storage
  ///
  /// [path] - Full path to the file in storage
  ///
  /// Example:
  /// ```dart
  /// await storageService.deleteFile('uploads/user_images/1234567890.jpg');
  /// ```
  Future<void> deleteFile(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Delete a file using its download URL
  ///
  /// [downloadURL] - The full download URL of the file
  Future<void> deleteFileByURL(String downloadURL) async {
    try {
      final Reference ref = _storage.refFromURL(downloadURL);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file by URL: $e');
    }
  }

  /// List all files in a specific folder
  ///
  /// [folder] - The folder path in storage
  ///
  /// Returns a list of file references
  Future<List<Reference>> listFiles(String folder) async {
    try {
      final Reference ref = _storage.ref().child(folder);
      final ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// Get file metadata
  ///
  /// [path] - Full path to the file in storage
  ///
  /// Returns metadata including size, content type, etc.
  Future<FullMetadata> getFileMetadata(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      final FullMetadata metadata = await ref.getMetadata();
      return metadata;
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Update file metadata
  ///
  /// [path] - Full path to the file in storage
  /// [metadata] - New metadata to set
  Future<void> updateFileMetadata(
    String path,
    SettableMetadata metadata,
  ) async {
    try {
      final Reference ref = _storage.ref().child(path);
      await ref.updateMetadata(metadata);
    } catch (e) {
      throw Exception('Failed to update file metadata: $e');
    }
  }
}
