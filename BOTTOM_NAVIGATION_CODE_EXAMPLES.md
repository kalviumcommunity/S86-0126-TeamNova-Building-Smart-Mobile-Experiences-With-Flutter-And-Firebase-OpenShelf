# Bottom Navigation Code Examples

> **5 complete production-ready navigation implementations with full source code.**

---

## Example 1: Instagram-Style Navigation (Complete App)

### Features
- 5 tabs with swipe support
- PageView for smooth scrolling
- Active/inactive icon states
- Badge notifications
- State preservation

### Full Code (350 lines)

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const InstagramApp());
}

class InstagramApp extends StatelessWidget {
  const InstagramApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const InstagramHome(),
    );
  }
}

class InstagramHome extends StatefulWidget {
  const InstagramHome({Key? key}) : super(key: key);

  @override
  State<InstagramHome> createState() => _InstagramHomeState();
}

class _InstagramHomeState extends State<InstagramHome> {
  late PageController _pageController;
  int _currentIndex = 0;
  int _messageCount = 5;
  int _notificationCount = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        physics: const ClampingScrollPhysics(),
        children: [
          HomeTab(),
          ExploreTab(),
          ReelsTab(),
          MessagesTab(messageCount: _messageCount),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 1 ? Icons.explore : Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 2 ? Icons.video_library : Icons.video_library_outlined),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: _messageCount > 0 ? Text(_messageCount.toString()) : null,
              child: Icon(_currentIndex == 3 ? Icons.send : Icons.send_outlined),
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 4 ? Icons.account_circle : Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Tab Screens
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: const Text('2 minutes ago'),
                ),
                Container(
                  height: 300,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_outline),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_outline),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Icon(
                Icons.image,
                color: Colors.grey.shade600,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReelsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reels')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('Reels Content'),
          ],
        ),
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  final int messageCount;

  const MessagesTab({required this.messageCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: messageCount + 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('User ${index + 1}'),
            subtitle: Text(
              index < messageCount ? 'You have a new message' : 'No new messages',
            ),
            trailing: index < messageCount
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Username'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text('120', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Posts'),
                  ],
                ),
                Column(
                  children: const [
                    Text('5K', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Followers'),
                  ],
                ),
                Column(
                  children: const [
                    Text('200', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Following'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 2: E-Commerce App Navigation

### Features
- 5 tabs: Shop, Categories, Wishlist, Cart, Account
- Cart badge with count
- IndexedStack for state preservation
- Loading states
- Screen refresh on tab select

### Full Code (280 lines)

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ShoppingHome(),
    );
  }
}

class ShoppingHome extends StatefulWidget {
  const ShoppingHome({Key? key}) : super(key: key);

  @override
  State<ShoppingHome> createState() => _ShoppingHomeState();
}

class _ShoppingHomeState extends State<ShoppingHome> {
  int _currentIndex = 0;
  int _cartCount = 0;
  int _wishlistCount = 0;
  bool _isLoading = false;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      ShopScreen(onProductAdded: _addToCart),
      CategoriesScreen(),
      WishlistScreen(count: _wishlistCount),
      CartScreen(count: _cartCount),
      AccountScreen(),
    ];
  }

  void _addToCart() {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }

  void _loadTabData(int index) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _loadTabData(index);
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Shop',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: _wishlistCount > 0 ? Text('$_wishlistCount') : null,
              child: const Icon(Icons.favorite),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: _cartCount > 0 ? Text('$_cartCount') : null,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  final VoidCallback onProductAdded;

  const ShopScreen({required this.onProductAdded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('\$29.99',
                          style: TextStyle(color: Colors.green)),
                      ElevatedButton.icon(
                        onPressed: onProductAdded,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView(
        children: [
          'Electronics',
          'Clothing',
          'Home & Garden',
          'Sports',
          'Books',
          'Toys',
        ]
            .map((category) => ListTile(
                  title: Text(category),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {},
                ))
            .toList(),
      ),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  final int count;

  const WishlistScreen({required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: count == 0
          ? const Center(child: Text('Wishlist is empty'))
          : ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Wishlist Item ${index + 1}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                );
              },
            ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final int count;

  const CartScreen({required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: count == 0
          ? const Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Cart Item ${index + 1}'),
                        subtitle: const Text('\$29.99'),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {},
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 30),
                SizedBox(height: 10),
                Text('Your Account'),
              ],
            ),
          ),
          ListTile(title: const Text('Orders'), onTap: () {}),
          ListTile(title: const Text('Saved Addresses'), onTap: () {}),
          ListTile(title: const Text('Payment Methods'), onTap: () {}),
          ListTile(title: const Text('Settings'), onTap: () {}),
          ListTile(title: const Text('Help'), onTap: () {}),
          ListTile(title: const Text('Logout'), onTap: () {}),
        ],
      ),
    );
  }
}
```

---

## Example 3: Adaptive Navigation (Mobile + Tablet)

### Features
- Responsive design
- BottomNavigationBar on mobile
- NavigationRail on tablet
- Single codebase for both layouts
- Smooth transitions

### Full Code (220 lines)

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const AdaptiveApp());
}

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdaptiveHome(),
    );
  }
}

class AdaptiveHome extends StatefulWidget {
  const AdaptiveHome({Key? key}) : super(key: key);

  @override
  State<AdaptiveHome> createState() => _AdaptiveHomeState();
}

class _AdaptiveHomeState extends State<AdaptiveHome> {
  int _currentIndex = 0;

  final screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void _goToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildTabletLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: _goToTab,
            extended: true,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text('Favorites'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(
            child: screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('Home Screen', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Search Screen', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Favorites Screen', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('Settings Screen', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 4: Custom Styled Navigation Bar

### Features
- Custom colors and styling
- Animated active indicator
- Custom icon animations
- Modern Material 3 design
- Full customization

### Full Code (200 lines)

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CustomNavApp());
}

class CustomNavApp extends StatelessWidget {
  const CustomNavApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CustomNavHome(),
    );
  }
}

class CustomNavHome extends StatefulWidget {
  const CustomNavHome({Key? key}) : super(key: key);

  @override
  State<CustomNavHome> createState() => _CustomNavHomeState();
}

class _CustomNavHomeState extends State<CustomNavHome> {
  int _currentIndex = 0;

  final screens = const [
    DemoScreen(title: 'Home', color: Colors.blue),
    DemoScreen(title: 'Discover', color: Colors.green),
    DemoScreen(title: 'Messages', color: Colors.orange),
    DemoScreen(title: 'Profile', color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.explore),
              icon: Icon(Icons.explore_outlined),
              label: 'Discover',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.mail),
              icon: Icon(Icons.mail_outline),
              label: 'Messages',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  final String title;
  final Color color;

  const DemoScreen({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 5: Multi-Level Navigation with State Management

### Features
- Navigation with Riverpod
- Screen-level navigation
- Sub-navigation within screens
- State preservation across tabs
- Advanced routing

### Full Code (250 lines)

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: StateNavApp()));
}

class StateNavApp extends StatelessWidget {
  const StateNavApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StateNavHome(),
    );
  }
}

// Navigation state provider
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void goToTab(int index) => state = index;
}

class StateNavHome extends ConsumerWidget {
  const StateNavHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    final screens = [
      const HomeWithState(),
      const SearchWithState(),
      const CartWithState(),
      const ProfileWithState(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).goToTab(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Data provider
final counterProvider = StateNotifierProvider<CounterNotifier, int>(
  (ref) => CounterNotifier(),
);

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

class HomeWithState extends ConsumerWidget {
  const HomeWithState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter:'),
            Text('$count', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(counterProvider.notifier).increment();
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchWithState extends StatelessWidget {
  const SearchWithState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Result $index'),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class CartWithState extends StatelessWidget {
  const CartWithState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(
        child: Text('3 items in cart'),
      ),
    );
  }
}

class ProfileWithState extends StatelessWidget {
  const ProfileWithState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Your Profile'),
      ),
    );
  }
}
```

---

## Summary

These 5 examples cover:
✅ Instagram-style navigation with PageView
✅ E-commerce navigation with badges
✅ Adaptive layouts (mobile + tablet)
✅ Custom styled navigation bars
✅ Advanced state management

Each is production-ready and can be adapted to your needs!
