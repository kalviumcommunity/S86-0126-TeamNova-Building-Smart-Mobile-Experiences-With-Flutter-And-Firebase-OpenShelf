# State Management with Provider: 10-Minute Quick Start

Get a working state management setup in 10 minutes.

---

## Step 1: Add Dependency (1 minute)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

Run: `flutter pub get`

---

## Step 2: Create State Class (2 minutes)

Create `lib/providers/app_state.dart`:

```dart
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int _count = 0;
  List<String> _items = [];

  int get count => _count;
  List<String> get items => List.unmodifiable(_items);

  void increment() {
    _count++;
    notifyListeners();
  }

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();
  }
}
```

---

## Step 3: Register at App Root (2 minutes)

Update `lib/main.dart`:

```dart
import 'package:provider/provider.dart';
import 'providers/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
```

---

## Step 4: Use State in UI (3 minutes)

Create `lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Watch state - rebuilds when state changes
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Count: ${state.count}'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Count section
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Current Count:'),
                Text(
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Items list
          Expanded(
            child: state.items.isEmpty
                ? const Center(child: Text('No items yet'))
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<AppState>().removeItem(item);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Item name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<AppState>().addItem(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

---

## Step 5: Test (2 minutes)

Run your app:
```bash
flutter run
```

✅ Counter increments with FloatingActionButton
✅ Items appear in list
✅ Delete removes items
✅ Count shows in AppBar
✅ All changes sync automatically

---

## Key Concepts

### watch() vs read()

```dart
// watch() - REACTIVE (rebuilds when state changes)
final state = context.watch<AppState>();

// read() - ONE-TIME (no rebuild)
context.read<AppState>().increment();
```

### notifyListeners()

Always call after state changes:
```dart
void increment() {
  _count++;
  notifyListeners(); // ← Triggers UI rebuild
}
```

---

## Common Tasks

**Access state**: `context.watch<AppState>()`
**Update state**: `context.read<AppState>().method()`
**Add multiple providers**: Use `MultiProvider`

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| UI not updating | Check notifyListeners() is called |
| State null | Ensure ChangeNotifierProvider wraps app |
| Rebuild issues | Use watch() for reactive, read() for updates |

---

## Next Steps

- Review [Complete README](PROVIDER_RIVERPOD_README.md) for deep dives
- Check [Code Examples](PROVIDER_RIVERPOD_CODE_EXAMPLES.md) for patterns
- Use [Checklist](PROVIDER_RIVERPOD_IMPLEMENTATION_CHECKLIST.md) for verification
