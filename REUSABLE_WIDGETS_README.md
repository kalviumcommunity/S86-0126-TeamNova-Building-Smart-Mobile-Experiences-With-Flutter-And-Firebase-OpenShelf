# Reusable Custom Widgets for Modular UI Design

## 📚 OpenShelf - Team Nova

This document demonstrates the implementation of reusable custom widgets in the OpenShelf Flutter application, showcasing how modular UI components improve code maintainability, consistency, and development efficiency.

---

## 🎯 Overview

In this implementation, we've created **5 custom reusable widgets** that are used multiple times across different screens in our app. These widgets follow the DRY (Don't Repeat Yourself) principle and demonstrate best practices in Flutter widget composition.

### Custom Widgets Created

1. **CustomButton** - Versatile button with icon support
2. **InfoCard** - Information display card with gradient options
3. **BookCard** - Stateful card for displaying book information with favorite functionality
4. **FeatureTile** - Compact tile for features/options with badge support
5. **StatsCard** - Statistical information display with trend indicators

---

## 📂 Project Structure

```
lib/
├── widgets/                          # Custom reusable widgets
│   ├── custom_button.dart           # Reusable button widget
│   ├── info_card.dart               # Information card widget
│   ├── book_card.dart               # Book display card (stateful)
│   ├── feature_tile.dart            # Feature/option tile
│   └── stats_card.dart              # Statistics display card
├── screens/
│   ├── reusable_widgets_demo.dart   # Demo showcasing all widgets
│   └── library_screen.dart          # Library screen using widgets
└── main.dart                         # App entry point with routes
```

---

## 🛠️ Custom Widgets Implementation

### 1. CustomButton Widget

A versatile button that can be customized with different colors, icons, and styles (filled or outlined).

**File:** `lib/widgets/custom_button.dart`

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.teal,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

**Usage Examples:**

```dart
// Example 1: Filled button with icon
CustomButton(
  label: 'Add to Library',
  icon: Icons.add,
  color: Colors.teal,
  onPressed: () {
    // Add action
  },
),

// Example 2: Outlined button
CustomButton(
  label: 'Delete',
  icon: Icons.delete_outline,
  color: Colors.red,
  isOutlined: true,
  onPressed: () {
    // Delete action
  },
),
```

---

### 2. InfoCard Widget

A card widget for displaying information with an icon, title, subtitle, and optional gradient background.

**File:** `lib/widgets/info_card.dart`

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;
  final bool useGradient;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.cardColor,
    this.onTap,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: useGradient
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor?.withOpacity(0.7) ?? Colors.teal.withOpacity(0.7),
                    cardColor ?? Colors.teal,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : BoxDecoration(
                color: cardColor ?? Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: useGradient
                  ? Colors.white.withOpacity(0.3)
                  : (iconColor ?? Colors.teal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: useGradient ? Colors.white : (iconColor ?? Colors.teal),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: useGradient ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: useGradient
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black54,
              ),
            ),
          ),
          trailing: onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: useGradient ? Colors.white : Colors.grey,
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
```

**Usage Examples:**

```dart
// Example 1: Basic info card
InfoCard(
  title: 'My Profile',
  subtitle: 'View and edit your account details',
  icon: Icons.person,
  iconColor: Colors.teal,
  onTap: () {
    Navigator.pushNamed(context, '/profile');
  },
),

// Example 2: Gradient info card
InfoCard(
  title: 'Achievements',
  subtitle: 'Unlock badges and rewards',
  icon: Icons.emoji_events,
  useGradient: true,
  cardColor: Colors.purple,
  onTap: () {
    // Navigate to achievements
  },
),
```

---

### 3. BookCard Widget (Stateful)

A stateful card specifically designed for displaying book information with a favorite toggle button.

**File:** `lib/widgets/book_card.dart`

```dart
class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final double rating;
  final String? coverUrl;
  final VoidCallback? onTap;
  final bool initialFavorite;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.rating = 0.0,
    this.coverUrl,
    this.onTap,
    this.initialFavorite = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.title} added to favorites!'
              : '${widget.title} removed from favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.book, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${widget.author}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Usage Example:**

```dart
BookCard(
  title: 'The Great Gatsby',
  author: 'F. Scott Fitzgerald',
  rating: 4.5,
  initialFavorite: true,
  onTap: () {
    // Navigate to book details
  },
),
```

---

### 4. FeatureTile Widget

A compact tile for displaying features or navigation options with optional badge indicators.

**File:** `lib/widgets/feature_tile.dart`

```dart
class FeatureTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final int? badgeCount;

  const FeatureTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.badgeCount,
  });

  // ... (full implementation in the file)
}
```

**Usage Example:**

```dart
FeatureTile(
  title: 'Notifications',
  subtitle: 'Manage your alerts',
  icon: Icons.notifications,
  iconColor: Colors.blue,
  badgeCount: 5,
  onTap: () {
    // Navigate to notifications
  },
),
```

---

### 5. StatsCard Widget

A widget for displaying statistical information with optional trend indicators.

**File:** `lib/widgets/stats_card.dart`

```dart
class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isTrendPositive;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = Colors.teal,
    this.trend,
    this.isTrendPositive = true,
  });

  // ... (full implementation in the file)
}
```

**Usage Example:**

```dart
StatsCard(
  label: 'Books Read',
  value: '24',
  icon: Icons.book,
  color: Colors.teal,
  trend: '+12%',
  isTrendPositive: true,
),
```

---

## 🎨 Widget Reusability Demonstration

### Demo Screen: `reusable_widgets_demo.dart`

This screen showcases all custom widgets in one place:

- **3 instances** of CustomButton (different colors and styles)
- **3 instances** of InfoCard (with and without gradients)
- **3 instances** of BookCard (different books)
- **3 instances** of FeatureTile (with badge counts)
- **4 instances** of StatsCard (different statistics)

**Total widget reuses:** 16 custom widget instances

### Library Screen: `library_screen.dart`

A practical implementation showing real-world usage:

- **4 instances** of StatsCard (reading statistics)
- **6 instances** of BookCard (currently reading + recommended)
- **3 instances** of FeatureTile (quick actions)
- **2 instances** of CustomButton (action buttons)

**Total widget reuses:** 15 custom widget instances

---

## 📊 Benefits of Reusable Widgets

### 1. **Code Reduction**

- Before: ~200 lines per screen with repeated code
- After: ~50 lines per widget + minimal usage code
- **Savings:** ~75% code reduction for repeated UI elements

### 2. **Consistency**

- All buttons have the same styling and behavior
- All cards follow the same design language
- Easy to maintain design system

### 3. **Maintainability**

- Update one widget file affects all instances
- Centralized styling and behavior
- Easier debugging and testing

### 4. **Development Speed**

- Faster implementation of new screens
- Reduced time for UI development
- Focus on functionality rather than styling

### 5. **Team Collaboration**

- Clear component library for team members
- Standardized widgets across the project
- Better code reviews and quality

---

## 🚀 How to Use These Widgets

### Step 1: Import the Widget

```dart
import '../widgets/custom_button.dart';
```

### Step 2: Use the Widget

```dart
CustomButton(
  label: 'Click Me',
  icon: Icons.touch_app,
  color: Colors.blue,
  onPressed: () {
    print('Button pressed!');
  },
),
```

### Step 3: Customize Properties

```dart
CustomButton(
  label: 'Outlined Style',
  icon: Icons.info,
  color: Colors.red,
  isOutlined: true,  // Different style
  onPressed: () {
    // Action
  },
),
```

---

## 📱 Screenshots

### Reusable Widgets Demo Screen

![Demo Screen showing all custom widgets](screenshots/reusable_widgets_demo.png)

### Library Screen

![Library screen using custom widgets multiple times](screenshots/library_screen.png)

### Custom Button Variations

![Different button styles and colors](screenshots/custom_buttons.png)

### Book Cards

![Book cards with favorite functionality](screenshots/book_cards.png)

---

## 🎯 Reflection

### How do reusable widgets improve development efficiency?

Reusable widgets significantly improve development efficiency in several ways:

1. **Time Savings:** Instead of writing the same UI code multiple times, we create it once and reuse it everywhere. In our implementation, the BookCard widget is used 6 times in the library screen alone, saving us from writing ~600 lines of duplicate code.

2. **Consistency:** All instances of a widget look and behave identically, ensuring a consistent user experience throughout the app. When we update the CustomButton widget, all 5 instances across different screens automatically reflect the change.

3. **Easier Testing:** We only need to test each widget once, and we can be confident that it works correctly everywhere it's used.

4. **Better Collaboration:** Team members can quickly understand and use existing widgets without needing to reinvent UI components.

### What challenges did you face while designing modular components?

1. **Balancing Flexibility and Simplicity:**
   - Challenge: Making widgets flexible enough to handle different use cases while keeping them simple to use.
   - Solution: Used optional parameters with sensible defaults (e.g., `color = Colors.teal`, `isOutlined = false`).

2. **Determining the Right Abstraction Level:**
   - Challenge: Deciding what should be a separate widget vs. what should be configuration.
   - Solution: Created widgets when the pattern appeared 3+ times and had similar structure.

3. **Managing State:**
   - Challenge: Deciding between StatelessWidget and StatefulWidget.
   - Solution: Used StatefulWidget only when necessary (e.g., BookCard with favorite toggle), keeping most widgets stateless for simplicity.

4. **Naming Conventions:**
   - Challenge: Choosing clear, descriptive names that convey purpose.
   - Solution: Used descriptive names like `InfoCard`, `BookCard`, `FeatureTile` that immediately communicate their purpose.

### How could your team apply this approach to your full project?

1. **Create a Widget Library:**
   - Build a comprehensive collection of reusable widgets in a `widgets/` folder
   - Document each widget with usage examples
   - Create a design system guide

2. **Establish Standards:**
   - Define naming conventions for widgets
   - Set guidelines for when to create a new widget
   - Document best practices for widget composition

3. **Component-Driven Development:**
   - Start new features by identifying reusable components
   - Build complex screens by composing smaller widgets
   - Maintain a widget showcase/demo screen

4. **Continuous Refactoring:**
   - Identify repeated patterns and extract them into widgets
   - Regularly review and improve existing widgets
   - Remove unused or redundant widgets

5. **Team Training:**
   - Conduct sessions on using existing widgets
   - Encourage contributions to the widget library
   - Share examples of good widget composition

---

## 🏆 Key Takeaways

1. ✅ **Created 5 custom widgets** used 31+ times across 2 screens
2. ✅ **Reduced code duplication** by approximately 75%
3. ✅ **Improved maintainability** with centralized widget definitions
4. ✅ **Enhanced consistency** across the application
5. ✅ **Demonstrated both stateless and stateful** custom widgets
6. ✅ **Applied DRY principles** effectively

---

## 📝 Running the Demo

1. Navigate to the app:

   ```bash
   cd openshelf_app
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

4. Navigate to:
   - `/reusable-widgets-demo` - See all widgets showcased
   - `/library` - See real-world usage in library screen

---

## 📚 Additional Resources

- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Creating Custom Widgets](https://docs.flutter.dev/cookbook/design/custom-widget)
- [StatelessWidget vs StatefulWidget](https://docs.flutter.dev/ui/interactivity)

---

**Team Nova** | Sprint #2: Building Smart Mobile Experiences
