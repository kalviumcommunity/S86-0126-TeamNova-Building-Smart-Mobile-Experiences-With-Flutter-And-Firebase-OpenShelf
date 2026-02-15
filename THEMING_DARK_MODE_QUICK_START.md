# Quick Start: Dark Mode & Theming

Get theming working in your OpenShelf app in under 5 minutes!

## 🚀 Installation

### 1. Install Dependencies

```bash
flutter pub get
```

The following dependencies are already added:

- `provider: ^6.1.1`
- `shared_preferences: ^2.2.2`

## ⚡ Test It Right Now

### Option 1: Use the Demo Screen

```dart
// Navigate to the theming demo
Navigator.pushNamed(context, '/theming-demo');
```

### Option 2: Add Quick Toggle Anywhere

```dart
import 'package:provider/provider.dart';
import 'package:openshelf_app/providers/theme_provider.dart';

// In any widget:
Switch(
  value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
  onChanged: (isDark) {
    Provider.of<ThemeProvider>(context, listen: false)
        .toggleTheme(isDark);
  },
)
```

## 📱 See It in Action

### 1. Run the app

```bash
flutter run
```

### 2. Navigate to Theme Demo

- Open the demo hub
- Select "Dark Mode & Theming"
- Try different theme modes!

### 3. Test Persistence

- Change the theme
- Close and reopen the app
- Theme preference is saved! ✨

## 🎨 Common Use Cases

### Add Theme Toggle to AppBar

```dart
AppBar(
  title: const Text('My Screen'),
  actions: [
    Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode(context);
        return IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeProvider.toggleTheme(!isDark),
        );
      },
    ),
  ],
)
```

### Add Theme Selector to Settings

```dart
ListTile(
  leading: const Icon(Icons.palette),
  title: const Text('Theme'),
  subtitle: Text(context.watch<ThemeProvider>().currentThemeName),
  onTap: () => Navigator.pushNamed(context, '/theming-demo'),
)
```

### Check Current Theme

```dart
final themeProvider = Provider.of<ThemeProvider>(context);
final bool isDark = themeProvider.isDarkMode(context);

if (isDark) {
  // Show dark mode specific content
} else {
  // Show light mode specific content
}
```

## 🎯 Quick Customization

### Change App Colors

Edit `lib/theme/app_theme_light.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // Your brand color here!
  brightness: Brightness.light,
)
```

Edit `lib/theme/app_theme_dark.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // Match your brand
  brightness: Brightness.dark,
)
```

### Use Theme Colors

```dart
// ✅ DO THIS
Container(
  color: Theme.of(context).colorScheme.primary,
)

// ❌ DON'T DO THIS
Container(
  color: Colors.blue, // Hardcoded!
)
```

## 🐛 Troubleshooting

### Theme not changing?

Make sure you're using `Provider.of()` or `context.watch()`:

```dart
// ✅ Correct
Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return Text('Theme: ${themeProvider.currentThemeName}');
  },
)

// ❌ Wrong - won't react to changes
final themeProvider = ThemeProvider();
```

### Theme not persisting?

Check that SharedPreferences is working:

```dart
// The provider handles this automatically
// Just make sure you're using the Provider's methods:
await context.read<ThemeProvider>().useDarkTheme();
```

## 📖 Learn More

- Full documentation: [THEMING_DARK_MODE_README.md](THEMING_DARK_MODE_README.md)
- Learning guide: See the complete lesson in the user's request
- Flutter docs: https://docs.flutter.dev/ui/themes

## ✅ What You Get

✨ **Out of the Box:**

- Light theme
- Dark theme (OLED optimized)
- System theme (follows device)
- Persistent preferences
- Interactive demo screen
- Complete Material 3 support

## 🎉 You're Ready!

The theming system is fully configured and ready to use. Just run the app and navigate to `/theming-demo` to see it in action!

```bash
flutter run
# Then navigate to the theming demo screen
```

**Happy Theming! 🎨**
