# 🚀 Firestore Queries & Filtering - Quick Start Guide

## ⚡ TL;DR

This feature lets you efficiently query Firestore data using:

- **WHERE** filters (equality, comparison, arrays)
- **ORDER BY** sorting (ascending/descending)
- **LIMIT** pagination
- **Real-time updates** with StreamBuilder

---

## 🎯 Quick Demo (5 Minutes)

### 1. Run the App

```bash
flutter pub get
flutter run
```

### 2. Navigate to Demo

Home → Demo Hub → "🔍 Firestore Queries & Filtering"

### 3. Add Sample Data

Click "Add Sample Book" button 10-15 times

### 4. Try Different Queries

- **In Stock:** Shows only available books
- **High Rated:** Books with rating ≥ 4.0
- **By Genre:** Filter by Science, Fiction, etc.
- **Price Range:** Adjust sliders to filter by price
- **Sort Options:** Newest, Title A-Z, Rating, Price

### 5. See Real-Time Updates

- Open Firestore console
- Change a book's rating or availability
- Watch the app update instantly!

---

## 💻 Essential Code Patterns

### Basic Filter

```dart
books.where('available', isEqualTo: true).snapshots()
```

### Comparison Filter

```dart
books.where('price', isGreaterThan: 10).snapshots()
```

### Sort

```dart
books.orderBy('averageRating', descending: true).snapshots()
```

### Limit

```dart
books.limit(20).snapshots()
```

### Combined

```dart
books
  .where('available', isEqualTo: true)
  .orderBy('averageRating', descending: true)
  .limit(10)
  .snapshots()
```

### Display with StreamBuilder

```dart
StreamBuilder<QuerySnapshot>(
  stream: yourQueryStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();

    final items = snapshot.data!.docs;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final data = items[index].data() as Map<String, dynamic>;
        return ListTile(title: Text(data['title']));
      },
    );
  },
)
```

---

## 🔥 Common Queries You'll Use

### Get All Items (Sorted)

```dart
Stream<QuerySnapshot> getAllBooks() {
  return books.orderBy('createdAt', descending: true).snapshots();
}
```

### Get Available Items

```dart
Stream<QuerySnapshot> getAvailableBooks() {
  return books.where('available', isEqualTo: true).snapshots();
}
```

### Get Top Rated (with Limit)

```dart
Stream<QuerySnapshot> getTopRated(int limit) {
  return books
    .orderBy('rating', descending: true)
    .limit(limit)
    .snapshots();
}
```

### Price Range

```dart
Stream<QuerySnapshot> getByPriceRange(double min, double max) {
  return books
    .where('price', isGreaterThanOrEqualTo: min)
    .where('price', isLessThanOrEqualTo: max)
    .orderBy('price')
    .snapshots();
}
```

### By Category (Array)

```dart
Stream<QuerySnapshot> getByCategory(String category) {
  return books.where('categories', arrayContains: category).snapshots();
}
```

---

## ⚠️ Common Mistakes to Avoid

### ❌ DON'T: Fetch everything and filter in code

```dart
// BAD - Downloads 500 items
final all = await books.get();
final filtered = all.docs.where((doc) => doc['available'] == true);
```

### ✅ DO: Filter at Firestore level

```dart
// GOOD - Downloads only 50 matching items
final filtered = await books.where('available', isEqualTo: true).get();
```

---

### ❌ DON'T: Use ORDER BY on different field than WHERE inequality

```dart
// ERROR - Needs composite index
books
  .where('price', isGreaterThan: 10)
  .orderBy('rating') // Different field!
```

### ✅ DO: Order by the same field

```dart
// CORRECT
books
  .where('price', isGreaterThan: 10)
  .orderBy('price')
```

---

### ❌ DON'T: Use multiple inequality filters

```dart
// ERROR - Only one inequality allowed
books
  .where('price', isGreaterThan: 10)
  .where('rating', isGreaterThan: 4) // Can't do this!
```

### ✅ DO: Use one inequality, equality for others

```dart
// CORRECT
books
  .where('available', isEqualTo: true) // Equality OK
  .where('price', isGreaterThan: 10)   // One inequality
```

---

## 📊 When to Use Each Query Type

| Query Type      | Use When               | Example                           |
| --------------- | ---------------------- | --------------------------------- |
| `isEqualTo`     | Exact match needed     | Available: true, Status: "active" |
| `isGreaterThan` | Minimum threshold      | Price > $10, Age > 18             |
| `isLessThan`    | Maximum threshold      | Price < $100, Rating < 3          |
| `arrayContains` | Check array membership | Tags include "featured"           |
| `orderBy`       | Sort results           | Newest first, A-Z, High to low    |
| `limit`         | Pagination/performance | First 20 items, Top 10            |

---

## 🎯 Quick Index Guide

### When Firebase asks for an index:

1. **See this error:**

   ```
   The query requires an index. You can create it here:
   https://console.firebase.google.com/...
   ```

2. **Click the link** - Opens Firebase console

3. **Click "Create Index"**

4. **Wait 2-3 minutes** - Index builds automatically

5. **Run query again** - Works perfectly!

### Common Indexes Needed:

- `available (ASC) + rating (DESC)` - For filtered + sorted queries
- `category (ASC) + createdAt (DESC)` - For category filtering with dates
- `price (ASC)` - For price range queries

---

## 🎬 Video Checklist

Your video should show:

- [ ] App displaying filtered results
- [ ] Changing filters (show at least 2 types)
- [ ] Sorting options
- [ ] Result count updating
- [ ] Firestore console with your data
- [ ] Real-time update (change in Firestore → instant UI update)
- [ ] Quick explanation of query used

**Length:** 1-2 minutes  
**Upload:** Google Drive / Loom / YouTube (unlisted)  
**Permissions:** "Anyone with link can view"

---

## 📸 Screenshot Checklist

Must include:

- [ ] Firestore console showing books collection
- [ ] App with "All Books" query
- [ ] App with filter applied (In Stock / Genre / etc.)
- [ ] App with sorting applied (Rating / Price / etc.)
- [ ] Query description panel showing active query
- [ ] Before/After of real-time update
- [ ] Firebase indexes tab

---

## ✅ Submission Checklist

### Code

- [ ] FirestoreService has query methods
- [ ] Demo screen shows different query types
- [ ] StreamBuilder displays results
- [ ] Loading/error/empty states handled
- [ ] App compiles without errors

### Documentation

- [ ] README with code snippets
- [ ] Reflection questions answered
- [ ] Common errors documented
- [ ] Best practices listed

### Media

- [ ] 7+ screenshots
- [ ] 1-2 minute video
- [ ] Video shows real-time updates
- [ ] Screenshots show Firestore console

### PR

- [ ] Branch: `Sprint-2_Firestore_Queries`
- [ ] Title: `[Sprint-2] Firestore Queries & Filtering – TeamName`
- [ ] Description includes code snippets
- [ ] Description includes feature explanation
- [ ] Committed with: `feat: implemented Firestore queries and filtering`

---

## 🚀 Performance Tips

### Use LIMIT

```dart
// Good for mobile
.limit(20)

// Bad - could fetch 10,000 items
.snapshots() // No limit
```

### Use Indexes

- Create indexes for all WHERE + ORDER BY combinations
- Firebase prompts you automatically
- Indexes make queries **100x faster**

### Use StreamBuilder Wisely

```dart
// Real-time (chat, notifications)
StreamBuilder<QuerySnapshot>(...)

// One-time (search results)
FutureBuilder<QuerySnapshot>(...)
```

---

## 📚 Learn More

- Full README: `README_FIRESTORE_QUERIES.md`
- PR Description: `FIRESTORE_QUERIES_PR_DESCRIPTION.md`
- Firebase Docs: https://firebase.google.com/docs/firestore/query-data/queries
- FlutterFire Docs: https://firebase.flutter.dev/docs/firestore/usage

---

**Team Nova | Sprint 2 | February 2026**

Happy Querying! 🔍🔥
