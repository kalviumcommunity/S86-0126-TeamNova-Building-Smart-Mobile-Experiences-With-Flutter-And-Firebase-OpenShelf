# Reusable Widgets - Quick Reference

## 🚀 Quick Start

### Running the Demo

```bash
cd openshelf_app
flutter pub get
flutter run
```

### Navigate to Demo Screens

```dart
// In your app
Navigator.pushNamed(context, '/reusable-widgets-demo');
Navigator.pushNamed(context, '/library');
```

---

## 📦 Widget Import Guide

### Import a Widget

```dart
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/book_card.dart';
import '../widgets/feature_tile.dart';
import '../widgets/stats_card.dart';
```

---

## 🎨 Widget Quick Examples

### CustomButton

```dart
// Filled button
CustomButton(
  label: 'Click Me',
  icon: Icons.add,
  color: Colors.teal,
  onPressed: () {},
)

// Outlined button
CustomButton(
  label: 'Delete',
  icon: Icons.delete,
  color: Colors.red,
  isOutlined: true,
  onPressed: () {},
)
```

### InfoCard

```dart
// Basic card
InfoCard(
  title: 'Profile',
  subtitle: 'View details',
  icon: Icons.person,
  iconColor: Colors.teal,
  onTap: () {},
)

// Gradient card
InfoCard(
  title: 'Premium',
  subtitle: 'Upgrade now',
  icon: Icons.star,
  useGradient: true,
  cardColor: Colors.purple,
  onTap: () {},
)
```

### BookCard (Stateful)

```dart
BookCard(
  title: 'The Great Gatsby',
  author: 'F. Scott Fitzgerald',
  rating: 4.5,
  initialFavorite: true,
  onTap: () {},
)
```

### FeatureTile

```dart
FeatureTile(
  title: 'Notifications',
  subtitle: 'Manage alerts',
  icon: Icons.notifications,
  iconColor: Colors.blue,
  badgeCount: 5,
  onTap: () {},
)
```

### StatsCard

```dart
StatsCard(
  label: 'Books Read',
  value: '24',
  icon: Icons.book,
  color: Colors.teal,
  trend: '+12%',
  isTrendPositive: true,
)
```

---

## 📱 Routes

| Route                    | Screen              | Purpose                   |
| ------------------------ | ------------------- | ------------------------- |
| `/reusable-widgets-demo` | ReusableWidgetsDemo | Showcase all widgets      |
| `/library`               | LibraryScreen       | Real-world implementation |

---

## 🎯 Common Use Cases

### Navigation Button

```dart
CustomButton(
  label: 'Go to Profile',
  icon: Icons.person,
  onPressed: () => Navigator.pushNamed(context, '/profile'),
)
```

### List of Books

```dart
ListView(
  children: [
    BookCard(title: 'Book 1', author: 'Author 1', rating: 4.5),
    BookCard(title: 'Book 2', author: 'Author 2', rating: 4.0),
    BookCard(title: 'Book 3', author: 'Author 3', rating: 4.8),
  ],
)
```

### Stats Dashboard

```dart
Row(
  children: [
    Expanded(child: StatsCard(label: 'Total', value: '100', icon: Icons.book)),
    Expanded(child: StatsCard(label: 'Read', value: '50', icon: Icons.check)),
  ],
)
```

---

## 🛠️ Customization Tips

### Colors

- Use consistent color scheme
- Pass colors as parameters
- Examples: `Colors.teal`, `Colors.blue[600]`

### Icons

- Material Icons: `Icons.add`, `Icons.person`
- Size controlled by widget
- Color controlled by parameters

### Spacing

- Use `SizedBox(height: 12)` between widgets
- Cards have built-in margins
- Consistent padding throughout

---

## ✅ Best Practices

1. **Always use const** when possible

   ```dart
   const CustomButton(label: 'Click', onPressed: myFunction)
   ```

2. **Provide defaults** for optional parameters

   ```dart
   this.color = Colors.teal,
   this.isOutlined = false,
   ```

3. **Use descriptive names** for widgets

   ```dart
   BookCard  // ✅ Clear purpose
   Card1     // ❌ Unclear
   ```

4. **Document your widgets**
   ```dart
   /// A reusable button with icon support
   class CustomButton extends StatelessWidget {
     // ...
   }
   ```

---

## 🐛 Troubleshooting

### Widget not found

```
Error: Cannot find widget
Solution: Check import path '../widgets/custom_button.dart'
```

### Required parameter missing

```
Error: The parameter 'label' is required
Solution: Add all required parameters
```

### Route not found

```
Error: Could not find route
Solution: Add route to main.dart routes
```

---

## 📚 File Locations

```
lib/
├── widgets/
│   ├── custom_button.dart      # Reusable button
│   ├── info_card.dart          # Info display card
│   ├── book_card.dart          # Book card (stateful)
│   ├── feature_tile.dart       # Feature tile
│   └── stats_card.dart         # Stats display
├── screens/
│   ├── reusable_widgets_demo.dart  # Widget showcase
│   └── library_screen.dart         # Real usage example
└── main.dart                   # Routes defined here
```

---

## 🎬 Video Demo Script

1. **Intro** (10s): "Demonstrating reusable widgets in OpenShelf"
2. **Demo Screen** (20s): Navigate and scroll through all widgets
3. **Library Screen** (20s): Show real-world usage
4. **Interaction** (15s): Tap book favorite, click buttons
5. **Conclusion** (15s): "5 widgets, 34+ uses, cleaner code"

---

## 📸 Screenshot Checklist

- [ ] Reusable widgets demo screen
- [ ] Library screen (full)
- [ ] Custom buttons (3 variations)
- [ ] Book cards (with favorites)
- [ ] Stats cards (grid)
- [ ] Info cards (gradient and regular)
- [ ] Feature tiles (with badges)

---

## 🚀 Submission Steps

1. Test all features
2. Capture screenshots
3. Record video demo (1-2 min)
4. Commit code with message:
   ```
   feat: created and reused custom widgets for modular UI design
   ```
5. Create PR titled: `[Sprint-2] Reusable Custom Widgets – Team Nova`
6. Add screenshots and video link to PR
7. Submit

---

## 🔗 Documentation Links

- Full README: `REUSABLE_WIDGETS_README.md`
- Implementation Summary: `REUSABLE_WIDGETS_IMPLEMENTATION_SUMMARY.md`
- Screenshot Guide: `openshelf_app/screenshots/REUSABLE_WIDGETS_SCREENSHOT_GUIDE.md`

---

**Team Nova** | Quick Reference for Reusable Widgets
