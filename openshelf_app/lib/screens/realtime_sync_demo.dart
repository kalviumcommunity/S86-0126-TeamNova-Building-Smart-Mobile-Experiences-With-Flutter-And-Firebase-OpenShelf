import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// REAL-TIME FIRESTORE SYNC DEMO
/// ============================================================================
///
/// This screen demonstrates Firestore's powerful real-time synchronization:
/// 1. Collection Snapshots - Live updates for entire collections
/// 2. Document Snapshots - Live updates for single documents
/// 3. StreamBuilder - Automatic UI rebuilding
/// 4. Change Detection - Add, Update, Delete events
/// 5. Loading & Error States - Professional UX
///
/// Features:
/// - Real-time task list (updates instantly when data changes)
/// - Live notifications feed (new items appear immediately)
/// - Live status dashboard (single document listener)
/// - Manual change listeners with custom logic
///
/// ============================================================================

class RealtimeSyncDemo extends StatefulWidget {
  const RealtimeSyncDemo({super.key});

  @override
  State<RealtimeSyncDemo> createState() => _RealtimeSyncDemoState();
}

class _RealtimeSyncDemoState extends State<RealtimeSyncDemo>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _notificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupManualListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Firestore Sync'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.task_alt), text: 'Live Tasks'),
            Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.code), text: 'Code Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveTasksTab(),
          _buildNotificationsTab(),
          _buildDashboardTab(),
          _buildCodeInfoTab(),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 1: LIVE TASKS - COLLECTION SNAPSHOT LISTENER
  // ============================================================================

  Widget _buildLiveTasksTab() {
    return Column(
      children: [
        // Header with explanation
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.teal.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📡 Real-Time Task List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Updates instantly when you add/modify tasks in Firebase Console',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),

        // Add task input
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'Enter a new task...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.task),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _addTask,
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),

        // Real-time task list using StreamBuilder
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('tasks')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 16),
                      Text(
                        'Connecting to Firestore...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Empty state
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text(
                        'No tasks yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add a task or modify in Firebase Console',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Data loaded - display tasks
              final tasks = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final data = task.data() as Map<String, dynamic>;
                  final title = data['title'] ?? 'Untitled';
                  final completed = data['completed'] ?? false;
                  final timestamp = data['createdAt'] as Timestamp?;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: completed,
                        onChanged: (value) =>
                            _toggleTaskCompletion(task.id, value ?? false),
                        activeColor: Colors.teal,
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: completed ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: timestamp != null
                          ? Text(
                              _formatTimestamp(timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTask(task.id, title),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TAB 2: NOTIFICATIONS - REAL-TIME FEED
  // ============================================================================

  Widget _buildNotificationsTab() {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.orange.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔔 Live Notification Feed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'New notifications appear instantly without refresh',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),

        // Add notification input
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notificationController,
                  decoration: InputDecoration(
                    hintText: 'Enter notification message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.notifications),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _addNotification,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),

        // Real-time notification list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .limit(50)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No notifications',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final notifications = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final data = notification.data() as Map<String, dynamic>;
                  final message = data['message'] ?? 'No message';
                  final timestamp = data['timestamp'] as Timestamp?;
                  final read = data['read'] ?? false;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: read ? Colors.white : Colors.orange.shade50,
                    elevation: read ? 1 : 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: read ? Colors.grey : Colors.orange,
                        child: Icon(
                          read
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        message,
                        style: TextStyle(
                          fontWeight: read
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: timestamp != null
                          ? Text(_formatTimestamp(timestamp))
                          : null,
                      trailing: IconButton(
                        icon: Icon(
                          read
                              ? Icons.mark_email_read
                              : Icons.mark_email_unread,
                          color: read ? Colors.grey : Colors.orange,
                        ),
                        onPressed: () =>
                            _toggleNotificationRead(notification.id, !read),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TAB 3: DASHBOARD - SINGLE DOCUMENT LISTENER
  // ============================================================================

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Live Status Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Single document listener - updates instantly',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Real-time stats using document snapshot
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('app_stats').doc('main').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Column(
                  children: [
                    const Text('No stats available. Creating default...'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeStats,
                      child: const Text('Initialize Dashboard'),
                    ),
                  ],
                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final totalUsers = data['totalUsers'] ?? 0;
              final activeSessions = data['activeSessions'] ?? 0;
              final totalTasks = data['totalTasks'] ?? 0;
              final completedTasks = data['completedTasks'] ?? 0;
              final lastUpdated = data['lastUpdated'] as Timestamp?;

              return Column(
                children: [
                  // Stat cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Users',
                          totalUsers.toString(),
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Active Sessions',
                          activeSessions.toString(),
                          Icons.online_prediction,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Tasks',
                          totalTasks.toString(),
                          Icons.task,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Completed',
                          completedTasks.toString(),
                          Icons.check_circle,
                          Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Update buttons
                  const Text(
                    'Modify these values in Firebase Console and watch them update instantly!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _incrementStat('totalUsers'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _incrementStat('activeSessions'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Session'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _incrementStat('totalTasks'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Last updated
                  if (lastUpdated != null)
                    Text(
                      'Last updated: ${_formatTimestamp(lastUpdated)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // TAB 4: CODE INFO & EXPLANATION
  // ============================================================================

  Widget _buildCodeInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCodeSection(
          '📡 Collection Snapshot Listener',
          '''
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection('tasks')
    .orderBy('createdAt', descending: true)
    .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data available');
    }
    
    final documents = snapshot.data!.docs;
    return ListView.builder(...);
  },
)
''',
          'Listens to ALL changes in a collection:\n• Document added\n• Document updated\n• Document deleted\n\nAutomatically rebuilds UI when any change occurs.',
        ),
        const SizedBox(height: 16),
        _buildCodeSection(
          '📄 Document Snapshot Listener',
          '''
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
    .collection('app_stats')
    .doc('main')
    .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return Text('Document not found');
    }
    
    final data = snapshot.data!.data() as Map<String, dynamic>;
    return Text('Value: \${data['field']}');
  },
)
''',
          'Listens to a SINGLE document:\n• Field updates\n• Nested field changes\n• Document deletion\n\nPerfect for live dashboards and user profiles.',
        ),
        const SizedBox(height: 16),
        _buildCodeSection(
          '🔍 Manual Change Detection',
          '''
FirebaseFirestore.instance
  .collection('tasks')
  .snapshots()
  .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        print('New document added!');
      }
      if (change.type == DocumentChangeType.modified) {
        print('Document updated!');
      }
      if (change.type == DocumentChangeType.removed) {
        print('Document deleted!');
      }
    }
  });
''',
          'Custom listener for:\n• Push notifications\n• Analytics tracking\n• Custom animations\n• Activity logs',
        ),
        const SizedBox(height: 16),
        _buildCodeSection(
          '✅ Best Practices',
          '',
          '1. Always handle loading states\n2. Handle empty data states\n3. Handle error states\n4. Use .orderBy() for consistent ordering\n5. Use .limit() to prevent excessive data\n6. Dispose streams when not needed\n7. Use indexes for complex queries',
        ),
      ],
    );
  }

  Widget _buildCodeSection(String title, String code, String explanation) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            if (code.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              explanation,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // FIRESTORE OPERATIONS
  // ============================================================================

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a task')));
      return;
    }

    try {
      await _firestore.collection('tasks').add({
        'title': _taskController.text.trim(),
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _taskController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Task added! Watch it appear instantly'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding task: $e')));
    }
  }

  Future<void> _toggleTaskCompletion(String taskId, bool completed) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'completed': completed,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating task: $e')));
    }
  }

  Future<void> _editTask(String taskId, String currentTitle) async {
    final controller = TextEditingController(text: currentTitle);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      try {
        await _firestore.collection('tasks').doc(taskId).update({
          'title': newTitle.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Task updated instantly!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('tasks').doc(taskId).delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Task deleted - UI updates instantly!'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _addNotification() async {
    if (_notificationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }

    try {
      await _firestore.collection('notifications').add({
        'message': _notificationController.text.trim(),
        'read': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _notificationController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔔 Notification sent - appears instantly!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleNotificationRead(String notificationId, bool read) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'read': read,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _initializeStats() async {
    try {
      await _firestore.collection('app_stats').doc('main').set({
        'totalUsers': 0,
        'activeSessions': 0,
        'totalTasks': 0,
        'completedTasks': 0,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Dashboard initialized!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _incrementStat(String field) async {
    try {
      await _firestore.collection('app_stats').doc('main').update({
        field: FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ $field incremented - watch it update!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ============================================================================
  // MANUAL LISTENER (for demonstration)
  // ============================================================================

  void _setupManualListener() {
    _firestore.collection('tasks').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        final data = change.doc.data();
        final title = data?['title'] ?? 'Unknown';

        switch (change.type) {
          case DocumentChangeType.added:
            debugPrint('🟢 NEW TASK ADDED: $title');
            break;
          case DocumentChangeType.modified:
            debugPrint('🔵 TASK UPDATED: $title');
            break;
          case DocumentChangeType.removed:
            debugPrint('🔴 TASK DELETED: $title');
            break;
        }
      }
    });
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
