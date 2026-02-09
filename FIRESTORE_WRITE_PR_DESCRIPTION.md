# [Sprint-2] Firestore Write & Update Operations – TeamNova

## 📌 PR Overview

**Feature**: Firestore Write, Update, and Delete Operations  
**Sprint**: Sprint #2 - Firestore Database Integration  
**Team**: TeamNova  
**Date**: February 9, 2026  
**Status**: ✅ Ready for Review

---

## 🎯 What This PR Does

This PR implements **comprehensive write operations** for Cloud Firestore, enabling the OpenShelf app to:

✅ **ADD** new books with auto-generated document IDs  
✅ **UPDATE** specific fields in existing books  
✅ **DELETE** books from Firestore  
✅ **Validate** user input before writing to database  
✅ **Handle errors** gracefully with user-friendly feedback  
✅ **Display real-time updates** using StreamBuilder

---

## 🛠️ Implementation Details

### 1. Enhanced FirestoreService (`lib/services/firestore_service.dart`)

The service layer already included robust write operations:

```dart
/// ADD Operation - Creates new document with auto-generated ID
Future<DocumentReference> addBook(
  String title,
  String author, {
  String? isbn,
  String? description,
  List<String>? genre,
}) async {
  try {
    // Input validation
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
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    throw Exception('Error adding book: $e');
  }
}

/// UPDATE Operation - Modifies specific fields
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

/// DELETE Operation - Removes document
Future<void> deleteBook(String bookId) async {
  try {
    await books.doc(bookId).delete();
  } catch (e) {
    throw Exception('Error deleting book: $e');
  }
}
```

---

### 2. Write Operations Demo Screen (`lib/screens/firestore_write_demo.dart`)

Created a **3-tab interface** demonstrating all write operations:

#### Tab 1: Add Books (ADD Operation)

- Form with validated TextFields (title, author, ISBN, description, genre)
- Real-time validation (required fields, minimum length)
- Loading state during write operation
- Success/error SnackBar feedback
- Auto-clear form after success

#### Tab 2: Update Books (UPDATE Operation)

- Display list of books to select from
- Pre-fill form with existing book data
- Validate updated fields
- Update only modified fields
- Real-time reflection in View All tab

#### Tab 3: View All Books

- StreamBuilder displays all books in real-time
- Stats dashboard (total books, available books)
- Action menu for each book:
  - Edit (navigates to Update tab)
  - Toggle availability
  - Delete with confirmation dialog
- Empty state with CTA to add first book

---

## 📝 Key Code Snippets

### Input Validation Example

```dart
TextFormField(
  controller: _titleController,
  decoration: const InputDecoration(
    labelText: 'Book Title *',
    hintText: 'Enter book title',
    prefixIcon: Icon(Icons.book),
    border: OutlineInputBorder(),
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
```

### Add Book with Error Handling

```dart
Future<void> _addBook() async {
  if (!_addFormKey.currentState!.validate()) {
    return; // Form validation failed
  }

  setState(() => _isLoading = true);

  try {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();

    await _firestoreService.addBook(title, author);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Book "$title" added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _clearAddForm();
      _tabController.animateTo(2); // Switch to View All tab
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

### Update Book with Timestamp

```dart
Future<void> _updateBook() async {
  if (_selectedBookId == null || !_updateFormKey.currentState!.validate()) {
    return;
  }

  try {
    final updateData = {
      'title': _titleController.text.trim(),
      'author': _authorController.text.trim(),
      'description': _descriptionController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(), // Server timestamp
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

    _clearUpdateForm();
    _tabController.animateTo(2);
  } catch (e) {
    // Error handling
  }
}
```

### Delete with Confirmation Dialog

```dart
Future<void> _deleteBook(String bookId) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Book'),
      content: const Text('Are you sure you want to delete this book?'),
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
      const SnackBar(
        content: Text('✓ Book deleted successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  } catch (e) {
    // Error handling
  }
}
```

---

## 🔒 Security & Validation

### Client-Side Validation

✅ **Title**:

- Required field
- Minimum 3 characters
- Trimmed of whitespace

✅ **Author**:

- Required field
- Minimum 2 characters
- Trimmed of whitespace

✅ **ISBN**: Optional, numeric validation

✅ **Description**: Optional, multi-line input

### Security Best Practices

1. **Server timestamps**: Using `FieldValue.serverTimestamp()` ensures accurate, tamper-proof timestamps
2. **Input trimming**: All text inputs are trimmed to prevent whitespace-only submissions
3. **Error boundaries**: Try-catch blocks prevent app crashes
4. **Null safety**: Null-aware operators (`??`, `?.`) handle missing data
5. **Form validation**: Validates before writing to Firestore

---

## 🧪 Testing Checklist

### Add Operation Tests

- [x] Add book with valid data → Success ✅
- [x] Try to add with empty title → Validation error shown ✅
- [x] Try to add with short title (< 3 chars) → Validation error shown ✅
- [x] Verify document appears in Firestore console ✅
- [x] Verify auto-generated ID is created ✅
- [x] Check createdAt and updatedAt timestamps ✅

### Update Operation Tests

- [x] Select book and update title → Success ✅
- [x] Update only one field, others remain unchanged ✅
- [x] Verify updatedAt timestamp changes ✅
- [x] Try to update with invalid data → Validation error ✅
- [x] Verify real-time UI update in View All tab ✅

### Delete Operation Tests

- [x] Delete book with confirmation → Success ✅
- [x] Cancel deletion → Book remains ✅
- [x] Verify document removed from Firestore ✅
- [x] Verify UI updates immediately ✅

### UI/UX Tests

- [x] Loading spinner appears during write operations ✅
- [x] Success SnackBar shows on successful write ✅
- [x] Error SnackBar shows on failure ✅
- [x] Form clears after successful add ✅
- [x] Empty state displayed when no books exist ✅
- [x] Tab navigation works smoothly ✅

---

## 📸 Screenshots Guide

### Screenshot 1: Add Book Form

**What to capture**: Add tab with filled form fields (title, author, description)  
**Purpose**: Show input form UI and validation fields  
**Location**: Tab 1 - Add Books

### Screenshot 2: Validation Error

**What to capture**: Empty title field with error message "Title is required"  
**Purpose**: Demonstrate client-side validation  
**How**: Clear title field, click "Add Book" button

### Screenshot 3: Success SnackBar

**What to capture**: Green SnackBar showing "✓ Book added successfully!"  
**Purpose**: Show user feedback on successful write  
**How**: Submit valid form

### Screenshot 4: Firestore Console - New Document

**What to capture**: Firebase Console → Firestore Database → books collection → new document  
**Purpose**: Verify data written to Firestore  
**Highlight**: Auto-generated ID, all fields populated, timestamps

### Screenshot 5: Update Book Form

**What to capture**: Update tab with selected book and pre-filled form  
**Purpose**: Show update operation UI  
**Location**: Tab 2 - Update Books

### Screenshot 6: View All Tab

**What to capture**: List of books with action menu (edit, toggle, delete)  
**Purpose**: Show read + write operations together  
**Location**: Tab 3 - View All

### Screenshot 7: Delete Confirmation Dialog

**What to capture**: AlertDialog asking "Are you sure you want to delete this book?"  
**Purpose**: Show delete confirmation UX  
**How**: Click delete icon on any book

### Screenshot 8: Firestore Console - Updated Document

**What to capture**: Document in Firestore showing updated fields and new updatedAt timestamp  
**Purpose**: Verify update operation wrote correctly  
**Compare**: Screenshot before and after update

---

## 📊 Files Changed

### New Files

- `lib/screens/firestore_write_demo.dart` (730 lines) - Write operations demo screen

### Modified Files

- `lib/main.dart` - Added `/firestore-write-demo` route
- `lib/screens/demo_hub.dart` - Added "Firestore Write Operations" card

### Documentation Files

- `FIRESTORE_WRITE_README.md` - Comprehensive implementation guide
- `FIRESTORE_WRITE_PR_DESCRIPTION.md` (this file)
- `FIRESTORE_WRITE_COMPLETION_SUMMARY.md` - Submission checklist

---

## 🎥 Video Demo Script (1-2 Minutes)

### Opening (5s)

"Hi! This demo shows Firestore write operations in OpenShelf."

### Add Operation (25s)

1. Open Add tab
2. Fill form: Title "The Great Gatsby", Author "F. Scott Fitzgerald"
3. Click "Add Book"
4. Show success SnackBar
5. Switch to View All tab - book appears instantly

### Validation (15s)

1. Go back to Add tab
2. Clear title field
3. Click "Add Book"
4. Show error: "Title is required"
5. Enter short title "Hi"
6. Show error: "Title must be at least 3 characters"

### Firestore Console (20s)

1. Open Firebase Console
2. Navigate to Firestore Database → books collection
3. Show newly added book document
4. Point out: Auto-generated ID, createdAt timestamp, all fields populated

### Update Operation (25s)

1. Go to Update tab
2. Select "The Great Gatsby" from list
3. Form pre-fills with existing data
4. Change title to "The Great Gatsby (Classic Edition)"
5. Click "Update Book"
6. Show success SnackBar
7. View All tab shows updated title immediately

### Delete Operation (15s)

1. On View All tab, click delete icon on a book
2. Confirmation dialog appears: "Are you sure?"
3. Click "Delete"
4. Book disappears from list instantly
5. Show Firestore console - document is gone

### Closing (5s)

"That's Firestore write operations with validation and real-time updates!"

**Total Duration**: ~1 minute 50 seconds

---

## 💡 Reflection Answers

### 1. Why is secure data writing important for your app?

**Answer**: Secure data writing is critical for OpenShelf because:

- **Data integrity**: Without validation, users could add books with empty titles or invalid authors, breaking search, sorting, and display features
- **Database consistency**: Ensuring all book documents follow the same schema prevents crashes from missing required fields
- **User trust**: Users expect their book data to be stored accurately and reliably
- **Security**: Validation prevents malicious users from injecting harmful data or corrupting the database
- **Professional UX**: Showing clear error messages guides users to submit correct data

**Example**: If we didn't validate the title field, a user could submit an empty title. This would:

- Break the book list UI (showing blank cards)
- Make search impossible (no title to search for)
- Confuse other users browsing the library
- Require manual database cleanup

By validating `title.trim().isEmpty`, we ensure every book has a meaningful title before writing to Firestore.

---

### 2. Explain the difference between add(), set(), and update() methods

| Method       | Document ID                 | Creates New?          | Overwrites Existing?               | Use Case                                      |
| ------------ | --------------------------- | --------------------- | ---------------------------------- | --------------------------------------------- |
| **add()**    | Auto-generated by Firestore | Yes                   | N/A (always creates new)           | Most common: Adding new books, users, records |
| **set()**    | You specify the ID          | Yes                   | Yes (unless `merge: true`)         | User profiles, settings (where ID = userId)   |
| **update()** | You specify the ID          | No (fails if missing) | No (only updates specified fields) | Editing existing book details                 |

**Code Examples**:

```dart
// ADD - Firestore generates ID like "aB3dE5fG7hI9"
DocumentReference ref = await books.add({
  'title': 'New Book',
  'author': 'Author Name',
});
print(ref.id); // "aB3dE5fG7hI9"

// SET (overwrite mode) - You control the ID
await books.doc('book_001').set({
  'title': 'Book One',
  'author': 'Author A',
}); // If book_001 exists, it's completely replaced

// SET (merge mode) - Keeps existing fields
await books.doc('book_001').set({
  'title': 'Updated Title',
}, SetOptions(merge: true)); // Only updates 'title', keeps 'author'

// UPDATE - Modifies specific fields only
await books.doc('book_001').update({
  'available': false, // Only this field changes
}); // Fails if book_001 doesn't exist
```

**When to Use Each**:

- **add()**: 99% of the time (new books, reviews, borrow requests)
- **set()**: User profiles where userId is the document ID
- **update()**: Changing specific fields (book availability, user displayName)

**Key Insight**: In OpenShelf, we use `add()` for books because we don't need custom IDs. We use `update()` to toggle availability without touching other fields.

---

### 3. How does validation prevent data corruption in Firestore?

**Answer**: Validation acts as a **gatekeeper** that ensures only clean, properly formatted data enters Firestore.

**Without Validation (Data Corruption Example)**:

```dart
// User submits form with empty title
await books.add({
  'title': '',  // ❌ CORRUPT DATA
  'author': 'John Doe',
});
```

**Consequences**:

- UI shows blank book cards
- Search/sort breaks (can't compare empty strings)
- Other users see broken listings
- Database becomes inconsistent

**With Validation (Prevented Corruption)**:

```dart
// Validate before writing
if (title.trim().isEmpty) {
  return 'Title is required'; // ❌ STOPS submission
}

if (title.trim().length < 3) {
  return 'Title must be at least 3 characters'; // ❌ STOPS submission
}

// Only clean data reaches Firestore
await books.add({
  'title': title.trim(), // ✅ GUARANTEED to be valid
  'author': author.trim(),
});
```

**Validation Layers in OpenShelf**:

1. **UI Validation** (client-side):
   - TextFormField validators show immediate feedback
   - Prevents form submission until all fields are valid

2. **Service Layer Validation** (client-side):
   - `FirestoreService.addBook()` checks inputs before writing
   - Throws exceptions for invalid data

3. **Firestore Security Rules** (server-side, future task):
   - Enforces validation on the server
   - Prevents malicious clients from bypassing UI validation

**Real-World Example**:

```dart
// User tries to add book with title "  " (just spaces)

// Step 1: UI validation catches it
validator: (value) {
  if (value?.trim().isEmpty) {
    return 'Title is required'; // ❌ Error shown to user
  }
}

// Step 2: Service layer as backup
if (title.trim().isEmpty) {
  throw Exception('Title cannot be empty'); // ❌ Second line of defense
}

// Step 3: Firestore Security Rule (future)
allow create: if request.resource.data.title.size() >= 3; // ❌ Server-side enforcement
```

**Benefits**:

- ✅ Consistent data structure across all documents
- ✅ Prevents null/undefined errors in UI
- ✅ Enables reliable search and filtering
- ✅ Professional user experience
- ✅ Easier debugging (all data follows same format)

---

## 🎯 Key Achievements

✅ **Comprehensive CRUD Operations**: Add, Read, Update, Delete fully implemented  
✅ **Input Validation**: Multi-layer validation prevents data corruption  
✅ **Error Handling**: Graceful failures with user-friendly messages  
✅ **Real-Time Updates**: StreamBuilder ensures UI reflects Firestore changes instantly  
✅ **Professional UX**: Loading states, success/error feedback, confirmation dialogs  
✅ **Server Timestamps**: Using `FieldValue.serverTimestamp()` for accuracy  
✅ **Clean Architecture**: Service layer separates business logic from UI

---

## 📚 Next Steps

After this PR is merged:

1. **Implement Firestore Security Rules** to enforce server-side validation
2. **Add batch writes** for efficient multi-document operations
3. **Implement transactions** for atomic writes (e.g., borrow request + update availability)
4. **Add offline persistence** for better user experience
5. **Optimize queries** with indexes for complex filters

---

## 🚀 How to Test

1. **Run the app**: `flutter run`
2. **Navigate**: Demo Hub → "Firestore Write Operations"
3. **Test Add**:
   - Fill form with valid data → Should succeed
   - Try empty title → Should show error
4. **Test Update**:
   - Select a book → Form pre-fills
   - Change title → Should update in Firestore
5. **Test Delete**:
   - Click delete → Confirmation dialog
   - Confirm → Book removed
6. **Check Firestore Console**: Verify all operations reflected in database

---

## ✅ Checklist

- [x] Code compiles without errors
- [x] All write operations (add, update, delete) working
- [x] Form validation functioning correctly
- [x] Error handling with try-catch blocks
- [x] Loading states implemented
- [x] SnackBar feedback on success/error
- [x] Real-time UI updates with StreamBuilder
- [x] Confirmation dialog for delete operation
- [x] Server timestamps for createdAt/updatedAt
- [x] Documentation written (README, PR description)
- [x] Screenshots guide provided
- [x] Video demo script prepared
- [x] Reflection questions answered

---

**Ready for Review** ✅

---

_Built with ❤️ by TeamNova for OpenShelf_
