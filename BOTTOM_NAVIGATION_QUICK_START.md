# Designing App Navigation - Quick Start

> **Build a working bottom navigation app in 10 minutes.**

---

## 5-Minute Setup: Complete Navigation App

### Step 1: Create Basic Screens (2 min)

```dart
// lib/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('Welcome to Home', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// lib/screens/search_screen.dart
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text('Search Results', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// lib/screens/profile_screen.dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.purple),
            SizedBox(height: 16),
            Text('Your Profile', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
```

### Step 2: Create Main Navigation Widget (5 min)

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NavigationApp(),
    );
  }
}

class NavigationApp extends StatefulWidget {
  const NavigationApp({Key? key}) : super(key: key);

  @override
  State<NavigationApp> createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
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
      // Current screen based on index
      body: screens[_currentIndex],
      
      // Bottom navigation
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
```

### Step 3: Run & Test (1 min)

```bash
flutter run
```

✅ Tap tabs to switch screens
✅ UI updates instantly
✅ Done!

---

## Quick Concepts Reference

### What's Happening

```
┌─────────────────────────────────┐
│      Scaffold                   │
├─────────────────────────────────┤
│                                 │
│    screens[_currentIndex]       │
│  (HomeScreen, SearchScreen...)  │
│                                 │
├─────────────────────────────────┤
│  BottomNavigationBar            │
│  Home | Search | Profile        │
└─────────────────────────────────┘

onTap → setState → _currentIndex changes → UI rebuilds
```

### The Pattern

```dart
// 1. Track current tab
int _currentIndex = 0;

// 2. Create screens (once!)
final screens = [Screen1(), Screen2(), Screen3()];

// 3. Show screen based on index
body: screens[_currentIndex]

// 4. Update index on tap
onTap: (index) => setState(() => _currentIndex = index)

// 5. UI rebuilds automatically
```

---

## Common Customizations

### Add Colors

```dart
BottomNavigationBar(
  selectedItemColor: Colors.blue,      // Selected tab color
  unselectedItemColor: Colors.grey,    // Unselected tab color
  showUnselectedLabels: false,         // Hide unselected labels
  // ... rest of config
)
```

### Add Styling

```dart
BottomNavigationBar(
  backgroundColor: Colors.white,       // Navigation background
  elevation: 8,                        // Shadow elevation
  type: BottomNavigationBarType.fixed, // All tabs visible
  iconSize: 24,                        // Icon size
  // ... rest of config
)
```

### Add Badges (Notifications)

```dart
BottomNavigationBarItem(
  icon: Badge(
    label: Text('5'),                  // Notification count
    child: Icon(Icons.shopping_cart),
  ),
  label: 'Cart',
)
```

---

## Switching to PageView (With Swipe)

Want swipe gestures? Use PageView:

```dart
class _NavigationAppState extends State<NavigationApp> {
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
          SearchScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

Now users can:
- ✅ Tap tabs
- ✅ Swipe left/right to change screens
- ✅ See smooth transitions

---

## Common Issues & Quick Fixes

### Problem: Tabs Reset When Switching

```dart
❌ WRONG
body: [HomeScreen(), SearchScreen()][_currentIndex]

✅ RIGHT
final screens = [HomeScreen(), SearchScreen()];
body: screens[_currentIndex]
```

### Problem: Icons Not Showing

```dart
❌ WRONG
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home)),
  ],
)

✅ RIGHT
BottomNavigationBar(
  selectedItemColor: Colors.blue,    // Add color!
  unselectedItemColor: Colors.grey,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',                 // Add label!
    ),
  ],
)
```

### Problem: Wrong Tab Highlighted

```dart
// Make sure these match:
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,  // This value
  onTap: (index) {
    setState(() => _currentIndex = index); // Updates this
  },
  items: [...],
)
```

---

## Testing Your Implementation

### Test Checklist

- [ ] Tap each tab → Screen changes
- [ ] Tab shows as selected (highlighted color)
- [ ] Icons are visible
- [ ] Labels display correctly
- [ ] No crashes or errors
- [ ] Smooth transitions (not jarring)
- [ ] Works on different screen sizes

### Test on Device/Emulator

```bash
# Run on connected device
flutter run

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d emulator-5554
```

---

## Next Steps

### Learn More
1. See full **Code Examples** for advanced patterns
2. Study **README** for comprehensive guide
3. Use **Checklist** to verify implementation

### Production Ready
- Add error handling
- Add analytics tracking
- Optimize for performance
- Test accessibility

### Try These Enhancements
```dart
// Track tab changes
onTap: (index) {
  analytics.logEvent(name: 'tab_change', parameters: {'tab': index});
  setState(() => _currentIndex = index);
}

// Add haptic feedback
onTap: (index) {
  HapticFeedback.lightImpact();
  setState(() => _currentIndex = index);
}

// Show loading state
onTap: (index) async {
  setState(() => _isLoading = true);
  await _loadTabData(index);
  setState(() {
    _currentIndex = index;
    _isLoading = false;
  });
}
```

---

## Key Takeaways

✅ BottomNavigationBar is simple: track index → show screen → update on tap
✅ Create screens once, reuse them
✅ Use PageView for swipe support
✅ Preserve state with IndexedStack
✅ Customize colors, icons, and labels easily
✅ Test on real devices!

**You're ready to add navigation to your app! 🚀**
