# Designing App Navigation Flow Using BottomNavigationBar

> **Master Flutter navigation architecture with professional tab-based UI patterns that work seamlessly across iOS and Android.**

---

## Table of Contents

1. [Why BottomNavigationBar Matters](#1-why-bottomnavigationbar-matters)
2. [Navigation Architecture Overview](#2-navigation-architecture-overview)
3. [Basic BottomNavigationBar Setup](#3-basic-bottomnavigationbar-setup)
4. [Advanced: PageView Integration](#4-advanced-pageview-integration)
5. [State Preservation Strategies](#5-state-preservation-strategies)
6. [UI Customization & Theming](#6-ui-customization--theming)
7. [Navigation Patterns & Architecture](#7-navigation-patterns--architecture)
8. [Material 3 NavigationBar](#8-material-3-navigationbar)
9. [Tablet Navigation: NavigationRail](#9-tablet-navigation-navigationrail)
10. [Deep Linking & Route Parameters](#10-deep-linking--route-parameters)
11. [UX Best Practices](#11-ux-best-practices)
12. [Common Issues & Solutions](#12-common-issues--solutions)
13. [Real-World App Patterns](#13-real-world-app-patterns)

---

## 1. Why BottomNavigationBar Matters

### The Problem It Solves
Modern mobile apps need intuitive primary navigation. Users expect:
- ✅ Quick access to major app sections
- ✅ Visual feedback on current location
- ✅ Persistent navigation UI
- ✅ State preservation when switching tabs
- ✅ Smooth screen transitions

### Real-World Examples
| App | Usage | Tab Count |
|-----|-------|-----------|
| **Instagram** | Home, Explore, Reels, Messages, Profile | 5 |
| **YouTube** | Home, Shorts, Subscriptions, Library, Account | 5 |
| **Twitter** | Home, Explore, Notifications, Messages, Bookmarks | 5 |
| **Spotify** | Home, Search, Library, Downloads | 4 |
| **TikTok** | For You, Discover, Inbox, Profile | 4 |
| **Banking Apps** | Accounts, Cards, Transfers, Settings, Support | 5 |
| **E-commerce** | Shop, Cart, Orders, Favorites, Account | 5 |

### Business Benefits
- **Reduced Bounce Rate**: Users navigate more easily = longer sessions
- **Feature Discovery**: Primary features are visible = increased engagement
- **Lower Support Costs**: Intuitive navigation = fewer support tickets
- **Competitive Advantage**: Professional UI = increased user trust
- **Analytics Insights**: Track tab usage = understand user behavior

---

## 2. Navigation Architecture Overview

### Core Components

#### A. BottomNavigationBar (Material Design 2)
```dart
// Traditional, well-supported, widely used
// Best for: Apps with 3-5 primary sections
// Icons + labels visible on selected
BottomNavigationBar(
  items: [...],
  currentIndex: _index,
  onTap: (index) {},
)
```

#### B. NavigationBar (Material 3)
```dart
// Modern Material 3 design
// Best for: New projects, forward-looking apps
// All icons visible with animated labels
NavigationBar(
  destinations: [...],
  selectedIndex: _index,
  onDestinationSelected: (index) {},
)
```

#### C. NavigationRail
```dart
// Vertical sidebar navigation
// Best for: Tablet/desktop apps
// Left-side navigation panel
NavigationRail(
  destinations: [...],
  selectedIndex: _index,
  onDestinationSelected: (index) {},
)
```

#### D. PageView + BottomNavigationBar
```dart
// Combines tab navigation with swipe gestures
// Best for: Apps requiring gesture navigation
// Fast performance, smooth animations
PageView(
  controller: _pageController,
  children: screens,
  onPageChanged: (index) {},
)
```

### Architecture Decision Tree

```
Is app mobile-only?
├─ Yes: BottomNavigationBar or NavigationBar
└─ No: Use adaptive layout
  ├─ Mobile: BottomNavigationBar
  └─ Tablet: NavigationRail + main content

Needs swipe navigation?
├─ Yes: Use PageView with PageController
└─ No: Use IndexedStack or direct screen replacement

State preservation needed?
├─ Critical: Use PageView or IndexedStack
└─ Not critical: Simple setState approach
```

---

## 3. Basic BottomNavigationBar Setup

### Step 1: Define Your Navigation Model

```dart
class NavigationTab {
  final String label;
  final IconData icon;
  final Widget screen;
  final String? badge;

  NavigationTab({
    required this.label,
    required this.icon,
    required this.screen,
    this.badge,
  });
}

// Usage
final tabs = [
  NavigationTab(
    label: 'Home',
    icon: Icons.home,
    screen: HomeScreen(),
  ),
  NavigationTab(
    label: 'Search',
    icon: Icons.search,
    screen: SearchScreen(),
  ),
  NavigationTab(
    label: 'Profile',
    icon: Icons.person,
    screen: ProfileScreen(),
  ),
];
```

### Step 2: Implement Navigation in StatefulWidget

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final tabs = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
```

### Step 3: Handle Tab Selection

```dart
onTap: (index) {
  // Track analytics
  _analytics.logTabChange(index);
  
  // Update state
  setState(() => _currentIndex = index);
  
  // Optional: Trigger data refresh
  if (index == 0) {
    _refreshHomeData();
  }
}
```

---

## 4. Advanced: PageView Integration

### Why PageView?

| Feature | Simple setState | PageView |
|---------|-----------------|----------|
| **Swipe Navigation** | ❌ No | ✅ Yes |
| **Performance** | ✅ Good | ✅ Better |
| **Gesture Support** | ❌ No | ✅ Yes |
| **Smooth Animations** | ⚠️ Manual | ✅ Built-in |
| **Memory Usage** | ✅ Lower | ⚠️ Higher |
| **Code Complexity** | ✅ Simple | ⚠️ Complex |

### Implementation Pattern

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PageController _pageController;
  int _currentIndex = 0;

  final screens = const [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

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

  // Navigate to tab programmatically
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
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
```

### PageView Advanced Options

```dart
PageView(
  controller: _pageController,
  physics: const BouncingScrollPhysics(), // Bouncy scrolling
  pageSnapping: true, // Stop at whole pages
  reverse: false, // Can be true for RTL apps
  children: screens,
)
```

---

## 5. State Preservation Strategies

### Problem: Tabs Reset When Switching
When you tap a tab, return to another tab, the screen rebuilds and loses state.

### Solution 1: IndexedStack (Simplest)

```dart
class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // Create screens once
  late final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens, // All screens kept alive!
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [...],
      ),
    );
  }
}
```

**Pros**: Simple, preserves state
**Cons**: All screens rendered (memory), visible only for current

### Solution 2: PageView (Better Performance)

```dart
PageView(
  controller: _pageController,
  children: screens,
  onPageChanged: (index) => setState(() => _currentIndex = index),
)
```

**Pros**: Smooth scrolling, gesture support
**Cons**: Slightly more complex

### Solution 3: KeepAlive with AutomaticKeepAliveClientMixin

```dart
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep this widget alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required with mixin
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home content')),
    );
  }
}
```

**Pros**: Fine-grained control, per-screen basis
**Cons**: More verbose, requires mixin

### Comparison Table

| Strategy | Memory | Performance | State Preserved | Swipe Support |
|----------|--------|-------------|-----------------|---------------|
| **Simple setState** | ✅ Low | ✅ Good | ❌ No | ❌ No |
| **IndexedStack** | ⚠️ Higher | ⚠️ Fair | ✅ Yes | ❌ No |
| **PageView** | ⚠️ Higher | ✅ Good | ✅ Yes | ✅ Yes |
| **KeepAlive** | ✅ Low | ✅ Good | ✅ Yes | ⚠️ Manual |

---

## 6. UI Customization & Theming

### Colors & Appearance

```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  
  // Colors
  backgroundColor: Colors.white,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  
  // Labels
  showSelectedLabels: true,
  showUnselectedLabels: false,
  
  // Type
  type: BottomNavigationBarType.fixed, // All visible
  // type: BottomNavigationBarType.shifting, // Only selected visible
  
  // Elevation
  elevation: 8,
  
  // Size
  iconSize: 24,
  
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      activeIcon: Icon(Icons.home_filled),
      label: "Home",
      backgroundColor: Colors.blue.shade50,
    ),
    // ... more items
  ],
)
```

### Theme via ThemeData

```dart
MaterialApp(
  theme: ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  ),
  home: MyApp(),
)
```

### Custom Styling

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, -2),
      ),
    ],
  ),
  child: BottomNavigationBar(
    // ... properties
  ),
)
```

### Badge Support

```dart
BottomNavigationBarItem(
  icon: Badge(
    label: Text('5'),
    child: Icon(Icons.shopping_cart),
  ),
  label: "Cart",
)
```

---

## 7. Navigation Patterns & Architecture

### Pattern 1: Simple Index-Based

```dart
// Best for: Small apps, simple navigation
// Cons: No deep linking, limited state management
int _currentIndex = 0;
setState(() => _currentIndex = index);
```

### Pattern 2: Named Routes

```dart
// Best for: Medium complexity, need for deep linking
// Setup
final routes = {
  '/home': (_) => HomeScreen(),
  '/search': (_) => SearchScreen(),
  '/profile': (_) => ProfileScreen(),
};

// Usage
Navigator.pushReplacementNamed(context, routes.keys.elementAt(index));
```

### Pattern 3: Router with GoRouter

```dart
// Best for: Complex apps, deep linking, web support
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => SearchScreen(),
    ),
  ],
);

// In widget
GoRouter.of(context).go('/search');
```

### Pattern 4: Riverpod/Provider Navigation State

```dart
// Best for: Complex state management
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationProvider = StateNotifierProvider<
    NavigationNotifier,
    int>((ref) => NavigationNotifier());

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void goToTab(int index) {
    state = index;
  }
}

// Usage
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).goToTab(index);
        },
        items: [...],
      ),
    );
  }
}
```

---

## 8. Material 3 NavigationBar

### Why Material 3?
- Modern design language
- Better aesthetics
- Forward-compatible
- Adaptive to platform

### Implementation

```dart
NavigationBar(
  onDestinationSelected: (int index) {
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
      selectedIcon: Icon(Icons.search),
      icon: Icon(Icons.search_outlined),
      label: 'Search',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.person),
      icon: Icon(Icons.person_outlined),
      label: 'Profile',
    ),
  ],
)
```

### Styling

```dart
NavigationBar(
  backgroundColor: Colors.white,
  indicatorColor: Colors.blue,
  elevation: 8,
  // ... other properties
)
```

---

## 9. Tablet Navigation: NavigationRail

### Two-Pane Layout for Tablets

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
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
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
              ],
            ),
            Expanded(child: screens[_currentIndex]),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    }
  }
}
```

### NavigationRail Options

```dart
NavigationRail(
  extended: true, // Show labels
  minWidth: 80,
  minExtendedWidth: 200,
  backgroundColor: Colors.white,
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: [
    // ... destinations
  ],
)
```

---

## 10. Deep Linking & Route Parameters

### Passing Data Between Tabs

```dart
class HomeScreen extends StatelessWidget {
  final String? data;

  const HomeScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home: ${data ?? "No data"}')),
      body: Center(child: Text('Home Screen')),
    );
  }
}
```

### Navigate with Data

```dart
onTap: (index) {
  setState(() => _currentIndex = index);
  
  // Update screen with data
  if (index == 0) {
    _screens[0] = HomeScreen(data: 'Passed data');
  }
}
```

### Deep Linking with GoRouter

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductScreen(productId: id);
      },
    ),
  ],
);

// From bottom nav
onTap: (index) {
  if (index == 2) {
    context.go('/product/123');
  }
}
```

---

## 11. UX Best Practices

### 1. Right Number of Tabs

```
✅ GOOD: 3-5 tabs
├─ 3 tabs: Minimum for navigation (too few = less useful)
├─ 4 tabs: Sweet spot for most apps
├─ 5 tabs: Maximum before icons shrink too much
└─ More: Use "More" tab or drawer

❌ BAD: 1-2 tabs (no point in bottom nav)
❌ BAD: 6+ tabs (crowded, confusing)
```

### 2. Icon + Label Pairing

```dart
✅ GOOD
BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: "Home",           // Clear, short
)

❌ BAD
BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: "Home Screen",    // Too verbose
)

❌ BAD
BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: "H",              // Too short, unclear
)
```

### 3. Consistency

```dart
// Use same icon style across app
✅ GOOD: All filled icons or all outlined
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined),
  activeIcon: Icon(Icons.home),
  label: "Home",
)

❌ BAD: Mix and match styles
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined), // Outlined
  activeIcon: Icon(Icons.home_filled), // Filled (different style)
)
```

### 4. Avoid Destructive Actions

```dart
❌ WRONG: Delete account in navigation
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(label: "Delete"), // Dangerous!
  ],
)

✅ RIGHT: Settings/Profile tab
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(label: "Settings"),
  ],
)
// Then in settings, provide delete with confirmation
```

### 5. Loading States

```dart
// Show loading indicator
onTap: (index) async {
  setState(() => _isLoading = true);
  await _loadTabData(index);
  setState(() {
    _currentIndex = index;
    _isLoading = false;
  });
}

// Or use BottomNavigationBar.badge
BottomNavigationBarItem(
  icon: _isLoading ? SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(),
  ) : Icon(Icons.home),
  label: "Home",
)
```

### 6. Animation Feedback

```dart
// Provide visual feedback on tab change
onTap: (index) {
  // Haptic feedback
  HapticFeedback.lightImpact();
  
  // Animate to page
  _pageController.animateToPage(
    index,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
```

### 7. Accessibility

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: "Home",
  tooltip: "Go to home screen", // Accessibility
)
```

---

## 12. Common Issues & Solutions

### Issue 1: Tabs Reset When Switching

**Problem**: You navigate to tab 1, then tap another tab. When you return to tab 1, it rebuilds and loses state.

**Root Cause**: 
- Recreating screen widgets in build()
- Not preserving state across tab changes

**Solutions**:
```dart
// ❌ WRONG: Creates new screen each time
body: [HomeScreen(), SearchScreen()][_currentIndex]

// ✅ CORRECT: Create screens once
late final screens = [HomeScreen(), SearchScreen()];
body: screens[_currentIndex]

// ✅ BETTER: Use IndexedStack
body: IndexedStack(
  index: _currentIndex,
  children: screens,
)

// ✅ BEST: Use PageView with state preservation
body: PageView(children: screens)
```

### Issue 2: Navigation Feels Laggy

**Problem**: Switching tabs has noticeable delay or jank.

**Root Cause**:
- Heavy widgets rebuilding
- Expensive operations in build()
- Non-const widgets

**Solutions**:
```dart
// ✅ Use const widgets
const BottomNavigationBarItem(
  icon: Icon(Icons.home),
  label: "Home",
)

// ✅ Move heavy operations out of build
@override
void initState() {
  _loadData(); // Not in build!
}

// ✅ Use precomputed values
final screens = const [
  HomeScreen(),
  SearchScreen(),
];

// ✅ Profile and optimize
// Use DevTools to find performance bottlenecks
```

### Issue 3: Incorrect Tab Highlighting

**Problem**: Bottom nav shows wrong tab as selected.

**Root Cause**:
- Mismatched index between PageView and BottomNavigationBar
- Index not updating properly

**Solutions**:
```dart
// ✅ Sync index with PageView
PageView(
  onPageChanged: (index) {
    setState(() => _currentIndex = index); // Update index
  },
)

BottomNavigationBar(
  currentIndex: _currentIndex, // Use same index
  onTap: (index) {
    _pageController.animateToPage(index, ...);
  },
)

// ✅ Debug
print('Current index: $_currentIndex');
print('PageView index: ${_pageController.page}');
```

### Issue 4: Icons Not Visible

**Problem**: Bottom nav icons don't show.

**Root Cause**:
- No color assigned
- Icon size too small
- Wrong color for theme

**Solutions**:
```dart
// ✅ Set colors explicitly
BottomNavigationBar(
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
)

// ✅ Set via theme
theme: ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
)

// ✅ Check icon size
BottomNavigationBar(
  iconSize: 24, // Default is 24
)
```

### Issue 5: Crashes on Screen Changes

**Problem**: App crashes when switching tabs.

**Root Cause**:
- Screens list being rebuilt
- Null pointer exceptions
- Async operations not handled

**Solutions**:
```dart
// ✅ Initialize screens in initState or as final
@override
void initState() {
  super.initState();
  _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
}

// ✅ Or make static
static final screens = [
  HomeScreen(),
  SearchScreen(),
  ProfileScreen(),
];

// ✅ Handle async operations
onTap: (index) async {
  try {
    await _loadData(index);
    if (mounted) {
      setState(() => _currentIndex = index);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### Issue 6: PageView Too Sensitive

**Problem**: Accidental swipes switch tabs.

**Root Cause**:
- PageView physics too sensitive
- No friction

**Solutions**:
```dart
// ✅ Adjust physics
PageView(
  physics: const ClampingScrollPhysics(), // Less bouncy
  // or
  physics: const NeverScrollableScrollPhysics(), // Disable swipe
)

// ✅ Require more swipe distance
PageView(
  dragStartBehavior: DragStartBehavior.down,
)
```

---

## 13. Real-World App Patterns

### Pattern 1: Instagram-Like Navigation

```dart
class InstagramApp extends StatefulWidget {
  @override
  State<InstagramApp> createState() => _InstagramAppState();
}

class _InstagramAppState extends State<InstagramApp> {
  late PageController _pageController;
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          HomeScreen(),
          ExploreScreen(),
          ReelsScreen(),
          MessagesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

### Pattern 2: E-Commerce Navigation

```dart
class ShoppingApp extends StatefulWidget {
  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  int _currentIndex = 0;
  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onProductAdded: () {
            setState(() => _cartCount++);
          }),
          CategoriesScreen(),
          WishlistScreen(),
          CartScreen(itemCount: _cartCount),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Badge(label: Text(_cartCount.toString()),
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
```

### Pattern 3: Responsive Navigation (Mobile + Tablet)

```dart
class ResponsiveApp extends StatefulWidget {
  @override
  State<ResponsiveApp> createState() => _ResponsiveAppState();
}

class _ResponsiveAppState extends State<ResponsiveApp> {
  int _currentIndex = 0;

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
      body: [
        HomeScreen(),
        SearchScreen(),
        ProfileScreen(),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
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
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          Expanded(
            child: [
              HomeScreen(),
              SearchScreen(),
              ProfileScreen(),
            ][_currentIndex],
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

### What You've Learned
✅ Why bottom navigation matters for app UX
✅ How to implement basic BottomNavigationBar
✅ Advanced PageView integration with swipe support
✅ State preservation strategies (IndexedStack, PageView, KeepAlive)
✅ Customization and theming options
✅ Material 3 NavigationBar modern design
✅ Adaptive layouts for tablets (NavigationRail)
✅ Deep linking and route parameters
✅ UX best practices for navigation
✅ Troubleshooting common issues
✅ Real-world app patterns

### Key Principles
1. **Choose the right approach**: Simple apps → setState, complex apps → PageView
2. **Preserve state**: Use IndexedStack or PageView for seamless UX
3. **Design for users**: 3-5 tabs, clear labels, consistent icons
4. **Handle edge cases**: Loading states, error handling, accessibility
5. **Test thoroughly**: Verify swipe, tab selection, state preservation

---

## Next Steps

1. **[BOTTOM_NAVIGATION_QUICK_START.md](BOTTOM_NAVIGATION_QUICK_START.md)** → Get started in 10 minutes
2. **[BOTTOM_NAVIGATION_CODE_EXAMPLES.md](BOTTOM_NAVIGATION_CODE_EXAMPLES.md)** → See production examples
3. **[BOTTOM_NAVIGATION_IMPLEMENTATION_CHECKLIST.md](BOTTOM_NAVIGATION_IMPLEMENTATION_CHECKLIST.md)** → Follow step-by-step guide
4. **Build your navigation** → Apply to your app
5. **Test thoroughly** → Verify across devices

**Start with Quick Start for immediate results, or dive into Code Examples for detailed patterns!**
