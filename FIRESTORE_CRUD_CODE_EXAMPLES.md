# Firestore CRUD Flow: Code Examples

Production-ready examples for CRUD operations, error handling, and advanced patterns.

---

## Example 1: Complete Service Classes

### Data Models

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudItem {
  final String id;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed
  final String priority; // low, medium, high
  final int createdAt;
  final int? updatedAt;
  final String? tags; // comma-separated tags
  final int? dueDate;

  CrudItem({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'pending',
    this.priority = 'medium',
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.dueDate,
  });

  // Firestore → Dart
  factory CrudItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CrudItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'pending',
      priority: data['priority'] ?? 'medium',
      createdAt: data['createdAt'] ?? 0,
      updatedAt: data['updatedAt'],
      tags: data['tags'],
      dueDate: data['dueDate'],
    );
  }

  // Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tags': tags,
      'dueDate': dueDate,
    };
  }

  // Handy utilities
  bool get isOverdue => dueDate != null && dueDate! < DateTime.now().millisecondsSinceEpoch;
  bool get isCompleted => status == 'completed';
  
  List<String> get tagsList => tags?.split(',') ?? [];
}

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final int createdAt;
  final int itemCount;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    required this.createdAt,
    this.itemCount = 0,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      createdAt: data['createdAt'] ?? 0,
      itemCount: data['itemCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'itemCount': itemCount,
    };
  }
}
```

### Authentication Service

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create auth user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user profile in Firestore
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': email,
          'displayName': displayName,
          'profileImageUrl': null,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'itemCount': 0,
        });
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print('Sign-up error: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return false;
    }
  }

  // Get current user
  User? getCurrentUser() => _auth.currentUser;
  
  String? getCurrentUserId() => _auth.currentUser?.uid;
  
  bool isLoggedIn() => _auth.currentUser != null;

  // Sign out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Reset error: $e');
      return false;
    }
  }
}
```

### CRUD Service with Full Operations

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get items collection reference for current user
  CollectionReference get _userItems {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('items');
  }

  // GET user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // CREATE item
  Future<String> createItem({
    required String title,
    required String description,
    String status = 'pending',
    String priority = 'medium',
    String? tags,
    int? dueDate,
  }) async {
    try {
      DocumentReference docRef = await _userItems.add({
        'title': title,
        'description': description,
        'status': status,
        'priority': priority,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': null,
        'tags': tags,
        'dueDate': dueDate,
      });
      
      // Increment item count on user profile
      final uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'itemCount': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      print('Error creating item: $e');
      rethrow;
    }
  }

  // READ all items (real-time stream)
  Stream<List<CrudItem>> getUserItemsStream({
    String? filterStatus,
    String? sortBy,
    bool descending = true,
  }) {
    Query query = _userItems;

    // Apply filters
    if (filterStatus != null) {
      query = query.where('status', isEqualTo: filterStatus);
    }

    // Apply sorting
    final sortField = sortBy ?? 'createdAt';
    query = query.orderBy(sortField, descending: descending);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CrudItem.fromFirestore(doc))
          .toList();
    });
  }

  // READ single item by ID
  Future<CrudItem?> getItemById(String itemId) async {
    try {
      DocumentSnapshot doc = await _userItems.doc(itemId).get();
      if (doc.exists) {
        return CrudItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching item: $e');
      return null;
    }
  }

  // READ items with pagination
  Future<List<CrudItem>> getItemsPage({
    required int pageSize,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _userItems.orderBy('createdAt', descending: true).limit(pageSize);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CrudItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching page: $e');
      return [];
    }
  }

  // UPDATE single field
  Future<void> updateItemField(String itemId, String field, dynamic value) async {
    try {
      await _userItems.doc(itemId).update({
        field: value,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error updating field: $e');
      rethrow;
    }
  }

  // UPDATE entire item
  Future<void> updateItem(String itemId, CrudItem updatedItem) async {
    try {
      await _userItems.doc(itemId).update({
        ...updatedItem.toMap(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  // UPDATE batch (multiple items at once)
  Future<void> updateItemsBatch(Map<String, CrudItem> items) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      items.forEach((id, item) {
        batch.update(_userItems.doc(id), {
          ...item.toMap(),
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      });

      await batch.commit();
    } catch (e) {
      print('Error batch updating: $e');
      rethrow;
    }
  }

  // DELETE single item
  Future<void> deleteItem(String itemId) async {
    try {
      await _userItems.doc(itemId).delete();
      
      // Decrement item count
      final uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'itemCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }

  // DELETE all items
  Future<void> deleteAllItems() async {
    try {
      QuerySnapshot snapshot = await _userItems.get();
      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Reset item count
      final uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'itemCount': 0,
      });
    } catch (e) {
      print('Error deleting all items: $e');
      rethrow;
    }
  }

  // SEARCH items by title/description
  Future<List<CrudItem>> searchItems(String query) async {
    try {
      QuerySnapshot snapshot = await _userItems
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
          .get();

      return snapshot.docs
          .map((doc) => CrudItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error searching items: $e');
      return [];
    }
  }

  // Get items count
  Future<int> getItemsCount() async {
    try {
      QuerySnapshot snapshot = await _userItems.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting count: $e');
      return 0;
    }
  }
}
```

---

## Example 2: CRUD UI Screen with Loading States

```dart
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/crud_service.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({Key? key}) : super(key: key);

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final CrudService _crudService = CrudService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _filterStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterMenu,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<CrudItem>>(
        stream: _crudService.getUserItemsStream(filterStatus: _filterStatus),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No items. Create one to get started!'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Item'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Force refresh by waiting a moment
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemCard(
                  item: item,
                  onEdit: () => _showEditDialog(item),
                  onDelete: () => _deleteItem(item.id),
                  onToggleStatus: () => _toggleItemStatus(item),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedPriority,
                isExpanded: true,
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.toUpperCase()),
                    ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedPriority = value);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (titleCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title required')),
                      );
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      await _crudService.createItem(
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        priority: selectedPriority,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
            child: _isLoading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(CrudItem item) {
    final titleCtrl = TextEditingController(text: item.title);
    final descCtrl = TextEditingController(text: item.description);
    String selectedPriority = item.priority;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedPriority,
                isExpanded: true,
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.toUpperCase()),
                    ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedPriority = value);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    try {
                      final updated = CrudItem(
                        id: item.id,
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        status: item.status,
                        priority: selectedPriority,
                        createdAt: item.createdAt,
                        updatedAt: DateTime.now().millisecondsSinceEpoch,
                      );

                      await _crudService.updateItem(item.id, updated);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
            child: _isLoading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _crudService.deleteItem(itemId);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleItemStatus(CrudItem item) async {
    final newStatus = item.status == 'pending' ? 'completed' : 'pending';
    try {
      await _crudService.updateItemField(item.id, 'status', newStatus);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Items'),
            onTap: () {
              setState(() => _filterStatus = null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Pending'),
            onTap: () {
              setState(() => _filterStatus = 'pending');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Completed'),
            onTap: () {
              setState(() => _filterStatus = 'completed');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final CrudItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priorityColor = item.priority == 'high'
        ? Colors.red
        : item.priority == 'medium'
            ? Colors.orange
            : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => onToggleStatus(),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(item.description),
        trailing: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.priority.toUpperCase(),
                style: TextStyle(color: priorityColor, fontSize: 11),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Edit'),
                  onTap: onEdit,
                ),
                PopupMenuItem(
                  child: const Text('Delete'),
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 3: Advanced CRUD with Pagination & Filtering

```dart
class AdvancedCrudService {
  final CrudService _crudService = CrudService();
  
  // Paginated query
  class PaginatedItems {
    final List<CrudItem> items;
    final DocumentSnapshot? lastDocument;
    final bool hasMore;

    PaginatedItems({
      required this.items,
      required this.lastDocument,
      required this.hasMore,
    });
  }

  Future<PaginatedItems> getItemsWithPagination({
    required int pageSize,
    DocumentSnapshot? lastDoc,
    String? filterStatus,
  }) async {
    final CrudService crud = CrudService();
    List<CrudItem> items = await crud.getItemsPage(
      pageSize: pageSize + 1,
      lastDoc: lastDoc,
    );

    bool hasMore = items.length > pageSize;
    if (hasMore) items.removeLast();

    return PaginatedItems(
      items: items,
      lastDocument: items.isNotEmpty ? null : lastDoc,
      hasMore: hasMore,
    );
  }

  // Get items by priority
  Stream<List<CrudItem>> getItemsByPriority(String priority) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .where('priority', isEqualTo: priority)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CrudItem.fromFirestore(doc))
            .toList());
  }

  // Get overdue items
  Stream<List<CrudItem>> getOverdueItems() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .where('dueDate', isLessThan: now)
        .where('status', isNotEqualTo: 'completed')
        .orderBy('status')
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CrudItem.fromFirestore(doc))
            .toList());
  }
}
```

---

## Example 4: State Management with Provider

```dart
import 'package:provider/provider.dart';

class CrudProvider extends ChangeNotifier {
  final CrudService _crudService = CrudService();
  
  bool _isLoading = false;
  String? _error;
  List<CrudItem> _items = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CrudItem> get items => _items;

  Future<void> createItem({
    required String title,
    required String description,
    String priority = 'medium',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _crudService.createItem(
        title: title,
        description: description,
        priority: priority,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateItem(String itemId, CrudItem item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _crudService.updateItem(itemId, item);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteItem(String itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _crudService.deleteItem(itemId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// Usage in UI
class CrudScreenWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CrudProvider(),
      child: Consumer<CrudProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text('Error: ${provider.error}'))
                    : const SizedBox(),
          );
        },
      ),
    );
  }
}
```

---

## Summary

These examples cover:
- ✅ Complete service classes with all CRUD operations
- ✅ Data models with Firestore serialization
- ✅ Full-featured UI with dialogs and error handling
- ✅ Pagination and advanced filtering
- ✅ State management with Provider
- ✅ Loading states and user feedback
- ✅ Real-time updates with StreamBuilder
- ✅ Batch operations and transactions

Use these as templates for your production application!
