# 📚 Firestore Write & Update Operations - OpenShelf App

> **Sprint #2: Firestore Database Integration**  
> **Task**: Writing and Updating Data to Firestore Securely  
> **Team**: TeamNova  
> **Date**: February 9, 2026

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Write Operations Explained](#write-operations-explained)
3. [Implementation Guide](#implementation-guide)
4. [Code Examples](#code-examples)
5. [Validation & Security](#validation--security)
6. [Testing & Screenshots](#testing--screenshots)
7. [Reflection](#reflection)

---

## 🎯 Overview

This guide demonstrates how to **write, update, and delete data** in Cloud Firestore for the OpenShelf book-sharing app. You'll learn:

- ✅ **ADD** operation - Create documents with auto-generated IDs
- ✅ **SET** operation - Write to specific document IDs (with merge)
- ✅ **UPDATE** operation - Modify specific fields in existing documents
- ✅ **DELETE** operation - Remove documents from collections
- ✅ **Input validation** - Ensure data integrity before writing
- ✅ **Error handling** - Gracefully manage write failures

---

## 📝 Write Operations Explained

### 1. ADD Operation

**Purpose**: Create a new document with an **auto-generated ID**.

**When to use**:

- Creating new books, users, or records
- You don't need to specify the document ID
- Most common write operation

**Code**:

```dart
Future<DocumentReference> addBook(String title, String author) async {
  return await FirebaseFirestore.instance
    .collection('books')
    .add({
      'title': title,
      'author': author,
      'available': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
}
```

**Result**: Firestore generates a unique ID like `aB3dE5fG7hI9`.

---

### 2. SET Operation

**Purpose**: Write to a **specific document ID**, creating it if it doesn't exist.

**When to use**:

- User profiles (where userId is the document ID)
- You want to control the document ID
- You want to overwrite existing data OR merge with existing data

**Code (Overwrite)**:

```dart
await FirebaseFirestore.instance
  .collection('users')
  .doc('user_123')
  .set({
    'displayName': 'John Doe',
    'email': 'john@example.com',
    'createdAt': FieldValue.serverTimestamp(),
  });
```

**Code (Merge)**:

```dart
await FirebaseFirestore.instance
  .collection('users')
  .doc('user_123')
  .set({
    'displayName': 'John Doe',
  }, SetOptions(merge: true)); // Keeps existing fields
```

**Difference**: Without `merge`, set() **overwrites** the entire document. With `merge: true`, it only updates specified fields.

---

### 3. UPDATE Operation

**Purpose**: Modify **specific fields** in an existing document without touching other fields.

**When to use**:

- Updating book availability
- Changing user profile fields
- Document must already exist (throws error if not)

**Code**:

```dart
await FirebaseFirestore.instance
  .collection('books')
  .doc('book_123')
  .update({
    'available': false,
    'updatedAt': FieldValue.serverTimestamp(),
  });
```

**Important**: `update()` fails if the document doesn't exist. Use `set(merge: true)` if you're unsure.

---

### 4. DELETE Operation

**Purpose**: Remove a document from Firestore.

**When to use**:

- Deleting books, users, or records
- Permanent removal (cannot be undone)

**Code**:

```dart
await FirebaseFirestore.instance
  .collection('books')
  .doc('book_123')
  .delete();
```

---

## 🛠️ Implementation Guide

### Step 1: Enhance FirestoreService

The `FirestoreService` class centralizes all Firestore operations.

**File**: `lib/services/firestore_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get books => _firestore.collection('books');

  // ========================================================================
  // ADD OPERATION - Create new document with auto-generated ID
  // ========================================================================

  Future<DocumentReference> addBook(
    String title,
    String author, {
    String? isbn,
    String? description,
    List<String>? genre,
  }) async {
    try {
      // Validate inputs
      if (title.trim().isEmpty || author.trim().isEmpty) {
        throw Exception('Title and author are required');
      }

      return await books.add({
        'title': title.trim(),
        'author': author.trim(),
        'isbn': isbn?.trim() ?? '',
        'description': description?.trim() ?? '',
        'genre': genre ?? [],
        'available': true,
        'averageRating': 0.0,
        'totalRatings': 0,
        'copiesAvailable': 1,
        'totalCopies': 1,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding book: $e');
    }
  }

  // ========================================================================
  // UPDATE OPERATION - Modify specific fields
  // ========================================================================

  Future<void> updateBookAvailability(String bookId, bool available) async {
    try {
      await books.doc(bookId).update({
        'available': available,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      // Add timestamp
      data['updatedAt'] = FieldValue.serverTimestamp();

      await books.doc(bookId).update(data);
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  // ========================================================================
  // DELETE OPERATION - Remove document
  // ========================================================================

  Future<void> deleteBook(String bookId) async {
    try {
      await books.doc(bookId).delete();
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }
}
```

---

### Step 2: Create Write Operations Demo Screen

**File**: `lib/screens/firestore_write_demo.dart`

This screen includes:

- ✅ **Tab 1: Add Books** - Form with validation
- ✅ **Tab 2: Update Books** - Select & edit existing books
- ✅ **Tab 3: View All** - List all books with delete option

**Key Features**:

```dart
// Form validation
TextFormField(
  controller: _titleController,
  decoration: const InputDecoration(
    labelText: 'Book Title *',
    prefixIcon: Icon(Icons.book),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  },
)

// Add button with loading state
ElevatedButton.icon(
  onPressed: _isLoading ? null : _addBook,
  icon: _isLoading
    ? CircularProgressIndicator()
    : Icon(Icons.add),
  label: Text(_isLoading ? 'Adding...' : 'Add Book'),
)
```

---

## 📖 Code Examples

### Example 1: Add a Book with Validation

```dart
Future<void> _addBook() async {
  // Validate form
  if (!_addFormKey.currentState!.validate()) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();

    // Call service method
    await _firestoreService.addBook(title, author);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ Book "$title" added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    _titleController.clear();
    _authorController.clear();
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

### Example 2: Update Book Fields

```dart
Future<void> _updateBook() async {
  if (_selectedBookId == null) return;

  if (!_updateFormKey.currentState!.validate()) {
    return;
  }

  try {
    final updateData = {
      'title': _titleController.text.trim(),
      'author': _authorController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
      .collection('books')
      .doc(_selectedBookId)
      .update(updateData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Book updated successfully!'),
        backgroundColor: Colors.blue,
      ),
    );
  } catch (e) {
    // Handle error
  }
}
```

---

### Example 3: Delete Book with Confirmation

```dart
Future<void> _deleteBook(String bookId) async {
  // Show confirmation dialog
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Book'),
      content: const Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await _firestoreService.deleteBook(bookId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✓ Book deleted')),
    );
  } catch (e) {
    // Handle error
  }
}
```

---

## 🔒 Validation & Security

### Input Validation Rules

✅ **Title**:

- Cannot be empty
- Minimum 3 characters
- Trimmed of whitespace

✅ **Author**:

- Cannot be empty
- Minimum 2 characters
- Trimmed of whitespace

✅ **ISBN** (Optional):

- Numeric validation
- Formatted correctly

### Security Best Practices

1. **Always validate on client AND server**:
   - Client: Immediate feedback to user
   - Server: Firestore Security Rules (prevent malicious writes)

2. **Use FieldValue.serverTimestamp()**:

   ```dart
   'createdAt': FieldValue.serverTimestamp() // Server time, not device time
   ```

3. **Trim user input**:

   ```dart
   final title = _titleController.text.trim(); // Remove leading/trailing spaces
   ```

4. **Check for null/empty values**:

   ```dart
   if (value == null || value.trim().isEmpty) {
     return 'Field is required';
   }
   ```

5. **Use try-catch for error handling**:
   ```dart
   try {
     await firestore.collection('books').add(data);
   } catch (e) {
     // Show user-friendly error message
   }
   ```

---

## 🧪 Testing & Screenshots

### Test Scenarios

1. **Add Operation**:
   - ✅ Add book with valid data
   - ✅ Try to add with empty title (should show validation error)
   - ✅ Try to add with short title (< 3 chars) (should fail)
   - ✅ Check Firestore console to verify document creation

2. **Update Operation**:
   - ✅ Select a book and update its title
   - ✅ Update only one field (others remain unchanged)
   - ✅ Verify `updatedAt` timestamp changes

3. **Delete Operation**:
   - ✅ Delete a book and verify removal from Firestore
   - ✅ Confirm deletion dialog appears

### Required Screenshots

📸 **Screenshot 1**: Add Book Form (filled with valid data)  
📸 **Screenshot 2**: Validation Error (empty title field)  
📸 **Screenshot 3**: Success SnackBar (book added)  
📸 **Screenshot 4**: Firestore Console (showing new document)  
📸 **Screenshot 5**: Update Book Form (editing existing book)  
📸 **Screenshot 6**: View All Tab (list of books with actions)

---

## 💡 Reflection

### 1. Why is Secure Data Writing Important?

**Answer**: Secure data writing prevents:

- **Data corruption**: Invalid data (e.g., empty titles, wrong types) breaks app functionality
- **Security vulnerabilities**: Malicious users could inject harmful data
- **Data consistency**: Ensures all documents follow the same structure
- **User trust**: Users expect their data to be handled safely

**Example**: Without validation, a user could add a book with an empty title, breaking search and display features.

---

### 2. ADD vs SET vs UPDATE: Key Differences

| Operation    | Document ID    | Creates New?          | Overwrites?              | Use Case                  |
| ------------ | -------------- | --------------------- | ------------------------ | ------------------------- |
| **add()**    | Auto-generated | Yes                   | N/A                      | New books, users, records |
| **set()**    | You specify    | Yes                   | Yes (unless merge)       | User profiles, settings   |
| **update()** | You specify    | No (fails if missing) | No (only updates fields) | Edit existing data        |

**Example**:

```dart
// ADD - Firestore creates ID: "aB3dE5fG7hI9"
await books.add({'title': 'New Book'});

// SET - You specify ID: "book_001"
await books.doc('book_001').set({'title': 'Book 1'});

// UPDATE - Modify existing "book_001"
await books.doc('book_001').update({'available': false});
```

---

### 3. How Does Validation Prevent Data Corruption?

**Answer**: Validation ensures only **clean, properly formatted data** enters Firestore.

**Without Validation**:

```dart
// BAD: User submits empty title
await books.add({'title': ''}); // ❌ Breaks search, sorting, UI display
```

**With Validation**:

```dart
// GOOD: Validate before writing
if (title.trim().isEmpty) {
  return 'Title is required'; // ❌ Stops submission
}

if (title.trim().length < 3) {
  return 'Title too short'; // ❌ Stops submission
}

await books.add({'title': title.trim()}); // ✅ Only clean data
```

**Benefits**:

- ✅ Consistent data structure
- ✅ Better search/filter results
- ✅ Prevents UI crashes from null/empty values
- ✅ Professional user experience

---

### 4. Real-World Example: Why Timestamps Matter

**Problem**: Using device time for `createdAt`:

```dart
'createdAt': DateTime.now() // ❌ Device time can be wrong
```

**Issues**:

- User's device clock is set to wrong time
- Time zones cause inconsistencies
- Can't trust timestamps for ordering

**Solution**: Use server timestamp:

```dart
'createdAt': FieldValue.serverTimestamp() // ✅ Always accurate
```

**Result**: All timestamps come from Firebase servers, ensuring consistency worldwide.

---

## 🎥 Video Demo Checklist

### 1-2 Minute Demo Script:

1. **Show Add Form** (10s)
   - Fill in book details (title, author, description)
   - Click "Add Book" button

2. **Trigger Validation Error** (10s)
   - Clear title field
   - Click "Add Book"
   - Show error message: "Title is required"

3. **Successfully Add Book** (15s)
   - Fill form with valid data
   - Click "Add Book"
   - Show success SnackBar: "✓ Book added successfully!"

4. **View Firestore Console** (15s)
   - Open Firebase Console
   - Navigate to Firestore Database
   - Show newly created document with auto-generated ID
   - Point out fields: title, author, createdAt, updatedAt

5. **Update Book** (20s)
   - Go to "Update" tab
   - Select a book from the list
   - Modify title
   - Click "Update Book"
   - Show success message

6. **Show Real-Time Updates** (15s)
   - Go to "View All" tab
   - Show updated book appears instantly
   - Demonstrate toggle availability switch

7. **Delete Book** (15s)
   - Click delete icon
   - Show confirmation dialog
   - Confirm deletion
   - Book disappears from list

**Total**: ~1.5 minutes

---

## 🎯 Key Takeaways

✅ **add()** - Auto-generated IDs, most common write operation  
✅ **set()** - Custom IDs, can merge or overwrite  
✅ **update()** - Modify specific fields, fails if document doesn't exist  
✅ **Validation** - Ensures data integrity, prevents corruption  
✅ **Error Handling** - Graceful failures with user-friendly messages  
✅ **Server Timestamps** - Use `FieldValue.serverTimestamp()` for accuracy

---

## 📚 Additional Resources

- [Firestore Write Documentation](https://firebase.google.com/docs/firestore/manage-data/add-data)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Form Validation](https://docs.flutter.dev/cookbook/forms/validation)

---

**Next Steps**: Implement Firestore Security Rules to enforce server-side validation and access control.

---

_Built with ❤️ by TeamNova for OpenShelf_
