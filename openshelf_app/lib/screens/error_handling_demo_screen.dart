import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../services/error_handler_service.dart';

/// Comprehensive demo screen showing error handling, loaders, and empty states
class ErrorHandlingDemoScreen extends StatefulWidget {
  const ErrorHandlingDemoScreen({super.key});

  @override
  State<ErrorHandlingDemoScreen> createState() =>
      _ErrorHandlingDemoScreenState();
}

class _ErrorHandlingDemoScreenState extends State<ErrorHandlingDemoScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Handling & States')),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: const [
                _LoadingStatesTab(),
                _ErrorStatesTab(),
                _EmptyStatesTab(),
                _FutureBuilderTab(),
                _StreamBuilderTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('Loading', 0),
            _buildTab('Errors', 1),
            _buildTab('Empty', 2),
            _buildTab('Future', 3),
            _buildTab('Stream', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ========================================
// Loading States Tab
// ========================================
class _LoadingStatesTab extends StatelessWidget {
  const _LoadingStatesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Basic Loading Indicator',
          const LoadingWidget(),
        ),
        _buildSection(
          context,
          'Loading with Message',
          const LoadingWidget(message: 'Loading your data...'),
        ),
        _buildSection(
          context,
          'Custom Size & Color',
          LoadingWidget(message: 'Please wait', size: 60, color: Colors.green),
        ),
        _buildSection(
          context,
          'Inline Loading',
          const Center(child: InlineLoadingWidget(message: 'Processing...')),
        ),
        _buildSection(
          context,
          'Skeleton Loader',
          const SizedBox(height: 300, child: SkeletonLoader(itemCount: 3)),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ========================================
// Error States Tab
// ========================================
class _ErrorStatesTab extends StatelessWidget {
  const _ErrorStatesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Generic Error',
          AppErrorWidget(
            onRetry: () => _showSnackbar(context, 'Retry clicked'),
          ),
        ),
        _buildSection(
          context,
          'Network Error',
          NetworkErrorWidget(
            onRetry: () => _showSnackbar(context, 'Retrying connection...'),
          ),
        ),
        _buildSection(
          context,
          'Permission Error',
          PermissionErrorWidget(
            permissionType: 'camera',
            onRequestPermission: () =>
                _showSnackbar(context, 'Requesting permission...'),
          ),
        ),
        _buildSection(
          context,
          'Custom Error with Details',
          AppErrorWidget(
            icon: Icons.cloud_off,
            message: 'Sync Failed',
            details: 'Unable to sync your data with the cloud',
            onRetry: () => _showSnackbar(context, 'Retrying sync...'),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Inline Errors',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        InlineErrorWidget(
          message: 'Invalid email format',
          onDismiss: () => _showSnackbar(context, 'Dismissed'),
        ),
        const SizedBox(height: 12),
        const InlineErrorWidget(
          message: 'Password must be at least 8 characters',
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

// ========================================
// Empty States Tab
// ========================================
class _EmptyStatesTab extends StatelessWidget {
  const _EmptyStatesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Basic Empty State',
          const EmptyStateWidget(
            title: 'No items found',
            message: 'Start by adding your first item',
          ),
        ),
        _buildSection(
          context,
          'Empty List',
          EmptyListWidget(
            itemName: 'book',
            onAdd: () => _showSnackbar(context, 'Add book clicked'),
          ),
        ),
        _buildSection(
          context,
          'Empty Search Results',
          EmptySearchWidget(
            searchTerm: 'flutter tutorial',
            onClearSearch: () => _showSnackbar(context, 'Search cleared'),
          ),
        ),
        _buildSection(
          context,
          'Empty Favorites',
          EmptyFavoritesWidget(
            onBrowse: () => _showSnackbar(context, 'Browse clicked'),
          ),
        ),
        _buildSection(
          context,
          'No Connection',
          NoConnectionWidget(
            onRetry: () => _showSnackbar(context, 'Retrying...'),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

// ========================================
// FutureBuilder Examples Tab
// ========================================
class _FutureBuilderTab extends StatefulWidget {
  const _FutureBuilderTab();

  @override
  State<_FutureBuilderTab> createState() => _FutureBuilderTabState();
}

class _FutureBuilderTabState extends State<_FutureBuilderTab> {
  String _scenario = 'success';
  int _retryCount = 0;

  Future<List<String>> _simulateFetch() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_scenario == 'error') {
      throw Exception('Network error occurred');
    } else if (_scenario == 'empty') {
      return [];
    }

    return ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Simulate Scenario:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildChip('Success', 'success'),
                  _buildChip('Error', 'error'),
                  _buildChip('Empty', 'empty'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<String>>(
            key: ValueKey(_retryCount), // Force rebuild on retry
            future: _simulateFetch(),
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: 'Fetching data...');
              }

              // Error State
              if (snapshot.hasError) {
                return AppErrorWidget(
                  message: ErrorHandlerService.getUserFriendlyMessage(
                    snapshot.error,
                  ),
                  details: 'Please check your connection and try again',
                  onRetry: () => setState(() => _retryCount++),
                );
              }

              final items = snapshot.data ?? [];

              // Empty State
              if (items.isEmpty) {
                return EmptyListWidget(
                  itemName: 'item',
                  onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add item clicked')),
                  ),
                );
              }

              // Success State
              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(items[index]),
                      subtitle: const Text('Successfully loaded'),
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

  Widget _buildChip(String label, String value) {
    final isSelected = _scenario == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _scenario = value;
          _retryCount++;
        });
      },
    );
  }
}

// ========================================
// StreamBuilder Examples Tab
// ========================================
class _StreamBuilderTab extends StatefulWidget {
  const _StreamBuilderTab();

  @override
  State<_StreamBuilderTab> createState() => _StreamBuilderTabState();
}

class _StreamBuilderTabState extends State<_StreamBuilderTab> {
  late StreamController<List<String>> _controller;
  String _scenario = 'success';

  @override
  void initState() {
    super.initState();
    _controller = StreamController<List<String>>();
    _emitData();
  }

  void _emitData() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_scenario == 'error') {
      _controller.addError('Stream error occurred');
    } else if (_scenario == 'empty') {
      _controller.add([]);
    } else {
      _controller.add(['Stream Item 1', 'Stream Item 2', 'Stream Item 3']);
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stream Scenario:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildChip('Success', 'success'),
                  _buildChip('Error', 'error'),
                  _buildChip('Empty', 'empty'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<String>>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: 'Listening to stream...');
              }

              // Error State
              if (snapshot.hasError) {
                return AppErrorWidget(
                  message: 'Stream Error Occurred',
                  details: snapshot.error.toString(),
                  onRetry: () {
                    _controller = StreamController<List<String>>();
                    _emitData();
                    setState(() {});
                  },
                );
              }

              // No Data Yet
              if (!snapshot.hasData) {
                return const LoadingWidget(message: 'Waiting for data...');
              }

              final items = snapshot.data!;

              // Empty State
              if (items.isEmpty) {
                return const EmptyStateWidget(
                  title: 'No stream data',
                  message: 'Waiting for items to be emitted',
                  icon: Icons.stream,
                );
              }

              // Success State
              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.stream),
                      title: Text(items[index]),
                      subtitle: const Text('Real-time data'),
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

  Widget _buildChip(String label, String value) {
    final isSelected = _scenario == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _scenario = value;
          _controller = StreamController<List<String>>();
          _emitData();
        });
      },
    );
  }
}
