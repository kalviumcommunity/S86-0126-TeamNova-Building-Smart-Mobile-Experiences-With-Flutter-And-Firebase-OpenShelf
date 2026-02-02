# Using MediaQuery and LayoutBuilder for Responsive Design

## 📱 OpenShelf - Team Nova

This document demonstrates the implementation of responsive design in the OpenShelf Flutter application using **MediaQuery** and **LayoutBuilder** to create adaptive UIs that look great on all screen sizes.

---

## 🎯 Overview

Responsive design ensures that your app's interface automatically adjusts to different screen sizes and orientations. We've implemented two comprehensive screens that showcase responsive design techniques:

1. **Responsive Design Demo** - Educational showcase of MediaQuery and LayoutBuilder features
2. **Responsive Dashboard** - Real-world implementation with adaptive navigation and layouts

### Key Technologies Used:
- **MediaQuery** - Access device dimensions, orientation, and pixel density
- **LayoutBuilder** - Build conditional layouts based on available space
- **Breakpoint-based Design** - Different layouts for mobile (<600px) and tablet (≥600px)

---

## 📂 Project Structure

```
lib/
├── screens/
│   ├── responsive_design_demo.dart      # Educational demo screen
│   └── responsive_dashboard.dart        # Real-world dashboard implementation
└── main.dart                            # Updated with new routes
```

---

## 🛠️ Implementation

### 1. MediaQuery for Device Information

**What is MediaQuery?**  
MediaQuery provides access to information about the device's screen size, orientation, pixel density, and more.

**Code Example:**

```dart
// Get device information
final mediaQuery = MediaQuery.of(context);
final screenWidth = mediaQuery.size.width;
final screenHeight = mediaQuery.size.height;
final orientation = mediaQuery.orientation;
final devicePixelRatio = mediaQuery.devicePixelRatio;

// Determine device type
final isMobile = screenWidth < 600;
final isTablet = screenWidth >= 600 && screenWidth < 900;
final isDesktop = screenWidth >= 900;
```

**Usage - Responsive Sizing:**

```dart
// Container that takes 80% of screen width
Container(
  width: screenWidth * 0.8,  // 80% of screen width
  height: 100,
  child: Text('Responsive Container'),
)

// Adaptive font size
Text(
  'Adaptive Text',
  style: TextStyle(
    fontSize: screenWidth < 600 ? 20 : 28,  // Smaller on mobile
  ),
)
```

**Benefits:**
- ✅ Percentage-based sizing that scales with screen size
- ✅ Adaptive typography for better readability
- ✅ Device-aware spacing and padding

---

### 2. LayoutBuilder for Conditional Layouts

**What is LayoutBuilder?**  
LayoutBuilder provides the constraints of its parent widget, allowing you to build different widget trees based on available space.

**Code Example:**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // Check available width
    if (constraints.maxWidth < 600) {
      // MOBILE LAYOUT - Vertical stacking
      return Column(
        children: [
          Text('Mobile View'),
          Icon(Icons.phone_android, size: 80),
        ],
      );
    } else {
      // TABLET LAYOUT - Horizontal arrangement
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tablet View'),
          SizedBox(width: 20),
          Icon(Icons.tablet, size: 100),
        ],
      );
    }
  },
)
```

**Benefits:**
- ✅ Different layouts for different screen sizes
- ✅ Optimized use of available space
- ✅ Improved user experience on tablets vs phones

---

### 3. Combining MediaQuery and LayoutBuilder

**Best Practice:** Use both together for maximum flexibility

```dart
class ResponsiveDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Responsive Design')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (screenWidth < 600) {
            // MOBILE: Stack vertically
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.8,
                  height: 100,
                  color: Colors.tealAccent,
                  child: Center(child: Text('Mobile View')),
                ),
              ],
            );
          } else {
            // TABLET: Arrange horizontally
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 250,
                  height: 150,
                  color: Colors.orangeAccent,
                  child: Center(child: Text('Tablet Left Panel')),
                ),
                Container(
                  width: 250,
                  height: 150,
                  color: Colors.tealAccent,
                  child: Center(child: Text('Tablet Right Panel')),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
```

---

## 📱 Screen 1: Responsive Design Demo

**File:** `lib/screens/responsive_design_demo.dart`  
**Route:** `/responsive-design-demo`

This educational screen demonstrates all responsive design concepts:

### Features:

#### 1. **Device Information Display**
Shows real-time screen metrics using MediaQuery:
- Screen width and height
- Orientation (portrait/landscape)
- Pixel density ratio
- Device type (mobile/tablet)

#### 2. **Responsive Containers**
Three containers sized at 80%, 60%, and 40% of screen width:
```dart
Container(
  width: screenWidth * 0.8,  // 80% width
  height: 80,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Center(child: Text('80% Screen Width')),
)
```

#### 3. **Adaptive Layout Cards**
Uses LayoutBuilder to show different layouts:
- **Mobile (<600px):** Vertical Column layout with stacked cards
- **Tablet (≥600px):** Horizontal Row layout with side-by-side cards

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    
    if (isMobile) {
      return Column(children: [...]);  // Stack vertically
    } else {
      return Row(children: [...]);     // Arrange horizontally
    }
  },
)
```

#### 4. **Responsive Grid**
Grid that adapts its column count based on screen width:
- Mobile (<600px): 2 columns
- Tablet (600-900px): 3 columns
- Desktop (≥900px): 4 columns

```dart
int crossAxisCount;
if (constraints.maxWidth < 600) {
  crossAxisCount = 2;    // Mobile
} else if (constraints.maxWidth < 900) {
  crossAxisCount = 3;    // Tablet
} else {
  crossAxisCount = 4;    // Desktop
}
```

#### 5. **Responsive Typography**
Text size adapts to screen width:
```dart
Text(
  'Adaptive Font Size',
  style: TextStyle(
    fontSize: screenWidth < 600 ? 20 : 28,  // Larger on tablets
  ),
)
```

---

## 📊 Screen 2: Responsive Dashboard

**File:** `lib/screens/responsive_dashboard.dart`  
**Route:** `/responsive-dashboard`

A real-world implementation of a responsive dashboard for the OpenShelf app.

### Features:

#### 1. **Adaptive Navigation**
Different navigation patterns for different screen sizes:

**Mobile (< 600px):** Bottom Navigation Bar
```dart
NavigationBar(
  destinations: [
    NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.book), label: 'Library'),
    NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
  ],
)
```

**Tablet (≥ 600px):** Side Navigation Rail
```dart
NavigationRail(
  destinations: [
    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
    NavigationRailDestination(icon: Icon(Icons.book), label: Text('Library')),
    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
  ],
)
```

#### 2. **Responsive Stats Grid**
Stats cards that reflow based on available width:
- Mobile: 2 columns
- Tablet: 3 columns
- Desktop: 4 columns

```dart
GridView.count(
  crossAxisCount: columns,  // Dynamically determined
  children: [
    _buildStatCard('Total Books', '127', Icons.library_books, Colors.blue),
    _buildStatCard('Reading', '8', Icons.menu_book, Colors.orange),
    _buildStatCard('Completed', '89', Icons.check_circle, Colors.green),
    _buildStatCard('Wish List', '30', Icons.bookmark, Colors.purple),
  ],
)
```

#### 3. **Adaptive Book Display**
Different layouts for mobile vs tablet:

**Mobile:** Vertical list with horizontal book cards
```dart
Column(
  children: List.generate(
    3,
    (index) => _buildHorizontalBookCard(index),
  ),
)
```

**Tablet:** Horizontal scrolling list with vertical cards
```dart
SizedBox(
  height: 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) => _buildBookCard(index),
  ),
)
```

#### 4. **Context-Aware Spacing**
Padding and spacing adjust based on screen size:
```dart
Padding(
  padding: EdgeInsets.all(isLargeScreen ? 24 : 16),  // More padding on tablets
  child: Column(children: [...]),
)
```

---

## 📏 Breakpoint Strategy

We use a consistent breakpoint strategy across all screens:

| Breakpoint | Width | Device Type | Layout Strategy |
|------------|-------|-------------|----------------|
| Mobile | < 600px | Phones | Vertical stacking, 2 columns |
| Tablet | 600-900px | Small tablets | Mixed layouts, 3 columns |
| Desktop | ≥ 900px | Large tablets/Desktop | Side-by-side, 4 columns |

**Why 600px?**  
This is a common breakpoint that works well for most phones vs tablets. Material Design also uses this as a standard breakpoint.

---

## 🎨 Design Patterns Used

### 1. **Fluid Layouts**
Elements resize proportionally using percentages:
```dart
width: screenWidth * 0.8  // 80% of available width
```

### 2. **Breakpoint-Based Layouts**
Different widget trees for different screen sizes:
```dart
if (width < 600) {
  return MobileLayout();
} else {
  return TabletLayout();
}
```

### 3. **Adaptive Navigation**
Navigation patterns that suit each device:
- Mobile: Bottom bar (easy thumb access)
- Tablet: Side rail (better use of horizontal space)

### 4. **Responsive Grids**
Grid columns adapt to screen width:
```dart
crossAxisCount: width < 600 ? 2 : (width < 900 ? 3 : 4)
```

### 5. **Context-Aware Typography**
Text sizes scale with screen size:
```dart
fontSize: isLargeScreen ? 32 : 24
```

---

## 📱 Testing Responsiveness

### How to Test:

1. **Run on Different Emulators:**
   ```bash
   flutter run
   ```
   
2. **Test Devices:**
   - Mobile: Pixel 4, iPhone 13 Pro
   - Tablet: Nexus 9, iPad Pro
   - Different orientations: Portrait and Landscape

3. **Check for:**
   - ✅ No overflow errors
   - ✅ Proper layout adaptation
   - ✅ Readable text sizes
   - ✅ Appropriate spacing
   - ✅ Smooth transitions

### Testing Checklist:
- [ ] Test on mobile emulator (portrait)
- [ ] Test on mobile emulator (landscape)
- [ ] Test on tablet emulator (portrait)
- [ ] Test on tablet emulator (landscape)
- [ ] Verify all breakpoints work
- [ ] Check grid column counts
- [ ] Verify navigation adapts correctly
- [ ] Test responsive font sizes

---

## 📸 Screenshots

### Mobile View (Portrait)
![Responsive Design Demo - Mobile](screenshots/responsive-design/demo_mobile_portrait.png)

*Shows device info, responsive containers, and mobile layout (Column)*

---

### Tablet View (Landscape)
![Responsive Design Demo - Tablet](screenshots/responsive-design/demo_tablet_landscape.png)

*Shows tablet layout with Row arrangement and 4-column grid*

---

### Dashboard - Mobile
![Responsive Dashboard - Mobile](screenshots/responsive-design/dashboard_mobile.png)

*2-column stats, bottom navigation, vertical book list*

---

### Dashboard - Tablet
![Responsive Dashboard - Tablet](screenshots/responsive-design/dashboard_tablet.png)

*4-column stats, side navigation rail, horizontal book scrolling*

---

### Adaptive Grid Comparison
![Grid Responsive Behavior](screenshots/responsive-design/grid_comparison.png)

*2 columns (mobile) vs 4 columns (tablet)*

---

## 💡 Code Highlights

### MediaQuery Usage Example:
```dart
// From responsive_design_demo.dart
final mediaQuery = MediaQuery.of(context);
final screenWidth = mediaQuery.size.width;
final screenHeight = mediaQuery.size.height;
final orientation = mediaQuery.orientation;

// Use for responsive sizing
Container(
  width: screenWidth * 0.8,
  height: screenHeight * 0.1,
  // ...
)
```

### LayoutBuilder Usage Example:
```dart
// From responsive_dashboard.dart
LayoutBuilder(
  builder: (context, constraints) {
    final isLargeScreen = constraints.maxWidth >= 600;
    
    return Scaffold(
      body: Row(
        children: [
          if (isLargeScreen) NavigationRail(...),  // Only on tablet
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: isLargeScreen ? null : NavigationBar(...),
    );
  },
)
```

### Responsive Grid Example:
```dart
// Adaptive column count
int columns;
if (constraints.maxWidth < 600) {
  columns = 2;  // Mobile
} else if (constraints.maxWidth < 900) {
  columns = 3;  // Tablet
} else {
  columns = 4;  // Desktop
}

GridView.count(
  crossAxisCount: columns,
  // ...
)
```

---

## 🎯 Reflection

### Why is responsiveness important in mobile development?

Responsiveness is critical in mobile development for several key reasons:

1. **Device Diversity:** The mobile ecosystem includes hundreds of device sizes from small phones to large tablets. A fixed-size layout that looks great on one device might be unusable on another. Our OpenShelf app needs to work perfectly whether users have a compact iPhone SE or a large iPad Pro.

2. **User Experience:** Users expect apps to feel "native" to their device. A phone user shouldn't see a cramped tablet layout, and a tablet user shouldn't see a stretched phone interface. By using responsive design, we ensure that:
   - Text is always readable (adaptive font sizes)
   - Touch targets are appropriately sized
   - Content makes optimal use of available space
   - Navigation is device-appropriate (bottom bar on phones, side rail on tablets)

3. **Orientation Changes:** Users frequently rotate their devices. Our responsive implementation handles both portrait and landscape orientations gracefully, automatically adjusting layouts without breaking the UI.

4. **Accessibility:** Responsive design supports users with different needs. Larger screens can show more content simultaneously, while smaller screens can focus on one task at a time. Our adaptive typography ensures text is readable regardless of device size.

5. **Future-Proofing:** New devices with different screen sizes are constantly released. By using percentage-based sizing and breakpoints rather than hardcoded pixels, our app will automatically adapt to future devices without requiring updates.

6. **Business Impact:** Apps that don't adapt to different screen sizes get lower ratings and more uninstalls. A responsive design increases user satisfaction and retention.

### How does LayoutBuilder differ from MediaQuery?

While both LayoutBuilder and MediaQuery are used for responsive design, they serve different purposes and have important distinctions:

**MediaQuery:**
- **Scope:** Provides information about the entire device/screen
- **Data:** Returns screen dimensions, orientation, pixel density, text scale factor, etc.
- **Use Case:** When you need to make decisions based on the device's overall characteristics
- **Example:** `MediaQuery.of(context).size.width` gives you the full screen width

```dart
// MediaQuery - Device-level information
final screenWidth = MediaQuery.of(context).size.width;
if (screenWidth < 600) {
  // Decision based on entire screen width
}
```

**LayoutBuilder:**
- **Scope:** Provides information about the specific widget's available space
- **Data:** Returns BoxConstraints (maxWidth, maxHeight, minWidth, minHeight)
- **Use Case:** When you need to make decisions based on the space available to a specific widget
- **Example:** A sidebar might have different width than the screen, LayoutBuilder tells you that widget's actual space

```dart
// LayoutBuilder - Widget-level constraints
LayoutBuilder(
  builder: (context, constraints) {
    // constraints.maxWidth is the space available to THIS widget
    if (constraints.maxWidth < 300) {
      return CompactView();
    }
  },
)
```

**Key Differences:**

1. **Context:**
   - MediaQuery: Global device context
   - LayoutBuilder: Local widget context

2. **Value:**
   - MediaQuery: Entire screen dimensions
   - LayoutBuilder: Space allocated to that specific widget

3. **Use Case Example:**
   In our responsive dashboard, we use:
   - **MediaQuery** to determine if we should show navigation rail vs bottom bar (device-level decision)
   - **LayoutBuilder** to determine grid column count within the content area (widget-level decision)

4. **Performance:**
   - MediaQuery: Rebuilds when device characteristics change (rotation, etc.)
   - LayoutBuilder: Rebuilds when parent's constraints change

**When to use which:**
- Use **MediaQuery** when making app-wide decisions (navigation pattern, overall layout strategy)
- Use **LayoutBuilder** when a widget needs to adapt to its available space (grid columns, card layouts)
- Use **both together** for maximum flexibility (as we do in our implementation)

**Example from our code:**
```dart
// We use MediaQuery for device-level decisions
final screenWidth = MediaQuery.of(context).size.width;
final isLargeScreen = screenWidth >= 600;

return LayoutBuilder(
  builder: (context, constraints) {
    // And LayoutBuilder for component-level decisions
    int columns = constraints.maxWidth < 600 ? 2 : 3;
    return GridView.count(crossAxisCount: columns);
  },
);
```

### How could your team use these tools to scale the app design efficiently?

Our team can leverage MediaQuery and LayoutBuilder to scale the OpenShelf app efficiently across multiple dimensions:

**1. Reusable Responsive Components:**
Create a library of responsive widgets that automatically adapt:
```dart
// lib/widgets/responsive_card.dart
class ResponsiveCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Automatically adapts to available space
        final compact = constraints.maxWidth < 300;
        return Card(
          child: compact ? CompactLayout() : ExpandedLayout(),
        );
      },
    );
  }
}
```

**2. Consistent Breakpoint System:**
Define standard breakpoints in a constants file:
```dart
// lib/constants/breakpoints.dart
class Breakpoints {
  static const mobile = 600;
  static const tablet = 900;
  static const desktop = 1200;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;
}
```

**3. Responsive Design System:**
Create a design system with responsive values:
```dart
// lib/theme/spacing.dart
class AppSpacing {
  static double padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600 ? 16.0 : 24.0;
  }
  
  static double fontSize(BuildContext context, String style) {
    final width = MediaQuery.of(context).size.width;
    switch (style) {
      case 'headline':
        return width < 600 ? 24.0 : 32.0;
      case 'body':
        return width < 600 ? 14.0 : 16.0;
      default:
        return 14.0;
    }
  }
}
```

**4. Platform-Specific Optimizations:**
Use responsive design to deliver platform-specific experiences:
```dart
// Show different features based on available space
if (isLargeScreen) {
  // Show advanced features on tablet
  return DetailedBookView();
} else {
  // Simplified view on mobile
  return SimpleBookCard();
}
```

**5. Development Workflow:**

**a) Design Once, Deploy Everywhere:**
- Build components with LayoutBuilder/MediaQuery from the start
- Test on multiple screen sizes during development
- Use Flutter DevTools' device preview

**b) Team Collaboration:**
- Establish responsive design guidelines in team documentation
- Code review checklist includes responsive behavior
- Share reusable responsive components across team

**c) Testing Strategy:**
- Test each screen on minimum 2 device sizes (phone + tablet)
- Include responsive tests in our test suite
- Use automated screenshot testing for multiple screen sizes

**6. Efficient Scaling to New Features:**

When adding new features:
```dart
// New feature automatically responsive
class NewFeatureScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Reuse existing responsive patterns
        return constraints.maxWidth < Breakpoints.mobile
            ? MobileNewFeature()
            : TabletNewFeature();
      },
    );
  }
}
```

**7. Performance Optimization:**
- Load different image sizes based on screen density
- Adjust grid item counts to prevent rendering too many widgets
- Use lazy loading more aggressively on smaller screens

**8. Analytics and Iteration:**
```dart
// Track which layouts are most used
Analytics.log('layout_viewed', {
  'device_type': isLargeScreen ? 'tablet' : 'mobile',
  'screen_width': screenWidth,
  'orientation': orientation,
});
```

This data helps us optimize for our actual user base.

**9. Maintenance Benefits:**
- Single codebase for all screen sizes (no separate phone/tablet apps)
- Bug fixes apply to all layouts automatically
- Feature updates reach all users simultaneously
- Reduced testing overhead (test responsive behavior once)

By implementing these responsive design practices systematically, Team Nova can efficiently scale the OpenShelf app to support any screen size while maintaining code quality and development velocity.

---

## 🚀 Running the Demo

### Step 1: Get Dependencies
```bash
cd openshelf_app
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Navigate to Demo Screens

**Option 1: Direct Navigation**
Add temporary navigation buttons or manually navigate to:
- `/responsive-design-demo` - Educational demo
- `/responsive-dashboard` - Real-world dashboard

**Option 2: Add to Demo Hub**
(If you have a demo hub screen)

### Step 4: Test Different Screen Sizes
- Press `R` to hot reload
- Change device emulator
- Rotate device to test landscape/portrait

---

## ✅ Implementation Checklist

- [x] MediaQuery implementation for device info
- [x] LayoutBuilder for conditional layouts
- [x] Responsive containers (percentage-based)
- [x] Adaptive navigation (bottom bar vs side rail)
- [x] Responsive grid with dynamic columns
- [x] Adaptive typography
- [x] Breakpoint system (600px, 900px)
- [x] Mobile layout (Column, 2 columns)
- [x] Tablet layout (Row, 3-4 columns)
- [x] Orientation handling
- [x] Context-aware spacing
- [x] Real-world dashboard example
- [x] Comprehensive documentation
- [x] Code comments and examples

---

## 📚 Additional Resources

- [MediaQuery Class - Flutter Docs](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
- [LayoutBuilder - Flutter Docs](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
- [Creating Responsive Apps - Flutter](https://docs.flutter.dev/ui/layout/responsive/adaptive-responsive)
- [Material Design Responsive Layout Grid](https://material.io/design/layout/responsive-layout-grid.html)

---

## 🏆 Key Achievements

✅ **2 Comprehensive Screens** demonstrating responsive design
✅ **MediaQuery** for device-level information and adaptive sizing
✅ **LayoutBuilder** for constraint-based conditional layouts
✅ **Breakpoint System** for consistent responsive behavior
✅ **Adaptive Navigation** (bottom bar vs navigation rail)
✅ **Responsive Grids** with dynamic column counts
✅ **Context-Aware Typography** and spacing
✅ **Real-World Implementation** in dashboard
✅ **Educational Demo** showcasing all concepts
✅ **Production-Ready Code** with comprehensive documentation

---

**Team Nova** | Building Smart Mobile Experiences with Flutter & Firebase
**Sprint #2** | Responsive Design with MediaQuery and LayoutBuilder
