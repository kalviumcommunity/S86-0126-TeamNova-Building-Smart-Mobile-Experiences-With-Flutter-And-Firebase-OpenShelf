# 📚 OpenShelf - Cloud Firestore Database Schema Design

## Project Description

**OpenShelf** is a community-driven book sharing and library management platform. The app enables users to share books, discover new reads, manage personal libraries, write reviews, and connect with other book enthusiasts. This document outlines the complete Firestore database architecture designed to support scalable, real-time book sharing experiences.

---

## 🎯 Data Requirements List

### Core Entities

Based on OpenShelf's functionality, the following data needs to be stored:

1. **Users**
   - User profiles (name, email, bio, avatar)
   - Authentication information
   - User preferences and settings
   - Joined date and activity metrics

2. **Books**
   - Book details (title, author, ISBN, description)
   - Genre and categories
   - Cover image URLs
   - Publication information
   - Availability status
   - Owner information

3. **User Libraries**
   - Personal book collections
   - Ownership records
   - Lending status
   - Reading lists (to-read, currently reading, finished)

4. **Reviews & Ratings**
   - Book reviews with ratings
   - User feedback
   - Timestamps
   - Helpfulness votes

5. **Borrow Requests**
   - Book lending transactions
   - Request status tracking
   - Borrower and lender information
   - Due dates and return status

6. **Categories/Genres**
   - Book categorization
   - Genre metadata
   - Discoverability

7. **Favorites/Wishlists**
   - User bookmarks
   - Wishlist items
   - Quick access collections

8. **Notifications**
   - User activity notifications
   - Borrow request alerts
   - Return reminders
   - System announcements

---

## 🗂️ Firestore Schema Design

### Schema Overview

```
firestore/
├── users/
│   └── {userId}/
│       ├── profile data
│       └── userBooks/ (subcollection)
│           └── {bookId}/
│               └── ownership data
│
├── books/
│   └── {bookId}/
│       ├── book metadata
│       └── reviews/ (subcollection)
│           └── {reviewId}/
│               └── review data
│
├── borrowRequests/
│   └── {requestId}/
│       └── transaction data
│
├── categories/
│   └── {categoryId}/
│       └── category data
│
└── notifications/
    └── {notificationId}/
        └── notification data
```

---

## 📋 Detailed Schema Structure

### 1. Users Collection

**Collection Path:** `users/{userId}`

**Document ID:** Firebase Auth UID (auto-generated)

**Fields:**

| Field Name      | Data Type | Description                             | Example                      |
| --------------- | --------- | --------------------------------------- | ---------------------------- |
| `userId`        | string    | Unique user identifier (same as doc ID) | "abc123xyz"                  |
| `email`         | string    | User email address                      | "asha@example.com"           |
| `displayName`   | string    | User's display name                     | "Asha Kumar"                 |
| `bio`           | string    | User biography (optional)               | "Book lover and avid reader" |
| `avatarUrl`     | string    | Profile picture URL                     | "https://..."                |
| `location`      | string    | User's city/area                        | "Bangalore, India"           |
| `booksOwned`    | number    | Count of books owned                    | 15                           |
| `booksLent`     | number    | Count of books currently lent           | 3                            |
| `booksBorrowed` | number    | Count of books currently borrowed       | 2                            |
| `rating`        | number    | User rating (1-5)                       | 4.5                          |
| `totalReviews`  | number    | Number of reviews written               | 12                           |
| `joinedAt`      | timestamp | Account creation date                   | Timestamp                    |
| `lastActive`    | timestamp | Last activity timestamp                 | Timestamp                    |
| `createdAt`     | timestamp | Document creation time                  | Timestamp                    |
| `updatedAt`     | timestamp | Last update time                        | Timestamp                    |

**Subcollection: userBooks**

**Path:** `users/{userId}/userBooks/{bookId}`

**Fields:**

| Field Name              | Data Type | Description                                             | Example           |
| ----------------------- | --------- | ------------------------------------------------------- | ----------------- |
| `bookId`                | string    | Reference to book document                              | "book_001"        |
| `status`                | string    | Book status: "available", "lent", "reading", "finished" | "available"       |
| `condition`             | string    | Book condition: "new", "good", "fair", "poor"           | "good"            |
| `isAvailableForLending` | boolean   | Whether book can be lent                                | true              |
| `currentBorrowerId`     | string    | Current borrower's userId (if lent)                     | "user_456"        |
| `addedAt`               | timestamp | When book was added to library                          | Timestamp         |
| `readingStatus`         | string    | "to-read", "reading", "finished"                        | "finished"        |
| `personalNotes`         | string    | User's personal notes about the book                    | "Great thriller!" |

---

### 2. Books Collection

**Collection Path:** `books/{bookId}`

**Document ID:** Auto-generated or ISBN-based

**Fields:**

| Field Name        | Data Type | Description                      | Example                   |
| ----------------- | --------- | -------------------------------- | ------------------------- |
| `bookId`          | string    | Unique book identifier           | "book_001"                |
| `title`           | string    | Book title                       | "The Alchemist"           |
| `author`          | string    | Author name                      | "Paulo Coelho"            |
| `isbn`            | string    | ISBN number                      | "978-0062315007"          |
| `description`     | string    | Book description/summary         | "A mystical journey..."   |
| `coverImageUrl`   | string    | Book cover image URL             | "https://..."             |
| `genre`           | array     | Array of genre strings           | ["Fiction", "Philosophy"] |
| `categories`      | array     | Category IDs                     | ["cat_001", "cat_002"]    |
| `publisher`       | string    | Publisher name                   | "HarperCollins"           |
| `publishedYear`   | number    | Publication year                 | 1988                      |
| `pageCount`       | number    | Number of pages                  | 208                       |
| `language`        | string    | Book language                    | "English"                 |
| `averageRating`   | number    | Average user rating (1-5)        | 4.7                       |
| `totalRatings`    | number    | Number of ratings                | 1250                      |
| `totalReviews`    | number    | Number of reviews                | 340                       |
| `copiesAvailable` | number    | Total available copies in system | 45                        |
| `totalCopies`     | number    | Total copies in system           | 78                        |
| `addedBy`         | string    | User who first added the book    | "user_123"                |
| `createdAt`       | timestamp | Document creation time           | Timestamp                 |
| `updatedAt`       | timestamp | Last update time                 | Timestamp                 |

**Subcollection: reviews**

**Path:** `books/{bookId}/reviews/{reviewId}`

**Fields:**

| Field Name      | Data Type | Description                        | Example                             |
| --------------- | --------- | ---------------------------------- | ----------------------------------- |
| `reviewId`      | string    | Unique review identifier           | "rev_001"                           |
| `userId`        | string    | Reviewer's user ID                 | "user_123"                          |
| `userName`      | string    | Reviewer's display name            | "Asha Kumar"                        |
| `userAvatarUrl` | string    | Reviewer's avatar                  | "https://..."                       |
| `rating`        | number    | Rating (1-5 stars)                 | 5                                   |
| `reviewText`    | string    | Review content                     | "Amazing book! Highly recommend..." |
| `helpfulCount`  | number    | Number of helpful votes            | 23                                  |
| `reportCount`   | number    | Number of reports (for moderation) | 0                                   |
| `createdAt`     | timestamp | Review creation time               | Timestamp                           |
| `updatedAt`     | timestamp | Last update time                   | Timestamp                           |

---

### 3. Borrow Requests Collection

**Collection Path:** `borrowRequests/{requestId}`

**Document ID:** Auto-generated

**Fields:**

| Field Name       | Data Type | Description                                                        | Example            |
| ---------------- | --------- | ------------------------------------------------------------------ | ------------------ |
| `requestId`      | string    | Unique request identifier                                          | "req_001"          |
| `bookId`         | string    | Reference to book                                                  | "book_001"         |
| `bookTitle`      | string    | Book title (denormalized for quick access)                         | "The Alchemist"    |
| `borrowerId`     | string    | User requesting to borrow                                          | "user_456"         |
| `borrowerName`   | string    | Borrower's name                                                    | "Rahul Sharma"     |
| `lenderId`       | string    | Book owner                                                         | "user_123"         |
| `lenderName`     | string    | Owner's name                                                       | "Asha Kumar"       |
| `status`         | string    | "pending", "approved", "rejected", "active", "returned", "overdue" | "active"           |
| `requestedAt`    | timestamp | When request was made                                              | Timestamp          |
| `approvedAt`     | timestamp | When request was approved                                          | Timestamp          |
| `borrowDate`     | timestamp | Actual borrow date                                                 | Timestamp          |
| `dueDate`        | timestamp | Expected return date                                               | Timestamp          |
| `returnedAt`     | timestamp | Actual return date                                                 | Timestamp          |
| `borrowDuration` | number    | Duration in days                                                   | 14                 |
| `notes`          | string    | Special instructions                                               | "Handle with care" |
| `createdAt`      | timestamp | Document creation time                                             | Timestamp          |
| `updatedAt`      | timestamp | Last update time                                                   | Timestamp          |

---

### 4. Categories Collection

**Collection Path:** `categories/{categoryId}`

**Document ID:** Auto-generated or slug-based

**Fields:**

| Field Name    | Data Type | Description                 | Example                         |
| ------------- | --------- | --------------------------- | ------------------------------- |
| `categoryId`  | string    | Unique category identifier  | "cat_001"                       |
| `name`        | string    | Category name               | "Science Fiction"               |
| `slug`        | string    | URL-friendly slug           | "science-fiction"               |
| `description` | string    | Category description        | "Futuristic and imaginative..." |
| `iconUrl`     | string    | Category icon/image         | "https://..."                   |
| `bookCount`   | number    | Number of books in category | 234                             |
| `color`       | string    | UI color code               | "#4CAF50"                       |
| `order`       | number    | Display order               | 1                               |
| `isActive`    | boolean   | Whether category is active  | true                            |
| `createdAt`   | timestamp | Document creation time      | Timestamp                       |

---

### 5. Notifications Collection

**Collection Path:** `notifications/{notificationId}`

**Document ID:** Auto-generated

**Fields:**

| Field Name       | Data Type | Description                                             | Example                    |
| ---------------- | --------- | ------------------------------------------------------- | -------------------------- |
| `notificationId` | string    | Unique notification identifier                          | "notif_001"                |
| `userId`         | string    | Recipient user ID                                       | "user_123"                 |
| `type`           | string    | "borrow_request", "return_reminder", "review", "system" | "borrow_request"           |
| `title`          | string    | Notification title                                      | "New Borrow Request"       |
| `message`        | string    | Notification message                                    | "Rahul wants to borrow..." |
| `actionUrl`      | string    | Deep link or action                                     | "/requests/req_001"        |
| `relatedId`      | string    | Related document ID                                     | "req_001"                  |
| `isRead`         | boolean   | Whether notification was read                           | false                      |
| `priority`       | string    | "low", "medium", "high"                                 | "medium"                   |
| `createdAt`      | timestamp | Notification creation time                              | Timestamp                  |
| `expiresAt`      | timestamp | Expiration time                                         | Timestamp                  |

---

## 📊 Sample JSON Documents

### Sample User Document

```json
{
  "userId": "abc123xyz",
  "email": "asha@example.com",
  "displayName": "Asha Kumar",
  "bio": "Passionate reader and book collector. Love sharing stories!",
  "avatarUrl": "https://storage.googleapis.com/openshelf/avatars/abc123xyz.jpg",
  "location": "Bangalore, India",
  "booksOwned": 15,
  "booksLent": 3,
  "booksBorrowed": 2,
  "rating": 4.5,
  "totalReviews": 12,
  "joinedAt": {
    "_seconds": 1704067200,
    "_nanoseconds": 0
  },
  "lastActive": {
    "_seconds": 1738627200,
    "_nanoseconds": 0
  },
  "createdAt": {
    "_seconds": 1704067200,
    "_nanoseconds": 0
  },
  "updatedAt": {
    "_seconds": 1738627200,
    "_nanoseconds": 0
  }
}
```

### Sample Book Document

```json
{
  "bookId": "book_001",
  "title": "The Alchemist",
  "author": "Paulo Coelho",
  "isbn": "978-0062315007",
  "description": "A mystical journey of an Andalusian shepherd boy pursuing his dreams across the Egyptian desert.",
  "coverImageUrl": "https://storage.googleapis.com/openshelf/covers/the-alchemist.jpg",
  "genre": ["Fiction", "Philosophy", "Adventure"],
  "categories": ["cat_001", "cat_003"],
  "publisher": "HarperCollins",
  "publishedYear": 1988,
  "pageCount": 208,
  "language": "English",
  "averageRating": 4.7,
  "totalRatings": 1250,
  "totalReviews": 340,
  "copiesAvailable": 45,
  "totalCopies": 78,
  "addedBy": "abc123xyz",
  "createdAt": {
    "_seconds": 1704067200,
    "_nanoseconds": 0
  },
  "updatedAt": {
    "_seconds": 1738627200,
    "_nanoseconds": 0
  }
}
```

### Sample UserBook Document (Subcollection)

```json
{
  "bookId": "book_001",
  "status": "lent",
  "condition": "good",
  "isAvailableForLending": false,
  "currentBorrowerId": "user_456",
  "addedAt": {
    "_seconds": 1710691200,
    "_nanoseconds": 0
  },
  "readingStatus": "finished",
  "personalNotes": "One of my all-time favorites! The journey and life lessons are incredible."
}
```

### Sample Review Document (Subcollection)

```json
{
  "reviewId": "rev_001",
  "userId": "abc123xyz",
  "userName": "Asha Kumar",
  "userAvatarUrl": "https://storage.googleapis.com/openshelf/avatars/abc123xyz.jpg",
  "rating": 5,
  "reviewText": "Amazing book! The Alchemist completely changed my perspective on following dreams. Highly recommend to anyone seeking inspiration and wisdom about life's journey.",
  "helpfulCount": 23,
  "reportCount": 0,
  "createdAt": {
    "_seconds": 1720627200,
    "_nanoseconds": 0
  },
  "updatedAt": {
    "_seconds": 1720627200,
    "_nanoseconds": 0
  }
}
```

### Sample Borrow Request Document

```json
{
  "requestId": "req_001",
  "bookId": "book_001",
  "bookTitle": "The Alchemist",
  "borrowerId": "user_456",
  "borrowerName": "Rahul Sharma",
  "lenderId": "abc123xyz",
  "lenderName": "Asha Kumar",
  "status": "active",
  "requestedAt": {
    "_seconds": 1737158400,
    "_nanoseconds": 0
  },
  "approvedAt": {
    "_seconds": 1737244800,
    "_nanoseconds": 0
  },
  "borrowDate": {
    "_seconds": 1737331200,
    "_nanoseconds": 0
  },
  "dueDate": {
    "_seconds": 1738540800,
    "_nanoseconds": 0
  },
  "borrowDuration": 14,
  "notes": "Will take good care of it!",
  "createdAt": {
    "_seconds": 1737158400,
    "_nanoseconds": 0
  },
  "updatedAt": {
    "_seconds": 1737331200,
    "_nanoseconds": 0
  }
}
```

### Sample Category Document

```json
{
  "categoryId": "cat_001",
  "name": "Science Fiction",
  "slug": "science-fiction",
  "description": "Futuristic and imaginative stories exploring technology and space",
  "iconUrl": "https://storage.googleapis.com/openshelf/icons/sci-fi.png",
  "bookCount": 234,
  "color": "#4CAF50",
  "order": 1,
  "isActive": true,
  "createdAt": {
    "_seconds": 1704067200,
    "_nanoseconds": 0
  }
}
```

### Sample Notification Document

```json
{
  "notificationId": "notif_001",
  "userId": "abc123xyz",
  "type": "borrow_request",
  "title": "New Borrow Request",
  "message": "Rahul Sharma wants to borrow 'The Alchemist' from your library",
  "actionUrl": "/requests/req_001",
  "relatedId": "req_001",
  "isRead": false,
  "priority": "medium",
  "createdAt": {
    "_seconds": 1737158400,
    "_nanoseconds": 0
  },
  "expiresAt": {
    "_seconds": 1739750400,
    "_nanoseconds": 0
  }
}
```

---

## 🔗 Firestore Schema Diagram

```mermaid
erDiagram
    USERS ||--o{ USER_BOOKS : owns
    USERS ||--o{ REVIEWS : writes
    USERS ||--o{ BORROW_REQUESTS : "requests/lends"
    USERS ||--o{ NOTIFICATIONS : receives
    BOOKS ||--o{ USER_BOOKS : "listed in"
    BOOKS ||--o{ REVIEWS : "has reviews"
    BOOKS ||--o{ BORROW_REQUESTS : "involved in"
    BOOKS }o--o{ CATEGORIES : "belongs to"

    USERS {
        string userId PK
        string email
        string displayName
        string bio
        string avatarUrl
        string location
        number booksOwned
        number booksLent
        number booksBorrowed
        number rating
        number totalReviews
        timestamp joinedAt
        timestamp lastActive
        timestamp createdAt
        timestamp updatedAt
    }

    USER_BOOKS {
        string bookId PK_FK
        string status
        string condition
        boolean isAvailableForLending
        string currentBorrowerId FK
        timestamp addedAt
        string readingStatus
        string personalNotes
    }

    BOOKS {
        string bookId PK
        string title
        string author
        string isbn
        string description
        string coverImageUrl
        array genre
        array categories
        string publisher
        number publishedYear
        number pageCount
        string language
        number averageRating
        number totalRatings
        number totalReviews
        number copiesAvailable
        number totalCopies
        string addedBy FK
        timestamp createdAt
        timestamp updatedAt
    }

    REVIEWS {
        string reviewId PK
        string userId FK
        string userName
        string userAvatarUrl
        number rating
        string reviewText
        number helpfulCount
        number reportCount
        timestamp createdAt
        timestamp updatedAt
    }

    BORROW_REQUESTS {
        string requestId PK
        string bookId FK
        string bookTitle
        string borrowerId FK
        string borrowerName
        string lenderId FK
        string lenderName
        string status
        timestamp requestedAt
        timestamp approvedAt
        timestamp borrowDate
        timestamp dueDate
        timestamp returnedAt
        number borrowDuration
        string notes
        timestamp createdAt
        timestamp updatedAt
    }

    CATEGORIES {
        string categoryId PK
        string name
        string slug
        string description
        string iconUrl
        number bookCount
        string color
        number order
        boolean isActive
        timestamp createdAt
    }

    NOTIFICATIONS {
        string notificationId PK
        string userId FK
        string type
        string title
        string message
        string actionUrl
        string relatedId
        boolean isRead
        string priority
        timestamp createdAt
        timestamp expiresAt
    }
```

---

## 🏗️ Design Decisions & Rationale

### 1. Why Subcollections for UserBooks and Reviews?

**Decision:** Use subcollections instead of embedding data in parent documents.

**Rationale:**

- **Scalability:** A user can own hundreds of books, and a popular book can have thousands of reviews. Firestore documents have a 1MB size limit.
- **Performance:** Loading all reviews or user books at once would be inefficient. Subcollections allow pagination and on-demand loading.
- **Real-time Updates:** Subcollections can be queried independently with real-time listeners.
- **Cost Efficiency:** You only pay for documents you read. With subcollections, you can load 10 reviews at a time instead of all 1000.

### 2. Top-Level Collection for Borrow Requests

**Decision:** Keep borrow requests as a top-level collection rather than a subcollection under users or books.

**Rationale:**

- **Two-Way Relationships:** Borrow requests involve both a borrower and a lender. A top-level collection makes it easier to query from both perspectives.
- **Independent Queries:** We can query all pending requests, all overdue books, or filter by borrower/lender without complex queries.
- **Notification Integration:** Easier to trigger notifications and track transaction history.

### 3. Data Denormalization

**Decision:** Store `userName`, `bookTitle`, `borrowerName`, etc., in documents where they're needed.

**Rationale:**

- **Read Optimization:** NoSQL databases optimize for reads. Storing denormalized data reduces the need for multiple document lookups.
- **Performance:** Displaying a list of borrow requests with book titles and user names requires no joins.
- **Trade-off:** We accept potential data inconsistency (if a user changes their name) for better read performance. We can implement Cloud Functions to update denormalized data when needed.

### 4. Separate Categories Collection

**Decision:** Use a dedicated categories collection instead of just storing genre arrays in books.

**Rationale:**

- **Centralized Management:** Categories can be managed, updated, and displayed consistently.
- **Metadata:** Categories can have additional properties (icons, colors, descriptions).
- **UI Consistency:** Category colors and icons provide a better user experience.
- **Filtering:** Easier to query and filter books by category.

### 5. Notification Collection Structure

**Decision:** Store notifications in a top-level collection filtered by `userId`.

**Rationale:**

- **Query Efficiency:** Firestore queries are fast when filtering on indexed fields like `userId`.
- **Scalability:** Easier to implement pagination and mark as read/unread.
- **Cleanup:** Easier to delete old notifications with Cloud Functions based on `expiresAt`.
- **Cross-Platform:** Same notification system works for push notifications, in-app notifications, and email.

### 6. Timestamp Strategy

**Decision:** Use Firestore server timestamps (`FieldValue.serverTimestamp()`) for all time-based fields.

**Rationale:**

- **Consistency:** Server timestamps eliminate timezone issues and client clock errors.
- **Sorting:** Reliable for sorting and ordering queries.
- **Audit Trail:** `createdAt` and `updatedAt` provide a complete audit trail.

### 7. Field Naming Conventions

**Decision:** Use lowerCamelCase for all field names.

**Rationale:**

- **Dart/Flutter Alignment:** Matches Dart naming conventions for seamless serialization.
- **Consistency:** Industry standard for JSON and NoSQL databases.
- **Readability:** Clear and easy to understand.

---

## 📈 Scalability Considerations

### How This Schema Scales

1. **User Growth (1,000 → 1,000,000 users)**
   - Each user document is independent
   - Firestore automatically shards and distributes data
   - Subcollections prevent document size bloat
   - Composite indexes enable fast queries

2. **Book Catalog Growth**
   - Books collection can scale to millions of documents
   - Reviews as subcollections prevent size limits
   - Category filtering remains efficient with proper indexing

3. **Transaction Volume**
   - Borrow requests as a top-level collection scale independently
   - Status-based queries (pending, active, overdue) remain fast
   - Batch operations for notifications prevent bottlenecks

4. **Read/Write Optimization**
   - Denormalized data reduces read operations
   - Subcollections enable pagination
   - Real-time listeners only on necessary queries

---

## 🔍 Query Patterns & Indexes

### Common Queries

1. **Get all books in a category**

   ```
   books
     .where('categories', 'array-contains', 'cat_001')
     .orderBy('averageRating', 'desc')
   ```

   **Index Required:** Composite on `categories` and `averageRating`

2. **Get user's available books**

   ```
   users/{userId}/userBooks
     .where('isAvailableForLending', '==', true)
   ```

   **Index:** Single field on `isAvailableForLending`

3. **Get pending borrow requests for a lender**

   ```
   borrowRequests
     .where('lenderId', '==', 'abc123xyz')
     .where('status', '==', 'pending')
   ```

   **Index:** Composite on `lenderId` and `status`

4. **Get overdue borrow requests**

   ```
   borrowRequests
     .where('status', '==', 'active')
     .where('dueDate', '<', today)
   ```

   **Index:** Composite on `status` and `dueDate`

5. **Get unread notifications for a user**
   ```
   notifications
     .where('userId', '==', 'abc123xyz')
     .where('isRead', '==', false)
     .orderBy('createdAt', 'desc')
   ```
   **Index:** Composite on `userId`, `isRead`, and `createdAt`

---

## ✅ Schema Validation Checklist

- [x] **Matches app requirements:** All core features (users, books, lending, reviews) are covered
- [x] **Scalable:** Subcollections and proper indexing support millions of records
- [x] **Logically grouped:** Related data is organized hierarchically
- [x] **Subcollections used appropriately:** UserBooks and Reviews are subcollections to prevent size limits
- [x] **Consistent naming:** lowerCamelCase used throughout
- [x] **Proper data types:** Strings, numbers, booleans, arrays, maps, and timestamps used correctly
- [x] **Easy to understand:** Clear structure and comprehensive documentation
- [x] **Query-optimized:** Designed with common query patterns in mind
- [x] **Denormalization applied:** Balance between normalization and read performance
- [x] **Audit trail:** All collections have `createdAt` and `updatedAt` timestamps

---

## 🎓 Reflection

### Why Did We Choose This Structure?

The OpenShelf Firestore schema was designed with **real-world usage patterns** in mind:

1. **Community-Driven:** Users are central to the experience. The schema makes it easy to track user activity, reputation, and contributions.

2. **Book-Centric:** Books can exist independently but are linked to user libraries. This allows multiple users to own the same book while tracking individual copies.

3. **Transaction Management:** Borrow requests as a top-level collection enable complex queries from both borrower and lender perspectives.

4. **Discoverability:** Categories and reviews make it easy for users to discover new books and make informed decisions.

5. **Real-Time Features:** The structure supports real-time updates for notifications, borrow request status changes, and book availability.

### How Will This Help With Performance and Scalability?

1. **Efficient Reads:** Denormalized data (storing book titles in borrow requests) eliminates expensive joins.

2. **Paginated Queries:** Subcollections allow loading reviews and user books in batches (10-50 at a time).

3. **Indexed Queries:** All common query patterns have been identified and can be indexed for sub-100ms response times.

4. **Document Size Management:** Subcollections prevent hitting the 1MB document size limit even with thousands of reviews or books.

5. **Real-Time Listeners:** Structured to minimize the number of documents watched, reducing costs and improving performance.

### What Challenges Did We Face While Designing the Schema?

1. **Normalization vs. Denormalization:**
   - **Challenge:** Deciding whether to store user names and book titles in borrow requests or just IDs.
   - **Solution:** Chose denormalization for better read performance, accepting the trade-off of potential data inconsistency.

2. **Subcollection vs. Top-Level Collection:**
   - **Challenge:** Should borrow requests be under users or books?
   - **Solution:** Made it a top-level collection to enable two-way queries (by borrower and by lender).

3. **Review Scalability:**
   - **Challenge:** A popular book could have 10,000+ reviews. How do we prevent this from slowing down queries?
   - **Solution:** Reviews as a subcollection with pagination and sorting by helpfulness/date.

4. **Notification Management:**
   - **Challenge:** Notifications can grow indefinitely. How do we prevent cluttering the database?
   - **Solution:** Added `expiresAt` field for automatic cleanup with Cloud Functions.

5. **Search Functionality:**
   - **Challenge:** Firestore doesn't support full-text search natively.
   - **Future Solution:** Plan to integrate Algolia or use Cloud Functions to sync with Elasticsearch for advanced search.

---

## 🚀 Next Steps

1. **Implement CRUD Operations:** Create services for adding, reading, updating, and deleting documents.
2. **Set Up Firestore Security Rules:** Define who can read/write which documents.
3. **Create Composite Indexes:** Add indexes for common query patterns.
4. **Implement Cloud Functions:** Automate tasks like updating denormalized data and sending notifications.
5. **Add Offline Support:** Configure Firestore persistence for offline-first experiences.
6. **Integrate Search:** Add Algolia or Elasticsearch for full-text search.

---

## 📚 Resources

- [Firestore Data Modeling Guide](https://firebase.google.com/docs/firestore/manage-data/structure-data)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [NoSQL vs SQL Explanation](https://firebase.google.com/docs/database/rtdb-vs-firestore)
- [Firestore Structure Examples](https://firebase.google.com/docs/firestore/data-model)

---

**Document Version:** 1.0  
**Last Updated:** February 4, 2026  
**Team:** Team Nova  
**Sprint:** #2 - Firebase Integration
