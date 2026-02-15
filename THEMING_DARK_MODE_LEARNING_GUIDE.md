# Creating Themed UIs Using Dark Mode and Dynamic Colors

## 📚 Learning Guide for OpenShelf Implementation

Modern mobile apps are expected to support dark mode, dynamic color schemes, and visually adaptive themes. Whether it's saving battery on OLED screens or providing better accessibility in low-light environments, theming significantly improves user experience. Flutter's flexible theming system allows you to define color schemes, typography, and widget styles globally — and even switch themes dynamically at runtime using Provider.

In this lesson, you'll learn how to enable dark mode, create custom light/dark themes, toggle themes inside the app, and persist the selected theme so the UI remembers the user's preference.

---

## 1. Why Theming Matters

✅ Enhances user experience and accessibility  
✅ Reduces eye strain and battery consumption  
✅ Ensures consistent brand identity across your UI  
✅ Allows user preference (light/dark/system) toggles  
✅ Helps apps feel polished and production-ready

### Real-World Impact
- **Battery Savings**: Up to 60% power reduction on OLED screens in dark mode
- **Eye Strain**: Reduces blue light exposure in low-light environments
- **User Satisfaction**: 70% of users prefer dark mode in evening hours
- **Accessibility**: Better for users with light sensitivity

---

## 2. Setting Up Basic Theming in Flutter

Flutter apps define themes inside `MaterialApp`.

```dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
  home: const HomeScreen(),
);
```

### ThemeMode Options

| Mode | Description | Use Case |
|------|-------------|----------|
| `ThemeMode.system` | Follows device settings | Default (respects user's OS preference) |
| `ThemeMode.light` | Force light mode | Always use light theme |
| `ThemeMode.dark` | Force dark mode | Always use dark theme |

**In OpenShelf**: See [main.dart](openshelf_app/lib/main.dart#L60-L67)

---

## 3. Creating Custom Light & Dark Themes

### Light Theme Example

```dart
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);
```

**In OpenShelf**: See [app_theme_light.dart](openshelf_app/lib/theme/app_theme_light.dart)

Our implementation includes:
- Material 3 color scheme
- Custom AppBar styling
- Card theme with rounded corners
- Button themes (Elevated, Text, Outlined)
- Input field decorations
- Icon themes
- Bottom navigation styling

### Dark Theme Example

```dart
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.tealAccent,
  ),
);
```

**In OpenShelf**: See [app_theme_dark.dart](openshelf_app/lib/theme/app_theme_dark.dart)

Our implementation features:
- **True OLED Black** (#121212) for battery savings
- Deep Purple Accent for primary color
- Optimized contrast ratios
- Reduced brightness for eye comfort
- Material 3 dark mode guidelines

### 🎨 Design Tip
Use `ColorScheme.fromSeed()` for Material 3 dynamic colors:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  brightness: Brightness.light,
)
```

---

## 4. Dynamic Theme Switching (Using Provider)

### State Class Example (Provider)

```dart
class ThemeState with ChangeNotifier {
  ThemeMode mode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
```

**In OpenShelf**: See [theme_provider.dart](openshelf_app/lib/providers/theme_provider.dart)

Our `ThemeProvider` includes:
- Three theme modes (Light, Dark, System)
- Persistent storage with SharedPreferences
- Helper methods for each mode
- Error handling
- Initialization state tracking

### Applying It in MaterialApp

```dart
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: context.watch<ThemeProvider>().mode,
);
```

**In OpenShelf**: See [main.dart](openshelf_app/lib/main.dart#L42-L51)

### 🔧 How It Works

1. **Provider Setup**: `ChangeNotifierProvider` wraps `MaterialApp`
2. **Consumer Widget**: Listens to theme changes
3. **Rebuild Trigger**: `notifyListeners()` rebuilds MaterialApp
4. **Theme Application**: Flutter automatically applies new theme

---

## 5. Theme Toggle UI

### Simple Toggle Switch

```dart
Switch(
  value: context.watch<ThemeState>().mode == ThemeMode.dark,
  onChanged: (value) {
    context.read<ThemeState>().toggleTheme(value);
  },
);
```

**In OpenShelf**: See [theming_demo_screen.dart](openshelf_app/lib/screens/theming_demo_screen.dart#L132-L147)

### Advanced Theme Selector

Our demo screen includes:
- **Radio Button Selector**: Choose between Light/Dark/System
- **Quick Toggle**: Switch between Light and Dark instantly
- **Visual Preview**: See colors before switching
- **Benefits Display**: Learn about current theme advantages

**Try it**: Navigate to `/theming-demo` in the app

---

## 6. Persisting Theme Selection

Using **SharedPreferences**:

### Saving Theme

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool("isDark", value);
```

### Loading Saved Theme

```dart
final isDark = prefs.getBool("isDark") ?? false;
themeState.toggleTheme(isDark);
```

**In OpenShelf**: Our `ThemeProvider` handles this automatically!

```dart
// Save (automatic when you change theme)
await themeProvider.useDarkTheme();

// Load (automatic on app start)
ThemeProvider(); // Constructor loads saved preference
```

### 💾 Persistence Details

- **Storage Key**: `theme_mode`
- **Storage Type**: Integer (ThemeMode.index)
- **Default**: System theme if no preference saved
- **Timing**: Loads before app renders

---

## 7. Dynamic Colors (Material You – Android 12+)

Flutter supports Material 3 dynamic colors:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
);
```

**In OpenShelf**: We use `useMaterial3: true` throughout

Dynamic color adapts to:
- User wallpaper
- Device system palette
- Material You design principles

### 📱 Future Enhancement

Add the `dynamic_color` package for full Material You support:

```yaml
dependencies:
  dynamic_color: ^1.6.6
```

```dart
import 'package:dynamic_color/dynamic_color.dart';

DynamicColorBuilder(
  builder: (lightDynamic, darkDynamic) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  },
);
```

---

## 8. Common Issues & Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| Theme doesn't update | Missing `notifyListeners()` or Provider rebuild | Use `watch()`, ensure provider wraps MaterialApp |
| UI flickers on toggle | Heavy rebuilds | Move theme state to root, avoid rebuilding whole app |
| Dark theme looks inconsistent | Some widgets have fixed colors | Use theme-based colors instead of hard-coded |
| Persistence fails | Wrong SharedPreferences usage | Ensure async init before runApp |

### 🐛 Debugging Tips

**Check Provider Setup**:
```dart
// ✅ Correct
ChangeNotifierProvider(
  create: (_) => ThemeProvider(),
  child: MaterialApp(...),
)

// ❌ Wrong
MaterialApp(
  child: ChangeNotifierProvider(...), // Too late!
)
```

**Use Correct Listeners**:
```dart
// ✅ For reading and listening
context.watch<ThemeProvider>()

// ✅ For reading only (no rebuild)
context.read<ThemeProvider>()

// ❌ Don't use
Provider.of<ThemeProvider>(context, listen: false) // Use context.read()
```

---

## 9. Best Practices

✅ **Never hardcode colors** inside widgets — use `Theme.of(context)` or `colorScheme`

```dart
// ✅ Good
Container(color: Theme.of(context).colorScheme.primary)

// ❌ Bad
Container(color: Colors.blue)
```

✅ **Use Material 3** (`useMaterial3: true`) for modern design

✅ **Provide clear toggle UI** in settings

✅ **Keep separate theme files** (`theme_light.dart`, `theme_dark.dart`) for clean architecture

✅ **Handle system theme changes** gracefully

✅ **Test on real devices** (OLED vs LCD screens show different results)

✅ **Consider accessibility** (contrast ratios, font sizes)

### 🏗️ Architecture Best Practices

```
lib/
├── theme/
│   ├── app_theme_light.dart  ✅ Light theme config
│   └── app_theme_dark.dart   ✅ Dark theme config
├── providers/
│   └── theme_provider.dart   ✅ Theme state management
└── main.dart                 ✅ App entry with theming
```

---

## 10. Additional Resources

### Official Documentation
- [Flutter Theming Docs](https://docs.flutter.dev/ui/themes) - Complete theming guide
- [Material 3 Guide](https://m3.material.io/) - Design system documentation
- [Dynamic Color Package](https://pub.dev/packages/dynamic_color) - Material You support
- [SharedPreferences](https://pub.dev/packages/shared_preferences) - Persistence solution
- [Provider Package](https://pub.dev/packages/provider) - State management

### OpenShelf Documentation
- [Complete README](THEMING_DARK_MODE_README.md) - Full implementation guide
- [Quick Start](THEMING_DARK_MODE_QUICK_START.md) - Get started in 5 minutes
- [PR Description](THEMING_DARK_MODE_PR_DESCRIPTION.md) - Technical details
- [Completion Summary](THEMING_DARK_MODE_COMPLETION_SUMMARY.md) - What was built

### Video Tutorials
- [Flutter Theming Tutorial](https://www.youtube.com/results?search_query=flutter+theming)
- [Dark Mode Implementation](https://www.youtube.com/results?search_query=flutter+dark+mode)
- [Provider State Management](https://www.youtube.com/results?search_query=flutter+provider)

---

## 🎯 Hands-On Exercise

### Try This Now!

1. **Run the app**:
   ```bash
   flutter run
   ```

2. **Navigate to the theme demo**:
   - Go to `/theming-demo` route
   - Or add to your navigation

3. **Experiment with themes**:
   - Toggle between Light and Dark
   - Try System mode
   - Close and reopen the app (persistence!)

4. **Customize colors**:
   - Edit `lib/theme/app_theme_light.dart`
   - Change the seed color
   - Hot reload and see changes!

5. **Add theme toggle to your screen**:
   ```dart
   Consumer<ThemeProvider>(
     builder: (context, themeProvider, _) {
       return Switch(
         value: themeProvider.themeMode == ThemeMode.dark,
         onChanged: (isDark) => themeProvider.toggleTheme(isDark),
       );
     },
   )
   ```

---

## ✅ Learning Checklist

After completing this lesson, you should be able to:

- [ ] Explain why theming matters for UX
- [ ] Set up basic themes in MaterialApp
- [ ] Create custom light and dark themes
- [ ] Implement theme switching with Provider
- [ ] Persist user theme preferences
- [ ] Use Material 3 dynamic colors
- [ ] Debug common theming issues
- [ ] Follow theming best practices
- [ ] Build a theme toggle UI
- [ ] Test themes on different devices

---

## 🎓 Quiz Questions

Test your understanding:

1. What are the three ThemeMode options in Flutter?
2. Why should you avoid hardcoded colors?
3. How does Provider help with theme management?
4. What is the benefit of OLED black in dark mode?
5. How do you persist theme preferences?

**Answers**: See [THEMING_DARK_MODE_README.md](THEMING_DARK_MODE_README.md)

---

## 🚀 Next Steps

### Beginner
- Implement basic theme toggle
- Customize brand colors
- Add theme to settings screen

### Intermediate
- Add multiple color schemes
- Implement theme animations
- Create custom component themes

### Advanced
- Material You dynamic colors
- Theme export/import
- Custom theme builder UI
- A/B testing different themes

---

## 💬 Reflection Questions

1. How does dark mode improve accessibility?
2. When would you use System theme vs manual selection?
3. What are the trade-offs of OLED black backgrounds?
4. How can theming improve your app's brand identity?

---

**Congratulations!** 🎉

You've learned how to create professional, adaptive themes in Flutter. Your apps can now provide an excellent user experience in any lighting condition!

**Keep Building! 🚀**
