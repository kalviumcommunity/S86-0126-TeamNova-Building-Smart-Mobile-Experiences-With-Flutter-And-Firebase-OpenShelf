# State Management with Provider & Riverpod: Complete Guide

## Table of Contents
1. [Why Scalable State Management Matters](#why-scalable-state-management-matters)
2. [Provider vs Riverpod: Comparison](#provider-vs-riverpod-comparison)
3. [Provider: Complete Setup](#provider-complete-setup)
4. [Riverpod: Complete Setup](#riverpod-complete-setup)
5. [Creating State Classes](#creating-state-classes)
6. [Multi-Screen Shared State](#multi-screen-shared-state)
7. [Advanced Patterns](#advanced-patterns)
8. [Combining State & CRUD](#combining-state--crud)
9. [Error Handling & Side Effects](#error-handling--side-effects)
10. [Testing State Management](#testing-state-management)
11. [Performance Optimization](#performance-optimization)
12. [Common Issues & Fixes](#common-issues--fixes)

---

## Why Scalable State Management Matters

### The Problem: State Without Management

Without proper state management, Flutter apps quickly become problematic:

```dart
// ❌ BAD: Prop drilling - passing data through constructors
Widget build(BuildContext context) {
  return HomeScreen(
    user: user,
    favorites: favorites,
    settings: settings,
    cart: cart,
    notifications: notifications,
  );
}
```

**Issues**:
- **Prop drilling**: Data passed through multiple levels
- **Tight coupling**: Screens depend on parent constructors
- **setState limitations**: Only works in single widgets
- **Manual syncing**: Changes don't propagate automatically
- **Hard to test**: Many dependencies to mock

### The Solution: Centralized State Management

```dart
// ✅ GOOD: Provider handles state globally
final userProvider = ChangeNotifierProvider((ref) => UserState());

// Access from anywhere in app
final user = context.watch<UserState>();
```

**Benefits**:
- ✅ Global access without prop drilling
- ✅ Automatic UI updates (reactive)
- ✅ Loose coupling between screens
- ✅ Easy to test with dependency injection
- ✅ Single source of truth

### Real-World Scenarios

**E-Commerce App**:
- User authentication state (login screen → home → product screens → checkout)
- Shopping cart (add item in product screen → see count in app bar → view in cart screen)
- Favorites (heart icon in product → favorites list → persist across app)
- User preferences (settings screen → applied everywhere)

**Social Media App**:
- Current user profile (sidebar → profile screen → comment author names)
- Feed posts (main feed → post detail → comments)
- Notification count (app bar → notification screen)
- Dark mode preference (entire app theme)

**Finance Dashboard**:
- User account balance (header → transaction list → portfolio)
- Exchange rates (real-time updates across charts)
- Portfolio holdings (watchlist → detailed view → alerts)

---

## Provider vs Riverpod: Comparison

### Provider (ChangeNotifier Approach)

**Best For**: Small to medium apps, teams comfortable with OOP

| Aspect | Rating | Details |
|--------|--------|---------|
| **Ease of Learning** | ⭐⭐⭐⭐⭐ | Very simple, familiar OOP patterns |
| **Code Simplicity** | ⭐⭐⭐⭐ | Straightforward, less boilerplate |
| **Type Safety** | ⭐⭐⭐ | Relies on type inference |
| **Scalability** | ⭐⭐⭐ | Good for medium apps |
| **Performance** | ⭐⭐⭐ | Efficient but full rebuilds possible |
| **Testing** | ⭐⭐⭐⭐ | Easy to test with mocking |
| **Documentation** | ⭐⭐⭐⭐⭐ | Extensive, many examples |

**Pros**:
- ✅ Simple to understand and use
- ✅ Less boilerplate than Riverpod
- ✅ Great for beginners
- ✅ Good for teams transitioning from setState
- ✅ Excellent community and examples

**Cons**:
- ❌ Less type-safe than Riverpod
- ❌ Requires careful listener management
- ❌ Can cause unnecessary rebuilds
- ❌ Multiple instances possible if not careful

### Riverpod (Functional Approach)

**Best For**: Large apps, teams wanting functional programming, strict type safety

| Aspect | Rating | Details |
|--------|--------|---------|
| **Ease of Learning** | ⭐⭐⭐ | Requires functional thinking |
| **Code Simplicity** | ⭐⭐ | More boilerplate but cleaner |
| **Type Safety** | ⭐⭐⭐⭐⭐ | Fully type-safe |
| **Scalability** | ⭐⭐⭐⭐⭐ | Excellent for large apps |
| **Performance** | ⭐⭐⭐⭐⭐ | Fine-grained reactivity |
| **Testing** | ⭐⭐⭐⭐⭐ | Built-in testing utilities |
| **Documentation** | ⭐⭐⭐⭐ | Good, improving |

**Pros**:
- ✅ Type-safe by design
- ✅ Fine-grained reactivity (minimal rebuilds)
- ✅ Better for large, complex apps
- ✅ Excellent testing support
- ✅ Immutability enforced
- ✅ Works with Hooks

**Cons**:
- ❌ Steeper learning curve
- ❌ More boilerplate code
- ❌ Smaller community (growing)
- ❌ Overkill for small apps

### Decision Matrix

Choose **Provider** if:
- ✅ You're learning state management
- ✅ Building small to medium app
- ✅ Team prefers OOP
- ✅ Need quick setup
- ✅ Want maximum community resources

Choose **Riverpod** if:
- ✅ Building large, complex app
- ✅ Type safety critical
- ✅ Need fine-grained control
- ✅ Want immutable patterns
- ✅ Team comfortable with functional programming

---

## Provider: Complete Setup

### Step 1: Add Dependency

```yaml
dependencies:
  provider: ^6.0.0
  flutter:
    sdk: flutter
```

### Step 2: Define State Classes

```dart
// lib/providers/counter_state.dart
import 'package:flutter/foundation.dart';

class CounterState extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
```

### Step 3: Register at App Root

```dart
// lib/main.dart
import 'package:provider/provider.dart';
import 'providers/counter_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounterState(),
        ),
        // Add more providers here
      ],
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

### Step 4: Read State in UI

**Using `watch()` - Reactive (rebuilds when state changes)**:
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Watch triggers rebuild when count changes
    final counter = context.watch<CounterState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Count:'),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Access state without rebuild
          context.read<CounterState>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Using `read()` - One-time access (no rebuild)**:
```dart
// Read state once, execute logic
context.read<CounterState>().increment();
Text('Count: ${context.read<CounterState>().count}');
```

### Step 5: Multi-Screen Access

```dart
// Screen A: Add to favorites
class ProductScreen extends StatelessWidget {
  final String productId;

  const ProductScreen({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<FavoritesState>().addItem(productId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to favorites')),
          );
        },
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}

// Screen B: View favorites
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.items.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.items.length,
              itemBuilder: (context, index) {
                final item = favorites.items[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      favorites.removeItem(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
```

---

## Riverpod: Complete Setup

### Step 1: Add Dependency

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.2.0
  flutter:
    sdk: flutter

dev_dependencies:
  build_runner: ^latest
  riverpod_generator: ^2.2.0
```

### Step 2: Create Providers

```dart
// lib/providers/counter_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple State Provider
final counterProvider = StateProvider<int>((ref) => 0);

// More complex: StateNotifier approach
class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final complexCounterProvider = StateNotifierProvider<Counter, int>(
  (ref) => Counter(),
);
```

### Step 3: Wrap App with ProviderScope

```dart
// lib/main.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod State',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
```

### Step 4: Read State in Widgets

```dart
// Using ConsumerWidget for reactive access
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider - rebuilds when state changes
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Count:'),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update state
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Alternative: ConsumerStatefulWidget
class MyStatefulScreen extends ConsumerStatefulWidget {
  const MyStatefulScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyStatefulScreen> createState() => _MyStatefulScreenState();
}

class _MyStatefulScreenState extends ConsumerState<MyStatefulScreen> {
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Text('Count: $count'),
    );
  }
}
```

---

## Creating State Classes

### Provider: ChangeNotifier Pattern

```dart
// ✅ GOOD: Clean, descriptive state class
class UserState extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await AuthService().login(email, password);
      _user = user;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;
}
```

### Riverpod: Functional Pattern

```dart
// ✅ Immutable, functional approach
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  UserNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService().login(email, password));
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}
```

---

## Multi-Screen Shared State

### Architecture: Shared Favorites Across Screens

```dart
// Provider: Shared Favorites State
class FavoritesState extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);
  int get count => _items.length;

  void addItem(String id) {
    if (!_items.contains(id)) {
      _items.add(id);
      notifyListeners();
      _persistToStorage();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
    _persistToStorage();
  }

  bool isFavorited(String id) => _items.contains(id);

  void toggleFavorite(String id) {
    if (isFavorited(id)) {
      removeItem(id);
    } else {
      addItem(id);
    }
  }

  Future<void> _persistToStorage() async {
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _items);
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];
    _items.addAll(saved);
    notifyListeners();
  }
}

// main.dart - Register
ChangeNotifierProvider(
  create: (_) => FavoritesState(),
),
```

### Usage: Product Screen

```dart
class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;

  const ProductCard({
    required this.productId,
    required this.productName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(productName),
          Consumer<FavoritesState>(
            builder: (context, favorites, child) {
              final isFavorited = favorites.isFavorited(productId);
              return IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  favorites.toggleFavorite(productId);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Usage: Favorites Screen

```dart
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FavoritesState>(
          builder: (context, favorites, child) {
            return Text('Favorites (${favorites.count})');
          },
        ),
      ),
      body: Consumer<FavoritesState>(
        builder: (context, favorites, child) {
          if (favorites.items.isEmpty) {
            return const Center(child: Text('No favorites'));
          }

          return ListView.builder(
            itemCount: favorites.items.length,
            itemBuilder: (context, index) {
              final itemId = favorites.items[index];
              return ListTile(
                title: Text(itemId),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    favorites.removeItem(itemId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Advanced Patterns

### Provider: Computed/Derived State

```dart
// Expose computed values without separate storage
class ShoppingCartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  
  // Computed: total price
  double get total => _items.fold<double>(
    0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  // Computed: item count
  int get itemCount => _items.fold<int>(
    0,
    (sum, item) => sum + item.quantity,
  );

  // Computed: has items
  bool get hasItems => _items.isNotEmpty;

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }
}
```

### Provider: Scoped Providers

```dart
// Provide different instances for different routes
class RoutedShoppingCart extends ChangeNotifier {
  // Unique to each route
  final String routeId;
  final List<CartItem> items = [];

  RoutedShoppingCart(this.routeId);
}

// Use with ProxyProvider
MultiProvider(
  providers: [
    ProxyProvider<RouteState, RoutedShoppingCart>(
      update: (_, routeState, __) {
        return RoutedShoppingCart(routeState.currentRoute);
      },
    ),
  ],
)
```

### Riverpod: FutureProvider for Async Data

```dart
// Auto-handles loading/error/data states
final userProvider = FutureProvider<User>((ref) async {
  return await ApiService().fetchUser();
});

// Usage
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => Text('Hi, ${user.name}'),
    );
  }
}
```

### Riverpod: Family Modifier for Parameters

```dart
// Providers that depend on parameters
final itemProvider = FutureProvider.family<Item, String>((ref, itemId) async {
  return await ApiService().fetchItem(itemId);
});

// Usage
final item = ref.watch(itemProvider('123'));
```

---

## Combining State & CRUD

### Provider + CRUD Service

```dart
class UserState extends ChangeNotifier {
  final CrudService _crudService = CrudService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Create - persist to Firestore
  Future<void> createUser(String name, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await _crudService.createItem(
        title: name,
        description: email,
      );
      _user = User(id: userId, name: name, email: email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Read - load from Firestore
  Future<void> loadUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final item = await _crudService.getItemById(userId);
      if (item != null) {
        _user = User(
          id: item.id,
          name: item.title,
          email: item.description,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update - sync to Firestore
  Future<void> updateUser(String name, String email) async {
    if (_user == null) return;

    try {
      await _crudService.updateItemField(_user!.id, 'title', name);
      await _crudService.updateItemField(_user!.id, 'description', email);
      _user = _user!.copyWith(name: name, email: email);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Delete - remove from Firestore
  Future<void> deleteUser() async {
    if (_user == null) return;

    try {
      await _crudService.deleteItem(_user!.id);
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## Error Handling & Side Effects

### Provider: Error States

```dart
class SecureUserState extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> authenticateUser(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _validateAndLogin(email, password);
      _user = user;
    } on AuthException catch (e) {
      _error = e.userMessage; // User-friendly
    } on NetworkException catch (e) {
      _error = 'Network error: ${e.message}';
    } catch (e) {
      _error = 'Unexpected error';
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
```

### Riverpod: Side Effects with .family

```dart
// Trigger side effects when provider changes
final authTokenProvider = FutureProvider<String?>(
  (ref) async {
    final user = ref.watch(userProvider);
    return user.maybeWhen(
      data: (user) => user.token,
      orElse: () => null,
    );
  },
);

// Listen for changes
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String?>>(
      authTokenProvider,
      (previous, next) {
        // Triggered when token changes
        next.whenData((token) {
          if (token != null) {
            _setupApiHeaders(token);
          }
        });
      },
    );

    return const SizedBox();
  }
}
```

---

## Testing State Management

### Provider: Unit Testing

```dart
test('Counter increments correctly', () {
  final counter = CounterState();
  
  expect(counter.count, 0);
  
  counter.increment();
  expect(counter.count, 1);
  
  counter.increment();
  expect(counter.count, 2);
});

test('Counter notifies listeners', () {
  final counter = CounterState();
  bool notified = false;
  
  counter.addListener(() => notified = true);
  counter.increment();
  
  expect(notified, true);
});
```

### Riverpod: Testing with Containers

```dart
test('Counter provider increments', () {
  final container = ProviderContainer();
  
  expect(container.read(counterProvider), 0);
  
  container.read(counterProvider.notifier).state++;
  expect(container.read(counterProvider), 1);
});

test('Async provider loading state', () async {
  final container = ProviderContainer();
  
  final async = container.read(userProvider);
  expect(async, isA<AsyncLoading>());
  
  await container.pump();
  final data = container.read(userProvider);
  expect(data.value, isA<User>());
});
```

---

## Performance Optimization

### Provider: Consumer Selector

```dart
// ❌ BAD: Rebuilds entire widget on any counter change
Consumer<CounterState>(
  builder: (context, counter, child) {
    return MyComplexWidget(count: counter.count);
  },
);

// ✅ GOOD: Only rebuilds if count actually changed
Selector<CounterState, int>(
  selector: (_, counter) => counter.count,
  builder: (context, count, child) {
    return MyComplexWidget(count: count);
  },
);
```

### Riverpod: watch vs select

```dart
// ❌ BAD: Rebuilds on entire user object change
final user = ref.watch(userProvider);

// ✅ GOOD: Only rebuilds if name changes
final userName = ref.watch(
  userProvider.select((user) => user.name),
);
```

### Memoization: Avoid Recreating Instances

```dart
// ❌ BAD: Creates new list every build
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterState>();
    return ListView(children: counter.items.map(Text.new).toList());
  }
}

// ✅ GOOD: Memoize with provider
final itemsProvider = Provider<List<String>>((ref) {
  final counter = ref.watch(counterProvider);
  return counter.items.map((i) => '$i').toList();
});
```

---

## Common Issues & Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| **UI not updating** | Forgot `notifyListeners()` or didn't use `watch()` | Always call notifyListeners() after state change; use `context.watch()` not `context.read()` |
| **Multiple instances** | Provider declared in wrong scope | Move to `main()` with MultiProvider or app root |
| **Riverpod read/update errors** | Wrong syntax for accessing notifier | Use `ref.read(provider.notifier).state` to update |
| **Performance issues** | Every state change rebuilds entire widget | Use Selector (Provider) or select (Riverpod) |
| **Memory leaks** | Listeners not removed | Remove listeners on widget dispose |
| **Circular dependencies** | Providers depend on each other | Use ref.watch carefully, restructure provider hierarchy |
| **Hard to debug** | State changes not tracked | Use DevTools, add logging, use immutable patterns |
| **Testing fails** | Providers not properly isolated | Create new instances in tests, use ProviderContainer |

---

## Best Practices Summary

### Do ✅
- ✅ Keep state classes small and focused
- ✅ Use immutable patterns (copyWith, final fields)
- ✅ Break complex state into multiple providers
- ✅ Test providers in isolation
- ✅ Use `watch()` for reactive updates
- ✅ Use `read()` for one-time access
- ✅ Document provider purposes
- ✅ Use Selector/select for optimization

### Don't ❌
- ❌ Store contexts in providers
- ❌ Store heavy objects (controllers, streams)
- ❌ Create providers inside widgets
- ❌ Forget `notifyListeners()` calls
- ❌ Use watch() to trigger side effects
- ❌ Mix Provider and Riverpod in same app
- ❌ Over-abstract (simple state doesn't need Provider)
- ❌ Ignore performance warnings

---

## Migration Guide: setState → Provider

### Before: Using setState

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Count: $_count'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
      ),
    );
  }
}
```

### After: Using Provider

```dart
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterState>();

    return Scaffold(
      body: Text('Count: ${counter.count}'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterState>().increment(),
      ),
    );
  }
}
```

**Benefits**:
- ✅ No StatefulWidget boilerplate
- ✅ State shared globally
- ✅ Testable without building widgets
- ✅ Scales to multiple screens

---

## Summary

- ✅ **Provider**: Simple, beginner-friendly, great for small/medium apps
- ✅ **Riverpod**: Powerful, type-safe, ideal for large apps
- ✅ **Shared State**: Eliminates prop drilling, enables real-time sync
- ✅ **Testing**: Both support unit testing providers
- ✅ **Performance**: Use Selector/select to minimize rebuilds
- ✅ **CRUD Integration**: Providers wrap service layer perfectly

Choose the tool that fits your app's complexity. Start simple, scale up as needed!

---

**Next Steps**:
1. Follow the [Quick Start](#quick-start) for hands-on setup
2. Review [Code Examples](#code-examples) for patterns
3. Use the [Checklist](#implementation-checklist) for verification
4. Integrate with your CRUD flows
