# 🎯 Firestore Queries - One-Page Cheat Sheet

## 🔥 Essential Query Patterns

### 1. Equality Filter
```dart
.where('available', isEqualTo: true)
```

### 2. Comparison Filters
```dart
.where('price', isGreaterThan: 10)
.where('price', isLessThan: 100)
.where('rating', isGreaterThanOrEqualTo: 4.0)
.where('rating', isLessThanOrEqualTo: 5.0)
```

### 3. Array Contains
```dart
.where('tags', arrayContains: 'featured')
```

### 4. Sorting
```dart
.orderBy('createdAt', descending: true)  // Newest first
.orderBy('title')                        // A-Z
.orderBy('rating', descending: true)     // Highest rated
```

### 5. Limit Results
```dart
.limit(20)  // First 20 results
```

### 6. Combined Query
```dart
books
  .where('available', isEqualTo: true)
  .orderBy('rating', descending: true)
  .limit(10)
  .snapshots()
```

---

## 📱 StreamBuilder Template

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection('items')
    .where('active', isEqualTo: true)
    .orderBy('createdAt', descending: true)
    .limit(20)
    .snapshots(),
  builder: (context, snapshot) {
    // 1. Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 2. Error
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    // 3. Empty
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data');
    }
    
    // 4. Display data
    final items = snapshot.data!.docs;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final data = items[index].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['title']),
          subtitle: Text(data['description']),
        );
      },
    );
  },
)
```

---

## ⚠️ Common Mistakes

### ❌ DON'T
```dart
// Multiple inequalities
.where('price', isGreaterThan: 10)
.where('rating', isGreaterThan: 4)  // ERROR!

// ORDER BY different field than WHERE inequality
.where('price', isGreaterThan: 10)
.orderBy('createdAt')  // ERROR!
```

### ✅ DO
```dart
// One inequality only
.where('price', isGreaterThan: 10)
.where('available', isEqualTo: true)  // Equality OK

// ORDER BY same field as inequality
.where('price', isGreaterThan: 10)
.orderBy('price')  // Same field ✓
```

---

## 🎯 Query Selection Guide

| Need | Use |
|------|-----|
| Exact match | `isEqualTo` |
| Minimum value | `isGreaterThanOrEqualTo` |
| Maximum value | `isLessThanOrEqualTo` |
| Range | Two `where` on same field |
| Check array | `arrayContains` |
| Sort results | `orderBy` |
| Limit results | `limit` |
| Real-time | `.snapshots()` |
| One-time | `.get()` |

---

## 📊 Performance Rules

✅ **GOOD** - Server-side filtering
```dart
books.where('available', isEqualTo: true).get()
// Fetches: 50 documents
```

❌ **BAD** - Client-side filtering
```dart
books.get()  // Fetches: 500 documents
// Then filter in Dart code
```

**Result:** 10x slower, 10x more expensive

---

## 🔍 Index Quick Fix

**See this error?**
```
The query requires an index. You can create it here:
https://console.firebase.google.com/...
```

**Fix:**
1. Click the link
2. Click "Create Index"
3. Wait 2-3 minutes
4. Query works! ✓

---

## 🚀 Quick Start

1. Add to `firestore_service.dart`:
```dart
Stream<QuerySnapshot> getItems() {
  return FirebaseFirestore.instance
    .collection('items')
    .where('active', isEqualTo: true)
    .orderBy('createdAt', descending: true)
    .limit(20)
    .snapshots();
}
```

2. Use in UI:
```dart
StreamBuilder<QuerySnapshot>(
  stream: _service.getItems(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    return ListView.builder(...);
  },
)
```

3. Done! Real-time filtered list ✨

---

**Team Nova | Sprint 2 | 2026**
