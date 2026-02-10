# State Management with Provider & Riverpod: Code Examples

Production-ready examples for both frameworks.

---

## Example 1: Provider - Complete Counter App

### State Class

```dart
import 'package:flutter/foundation.dart';

class CounterState extends ChangeNotifier {
  int _count = 0;
  List<int> _history = [];

  int get count => _count;
  List<int> get history => List.unmodifiable(_history);
  bool get hasHistory => _history.isNotEmpty;

  void increment() {
    _count++;
    _history.add(_count);
    notifyListeners();
  }

  void decrement() {
    _count--;
    _history.add(_count);
    notifyListeners();
  }

  void reset() {
    _count = 0;
    _history.clear();
    notifyListeners();
  }

  void undoLastChange() {
    if (_history.length > 1) {
      _history.removeLast();
      _count = _history.last;
      notifyListeners();
    }
  }

  int get maximum => _history.isEmpty ? 0 : _history.reduce((a, b) => a > b ? a : b);
  int get minimum => _history.isEmpty ? 0 : _history.reduce((a, b) => a < b ? a : b);
  double get average => _history.isEmpty ? 0 : _history.reduce((a, b) => a + b) / _history.length;
}
```

### UI Usage

```dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Consumer<CounterState>(
        builder: (context, counter, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Count: ${counter.count}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Selector<CounterState, String>(
                selector: (_, counter) => 'Max: ${counter.maximum} | Min: ${counter.minimum}',
                builder: (context, stats, _) => Text(stats),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<CounterState>().decrement(),
                    child: const Text('-'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CounterState>().reset(),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CounterState>().increment(),
                    child: const Text('+'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## Example 2: Provider - User Authentication State

```dart
class AuthState extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService().login(email, password);
      _user = User(
        id: response['id'],
        email: response['email'],
        name: response['name'],
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Unexpected error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService().register(email, password, name);
      _user = User(
        id: response['id'],
        email: email,
        name: name,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// Models
class User {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  User copyWith({String? id, String? email, String? name}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
```

### Usage in Screens

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthState>(
        builder: (context, auth, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (auth.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.red.shade100,
                    child: Text(auth.error!),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final success = await context.read<AuthState>().login(
                                emailCtrl.text,
                                passCtrl.text,
                              );
                          if (success) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthState>(
          builder: (context, auth, _) => Text('Hi, ${auth.user?.name}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthState>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## Example 3: Riverpod - Complete Counter App

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define provider
final counterProvider = StateProvider<int>((ref) => 0);

// More advanced: StateNotifier
class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final advancedCounterProvider = StateNotifierProvider<Counter, int>(
  (ref) => Counter(),
);

// Computed provider
final counterStatsProvider = Provider<String>((ref) {
  final count = ref.watch(counterProvider);
  return count.isEven ? 'Even' : 'Odd';
});
```

### UI with ConsumerWidget

```dart
class RiverpodCounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider - rebuilds when state changes
    final count = ref.watch(counterProvider);
    final stats = ref.watch(counterStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('Status: $stats'),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  child: const Text('+'),
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

## Example 4: Multi-Provider Shopping Cart

```dart
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => price * quantity;
}

class ShoppingCartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + item.total);
  bool get isEmpty => _items.isEmpty;

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

### Cart Screen

```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Consumer<ShoppingCartState>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<ShoppingCartState>().updateQuantity(
                                        item.id,
                                        item.quantity - 1,
                                      );
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<ShoppingCartState>().updateQuantity(
                                      item.id,
                                      item.quantity + 1,
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Selector<ShoppingCartState, String>(
                      selector: (_, cart) => '\$${cart.total.toStringAsFixed(2)}',
                      builder: (context, total, _) {
                        return Text('Total: $total',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ShoppingCartState>().clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed!')),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## Example 5: Provider with Theme Management

```dart
class ThemeState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    return _isDarkMode
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _savePreference();
  }

  Future<void> _savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }

  Future<void> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}

// Usage in main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeState = ThemeState();
  await themeState.loadPreference();

  runApp(
    ChangeNotifierProvider.value(
      value: themeState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'App',
          theme: theme.themeData,
          home: const HomeScreen(),
        );
      },
    );
  }
}

// Toggle theme anywhere
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeState>(
        builder: (context, theme, _) {
          return ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: theme.isDarkMode,
              onChanged: (_) => theme.toggleTheme(),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Example 6: Riverpod with FutureProvider

```dart
// Fetch user data asynchronously
final userProvider = FutureProvider<User>((ref) async {
  final userId = ref.watch(userIdProvider);
  return await ApiService().fetchUser(userId);
});

// Usage with loading/error states
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => Text('Welcome, ${user.name}'),
    );
  }
}
```

---

## Example 7: Testing Providers

```dart
// Test Provider state
test('Counter increments', () {
  final counter = CounterState();
  
  expect(counter.count, 0);
  counter.increment();
  expect(counter.count, 1);
});

// Test Riverpod provider
test('Riverpod counter', () {
  final container = ProviderContainer();
  
  expect(container.read(counterProvider), 0);
  container.read(counterProvider.notifier).state++;
  expect(container.read(counterProvider), 1);
});

// Test with mocking
test('Auth login', () async {
  final auth = AuthState();
  // Mock the service
  
  final success = await auth.login('test@example.com', 'password');
  
  expect(success, true);
  expect(auth.user, isNotNull);
});
```

---

## Summary

These examples cover:
- ✅ Simple counters with Provider
- ✅ Authentication flows
- ✅ Riverpod StateProvider
- ✅ Multi-item collections
- ✅ Theme management
- ✅ Async data loading
- ✅ Testing patterns

Use these as templates for your production applications!
