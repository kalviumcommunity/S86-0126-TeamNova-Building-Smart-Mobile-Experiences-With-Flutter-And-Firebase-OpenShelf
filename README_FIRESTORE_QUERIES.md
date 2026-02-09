# 🔍 Firestore Queries & Filtering - OpenShelf

## Project Overview

This implementation demonstrates **comprehensive Firestore query capabilities** including filters, sorting, and pagination in the OpenShelf Flutter app. The project showcases how to efficiently retrieve only the data you need using WHERE conditions, ORDER BY sorting, LIMIT clauses, and real-time StreamBuilder updates.

**Key Achievement:** Successfully implemented advanced Firestore queries with multiple filter types, sorting options, and pagination for building fast, responsive mobile apps.

---

## 🎯 Query Types Implemented

### 1. Equality Filters (WHERE with isEqualTo)

Filter documents where a field matches a specific value:

```dart
// Get books in stock
Stream<QuerySnapshot> getBooksInStock() {
  return books.where('available', isEqualTo: true).snapshots();
}
```

**Use Case:** Filter available books, active users, completed tasks

---

### 2. Comparison Filters (>, <, >=, <=)

Filter documents based on numeric or date comparisons:

```dart
// Get books with price greater than specified amount
Stream<QuerySnapshot> getBooksAbovePrice(double price) {
  return books.where('price', isGreaterThan: price).snapshots();
}

// Get highly rated books (rating >= 4.0)
Stream<QuerySnapshot> getHighlyRatedBooks() {
  return books
      .where('averageRating', isGreaterThanOrEqualTo: 4.0)
      .orderBy('averageRating', descending: true)
      .snapshots();
}
```

**Use Cases:**

- Price filtering (e-commerce)
- Rating thresholds (reviews)
- Age restrictions (content filtering)
- Date ranges (analytics)

---

### 3. Array Filters (arrayContains)

Filter documents where an array field contains a specific value:

```dart
// Get books by specific genre
Stream<QuerySnapshot> getBooksByGenre(String genre) {
  return books.where('genre', arrayContains: genre).snapshots();
}
```

**Use Cases:**

- Tags/categories (blogs, products)
- Permissions (user roles)
- Features (app capabilities)

---

### 4. Sorting with ORDER BY

Sort query results in ascending or descending order:

```dart
// Sort by creation date (newest first)
Stream<QuerySnapshot> getBooksSortedByNewest() {
  return books.orderBy('createdAt', descending: true).snapshots();
}

// Sort alphabetically by title
Stream<QuerySnapshot> getBooksSortedByTitle() {
  return books.orderBy('title').snapshots();
}

// Sort by rating (highest first)
Stream<QuerySnapshot> getBooksSortedByRating() {
  return books.orderBy('averageRating', descending: true).snapshots();
}
```

**Use Cases:**

- Recent posts/articles
- Alphabetical lists
- Top-rated products
- Price sorting (low to high, high to low)

---

### 5. Pagination with LIMIT

Limit the number of documents returned for performance:

```dart
// Get top N books
Stream<QuerySnapshot> getTopBooks(int limit) {
  return books
      .orderBy('averageRating', descending: true)
      .limit(limit)
      .snapshots();
}

// Get recent books with limit
Stream<QuerySnapshot> getRecentBooks(int limit) {
  return books
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots();
}
```

**Benefits:**

- ✅ Faster initial page loads
- ✅ Reduced bandwidth usage
- ✅ Better user experience
- ✅ Lower Firestore read costs

---

### 6. Combined Queries (Filter + Sort)

Combine multiple conditions for powerful queries:

```dart
// Get available books sorted by rating
Stream<QuerySnapshot> getAvailableBooksByRating() {
  return books
      .where('available', isEqualTo: true)
      .orderBy('averageRating', descending: true)
      .snapshots();
}

// Get premium books (available + highly rated)
Stream<QuerySnapshot> getPremiumBooks() {
  return books
      .where('available', isEqualTo: true)
      .where('averageRating', isGreaterThanOrEqualTo: 4.5)
      .orderBy('averageRating', descending: true)
      .snapshots();
}

// Get books in price range
Stream<QuerySnapshot> getBooksInPriceRange(double minPrice, double maxPrice) {
  return books
      .where('price', isGreaterThanOrEqualTo: minPrice)
      .where('price', isLessThanOrEqualTo: maxPrice)
      .orderBy('price')
      .snapshots();
}
```

**Use Cases:**

- Filtered product catalogs
- Search with filters
- Advanced filtering interfaces

---

### 7. Dynamic Filtering

Build queries dynamically based on user input:

```dart
Stream<QuerySnapshot> getFilteredBooks({
  bool? available,
  String? genre,
  double? minRating,
  int? limit,
}) {
  Query query = books;

  if (available != null) {
    query = query.where('available', isEqualTo: available);
  }

  if (genre != null) {
    query = query.where('genre', arrayContains: genre);
  }

  if (minRating != null) {
    query = query.where('averageRating', isGreaterThanOrEqualTo: minRating);
    query = query.orderBy('averageRating', descending: true);
  } else {
    query = query.orderBy('createdAt', descending: true);
  }

  if (limit != null) {
    query = query.limit(limit);
  }

  return query.snapshots();
}
```

---

## 📖 UI Implementation with StreamBuilder

### Real-Time Filtered List

```dart
StreamBuilder<QuerySnapshot>(
  stream: _firestoreService.getAvailableBooksByRating(),
  builder: (context, snapshot) {
    // Loading state
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    // Empty state
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text('No books match your query'),
      );
    }

    // Data state - display filtered results
    final books = snapshot.data!.docs;

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final data = book.data() as Map<String, dynamic>;

        return ListTile(
          title: Text(data['title']),
          subtitle: Text('Rating: ${data['averageRating']}'),
          trailing: Icon(
            data['available'] ? Icons.check_circle : Icons.block,
            color: data['available'] ? Colors.green : Colors.red,
          ),
        );
      },
    );
  },
);
```

---

## 🎨 Interactive Query Demo Features

The `FirestoreQueriesDemo` screen includes:

### Filter Controls

- ✅ Query type selector (All, In Stock, By Genre, High Rated, etc.)
- ✅ Sort order selector (Newest, Title A-Z, Rating, Price)
- ✅ Genre dropdown filter
- ✅ Rating slider (minimum rating filter)
- ✅ Price range sliders (min/max)
- ✅ Result limit slider

### Real-Time Results Display

- ✅ Live query results with StreamBuilder
- ✅ Result count indicator
- ✅ Loading states with progress indicators
- ✅ Error states with retry functionality
- ✅ Empty states with helpful messages
- ✅ Detailed book cards with ratings, price, availability

### Query Info Panel

- ✅ Shows active query string
- ✅ Displays current filters and sorting
- ✅ Real-time query description updates

---

## 📊 Firestore Console Data

### Sample Books Collection Structure

```
books/
  ├── book_001
  │   ├── title: "The Great Gatsby"
  │   ├── author: "F. Scott Fitzgerald"
  │   ├── genre: ["Fiction", "Classic"]
  │   ├── available: true
  │   ├── averageRating: 4.5
  │   ├── price: 15.99
  │   ├── createdAt: Timestamp
  │   └── updatedAt: Timestamp
  │
  ├── book_002
  │   ├── title: "A Brief History of Time"
  │   ├── author: "Stephen Hawking"
  │   ├── genre: ["Science", "Non-Fiction"]
  │   ├── available: false
  │   ├── averageRating: 4.8
  │   ├── price: 24.99
  │   └── ...
  │
  └── book_003
      └── ...
```

### Required Fields for Queries

- `title` (string) - Book name
- `author` (string) - Author name
- `genre` (array) - Categories/genres
- `available` (boolean) - Stock status
- `averageRating` (number) - Rating score
- `price` (number) - Book price
- `createdAt` (timestamp) - Creation date

---

## 🚀 How Queries Improve UX

### Performance Benefits

**Without Queries (Bad):**

1. Fetch ALL 10,000 books from Firestore
2. Filter in Flutter code
3. Sort in Flutter code
4. Display first 20
5. **Result:** Slow, expensive, poor UX

**With Queries (Good):**

1. Firestore filters to 50 matching books
2. Firestore sorts by rating
3. Firestore returns top 20
4. Display immediately
5. **Result:** Fast, cheap, excellent UX

### Real-World Impact

- ⚡ **10x faster** initial load times
- 💰 **90% reduction** in Firestore read costs
- 📱 **Better mobile experience** with less data transfer
- 🔄 **Real-time updates** only for relevant data

---

## ⚠️ Common Query Mistakes & Solutions

### 1. Using orderBy without an index

**Problem:**

```dart
books
  .where('available', isEqualTo: true)
  .orderBy('createdAt')
  .snapshots();
```

**Error:** "The query requires an index"

**Solution:**

- Click the error link in console
- Firebase automatically creates the composite index
- Wait 2-3 minutes for index to build
- Query works automatically

---

### 2. WHERE + ORDER BY on different fields

**Problem:**

```dart
books
  .where('status', isEqualTo: 'active')
  .orderBy('rating') // Different field!
  .snapshots();
```

**Solution:** Requires composite index (Firebase will prompt you)

**Rule:** When using WHERE + ORDER BY, you need an index unless:

- Ordering by the same field as WHERE inequality
- Only one WHERE clause with equality

---

### 3. Multiple inequality filters

**Problem:**

```dart
books
  .where('price', isGreaterThan: 10)
  .where('rating', isGreaterThan: 4) // Can't do this!
  .snapshots();
```

**Firestore Limitation:** Only ONE inequality filter per query

**Solution:** Use range on one field, filter in code for the other

---

### 4. Querying unindexed fields

**Problem:** Slow reads, expensive queries

**Solution:**

- Always index fields used in queries
- Use Firestore console to create single-field indexes
- Composite indexes created automatically via error prompts

---

### 5. Too many filters

**Problem:** Complex queries are hard to index and slow

**Solution:**

- Keep queries simple
- Use denormalization (duplicate data for faster reads)
- Consider structuring collections differently

---

## 🎯 Best Practices

### 1. Always Index Query Fields

✅ Create indexes for all fields used in WHERE and ORDER BY
✅ Use composite indexes for combined queries
✅ Monitor index usage in Firebase console

### 2. Use Timestamps for Sorting

```dart
books.orderBy('createdAt', descending: true)
```

- Provides consistent ordering
- Useful for "recent" queries
- Better than sorting by document ID

### 3. Keep Field Names Consistent

✅ Use same field names across all documents
✅ Avoid typos (rating vs ratings)
✅ Use camelCase convention

### 4. Avoid Deep Nesting for Filters

❌ Don't query nested maps deeply
✅ Flatten important fields to top level
✅ Use denormalization when needed

### 5. StreamBuilder for Live Data, FutureBuilder for One-Time

```dart
// Real-time updates (chat, notifications)
StreamBuilder<QuerySnapshot>(...)

// One-time reads (search results, details page)
FutureBuilder<QuerySnapshot>(...)
```

### 6. Use LIMIT for Initial Loads

```dart
// Good for performance
books.limit(20).snapshots()

// Bad for mobile (too much data)
books.snapshots() // Could be 10,000 documents!
```

### 7. Pagination for Long Lists

```dart
// Page 1
books.orderBy('createdAt').limit(20)

// Page 2
books.orderBy('createdAt').startAfter(lastDoc).limit(20)
```

---

## 📱 Screenshots Guide

### Required Screenshots

1. **Firestore Console - Books Collection**
   - Show collection structure
   - Display sample documents with all fields
   - Highlight indexes tab

2. **App - All Books Query**
   - Show complete list with various books
   - Display query type selector
   - Result count visible

3. **App - Filtered Query (In Stock)**
   - Only available books shown
   - Green availability indicators
   - Filter chip highlighted

4. **App - Sorted by Rating**
   - Books ordered highest to lowest
   - Star ratings visible
   - Sort order chip selected

5. **App - Price Range Filter**
   - Sliders showing min/max
   - Only books in range displayed
   - Query description panel

6. **App - Combined Filters**
   - Multiple filters active
   - Complex query description
   - Real-time results

7. **App - Real-Time Update**
   - Before: Old data
   - Change in Firestore console
   - After: UI updated automatically

---

## 🎓 Reflection Questions & Answers

### 1. Which query types did you use in your implementation?

**Answer:**
I implemented **7 comprehensive query types**:

1. **Equality filters** - `where('available', isEqualTo: true)` for stock filtering
2. **Comparison filters** - `isGreaterThan`, `isLessThan`, `isGreaterThanOrEqualTo` for price and rating ranges
3. **Array filters** - `arrayContains` for genre-based filtering
4. **Sorting** - `orderBy` with ascending/descending for title, rating, price, date sorting
5. **Pagination** - `limit()` for performance optimization
6. **Combined queries** - Multiple WHERE clauses with ORDER BY for complex filtering
7. **Dynamic queries** - Build queries conditionally based on user selections

---

### 2. How does filtering/sorting improve UX?

**Answer:**

**Performance Improvements:**

- ⚡ **Faster load times** - Only fetches relevant data instead of entire collection
- 💾 **Reduced bandwidth** - Less data transferred over network (critical for mobile)
- 💰 **Lower costs** - Fewer Firestore reads = lower Firebase bills
- 🔋 **Better battery life** - Less processing on device

**User Experience Benefits:**

- 🎯 **Relevant results** - Users see exactly what they're looking for
- 🚀 **Instant feedback** - Real-time updates as filters change
- 📊 **Better organization** - Sorted lists are easier to scan
- 🔍 **Powerful search** - Combine filters for precise results

**Example:**

- **Without filters:** User scrolls through 500 books to find science fiction
- **With filters:** User selects "Science Fiction" genre and sees 23 relevant books instantly

---

### 3. Index errors encountered and how you fixed them

**Answer:**

**Error 1: Composite Index Required**

```
The query requires an index. You can create it here:
https://console.firebase.google.com/...
```

**When:** Combining WHERE filter with ORDER BY on different field:

```dart
books
  .where('available', isEqualTo: true)
  .orderBy('averageRating', descending: true)
```

**Fix:**

1. Clicked the provided console link
2. Firebase showed required index: `available (ASC) + averageRating (DESC)`
3. Clicked "Create Index"
4. Waited 2-3 minutes for index to build
5. Query worked automatically after index ready

---

**Error 2: ORDER BY and WHERE on Different Fields**

```
Invalid query. You must use orderBy() with the same field  as where()
when doing inequality comparisons.
```

**When:** Using price range with date sorting:

```dart
books
  .where('price', isGreaterThanOrEqualTo: minPrice)
  .where('price', isLessThanOrEqualTo: maxPrice)
  .orderBy('createdAt') // Different field!
```

**Fix:** Changed ORDER BY to the same field:

```dart
books
  .where('price', isGreaterThanOrEqualTo: minPrice)
  .where('price', isLessThanOrEqualTo: maxPrice)
  .orderBy('price') // Same field as WHERE
```

---

**Error 3: Multiple Inequality Filters**

```
Invalid query. All where filters with an inequality
must be on the same field.
```

**When:** Trying to filter by both price AND rating ranges:

```dart
books
  .where('price', isGreaterThan: 10)
  .where('rating', isGreaterThan: 4) // Can't do both!
```

**Fix:** Firestore limitation - only ONE inequality filter allowed

- Use range on one field (price)
- Filter the other field in Dart code or restructure query

---

### 4. Why Firestore-level filtering is better than client-side?

**Answer:**

**Firestore-Level Filtering (✅ GOOD):**

```dart
// Fetch only available books
books.where('available', isEqualTo: true).snapshots()
// Firestore returns: 50 documents
```

**Benefits:**

- Only fetches 50 relevant documents
- Less bandwidth usage
- Faster queries
- Lower Firestore costs
- Better mobile performance

---

**Client-Side Filtering (❌ BAD):**

```dart
// Fetch ALL books, filter in Flutter
books.snapshots()
// Firestore returns: 500 documents
// Flutter filters to: 50 needed documents
```

**Problems:**

- Downloads 10x more data than needed
- Wastes bandwidth (expensive on mobile)
- Higher Firestore read costs (10x)
- Slower user experience
- Device battery drain

---

## 🏗️ Project Structure

```
openshelf_app/
├── lib/
│   ├── services/
│   │   └── firestore_service.dart         # Query methods
│   ├── screens/
│   │   └── firestore_queries_demo.dart    # UI demonstration
│   └── main.dart                           # Routes & navigation
├── README_FIRESTORE_QUERIES.md             # This file
└── pubspec.yaml                            # Dependencies
```

---

## 📦 Dependencies

```yaml
dependencies:
  cloud_firestore: ^5.6.12
  firebase_core: ^3.15.2
```

---

## 🎬 Video Demo Script

### Video Structure (1-2 minutes)

**Opening (10 seconds):**
"Hi, this is [Your Name] demonstrating Firestore queries and filtering in OpenShelf"

**Demo Part 1 - Basic Filters (20 seconds):**

1. Open app to Firestore Queries Demo
2. Show "All Books" query with count
3. Switch to "In Stock" filter
4. Point out: "Notice only available books are displayed - filtered at Firestore level"

**Demo Part 2 - Sorting (15 seconds):**

1. Change sort order to "Rating (High)"
2. Show books reordered by rating
3. Switch to "Price (Low)"
4. Point out: "Real-time sorting without page refresh"

**Demo Part 3 - Combined Filters (20 seconds):**

1. Select "By Genre" filter
2. Choose "Science" genre
3. Adjust minimum rating slider
4. Show query description panel
5. Point out: "Multiple filters combined in one query"

**Demo Part 4 - Firestore Console (20 seconds):**

1. Open Firestore console in browser
2. Show books collection
3. Show indexes tab
4. Point out: "Composite indexes created for combined queries"

**Demo Part 5 - Real-Time Updates (20 seconds):**

1. Show app with current data
2. Update a book in Firestore console (change rating or availability)
3. Switch back to app
4. Point out: "UI updated instantly without refresh - that's the power of StreamBuilder with Firestore queries"

**Closing (5 seconds):**
"This demonstrates efficient data retrieval using WHERE, ORDER BY, and LIMIT for fast, responsive apps"

---

## 🚀 Running the Demo

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Run the app:**

   ```bash
   flutter run
   ```

3. **Navigate to demo:**
   - Home → Demo Hub → "🔍 Firestore Queries & Filtering"

4. **Add sample data:**
   - Click "Add Sample Book" button
   - Add 10-15 books with various genres, ratings, prices

5. **Test queries:**
   - Try different filter combinations
   - Change sort orders
   - Adjust sliders for rating and price
   - Watch real-time updates

---

## ✅ Task Checklist

### Core Requirements

- [x] Firestore dependency (`cloud_firestore: ^5.6.12`)
- [x] WHERE filters implemented (equality, comparison, array)
- [x] ORDER BY sorting (ascending, descending)
- [x] LIMIT for pagination
- [x] StreamBuilder for real-time updates
- [x] UI displays filtered/sorted results

### Advanced Features

- [x] Multiple query types (7 different patterns)
- [x] Dynamic query builder
- [x] Combined filters (WHERE + ORDER BY)
- [x] Interactive filter controls
- [x] Price range filtering
- [x] Rating threshold filtering
- [x] Genre filtering
- [x] Real-time query description
- [x] Loading, error, empty states
- [x] Result count display

### Documentation

- [x] Comprehensive README
- [x] Code snippets with explanations
- [x] Screenshots guide
- [x] Reflection questions answered
- [x] Best practices documented
- [x] Common errors and solutions
- [x] Video demo script

---

## 📚 Resources Used

- [Firestore Query Documentation](https://firebase.google.com/docs/firestore/query-data/queries)
- [FlutterFire Firestore Usage](https://firebase.flutter.dev/docs/firestore/usage)
- [Indexing in Firestore](https://firebase.google.com/docs/firestore/query-data/indexing)
- [Query Limitations](https://firebase.google.com/docs/firestore/query-data/queries#query_limitations)

---

## 🎯 Learning Outcomes

After completing this implementation, you will understand:

✅ How to build efficient Firestore queries  
✅ When to use WHERE, ORDER BY, and LIMIT  
✅ How to create and manage indexes  
✅ StreamBuilder for real-time query results  
✅ Best practices for mobile query optimization  
✅ Common query pitfalls and solutions  
✅ How queries improve UX and reduce costs  
✅ Dynamic query construction

---

**Team Nova** | Sprint 2 | Firestore Queries & Filtering  
**Date:** February 2026
