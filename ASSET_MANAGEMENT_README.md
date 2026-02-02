# 📦 Managing Images, Icons, and Local Assets in Flutter - OpenShelf

## 📋 Table of Contents

- [Overview](#overview)
- [Asset Setup](#asset-setup)
- [Implementation Details](#implementation-details)
- [Code Examples](#code-examples)
- [Screenshots](#screenshots)
- [Reflections](#reflections)
- [Testing Guide](#testing-guide)
- [Resources](#resources)

---

## 🎯 Overview

This implementation demonstrates comprehensive asset management in Flutter, including:

✅ **Local Image Management**: Loading and displaying PNG, JPG images  
✅ **Icon Libraries**: Using Material and Cupertino built-in icons  
✅ **Asset Registration**: Proper `pubspec.yaml` configuration  
✅ **Error Handling**: Graceful fallbacks for missing assets  
✅ **Mixed Media Layouts**: Combining images, icons, and text  
✅ **Background Images**: Using `DecorationImage` for backgrounds  
✅ **Platform-Specific Icons**: Material (Android) vs Cupertino (iOS)

---

## 🗂️ Asset Setup

### 1. Folder Structure

Created the following asset organization:

```
openshelf_app/
├── assets/
│   ├── images/               # Local images (PNG, JPG, SVG)
│   │   ├── logo.png          # App/team logo
│   │   ├── banner.jpg        # Banner image
│   │   └── background.png    # Background texture
│   │
│   ├── icons/                # Custom icon images
│   │   ├── star.png          # Star icon
│   │   └── profile.png       # Profile icon
│   │
│   └── ASSETS_README.md      # Asset management guide
│
└── pubspec.yaml              # Asset registration
```

### 2. pubspec.yaml Configuration

Registered asset directories in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/icon/ # Existing app icon
    - assets/images/ # ✅ NEW: Image assets
    - assets/icons/ # ✅ NEW: Icon assets
```

**Important Notes:**

- **Indentation**: Use exactly 2 spaces (YAML is space-sensitive)
- **Trailing Slash**: Include `/` to register entire directories
- **Refresh**: Run `flutter pub get` after modifying `pubspec.yaml`

### 3. File Requirements

**Recommended Image Specifications:**

| Asset            | Size        | Format            | Purpose       |
| ---------------- | ----------- | ----------------- | ------------- |
| `logo.png`       | 512×512px   | PNG (transparent) | App/team logo |
| `banner.jpg`     | 1200×400px  | JPG               | Banner image  |
| `background.png` | 1080×1920px | PNG/JPG           | Background    |
| `star.png`       | 128×128px   | PNG (transparent) | Custom icon   |
| `profile.png`    | 256×256px   | PNG (transparent) | Profile icon  |

---

## 💻 Implementation Details

### Screen: AssetDemoScreen

**File**: `lib/screens/asset_demo_screen.dart` (850+ lines)  
**Route**: `/asset-demo`

#### Key Features:

1. **Introduction Card**
   - Explains asset management concepts
   - Lists key learning objectives
   - Provides quick reference

2. **Image Asset Examples**
   - `Image.asset()` widget usage
   - Different `BoxFit` modes (contain, cover)
   - Error handling with `errorBuilder`
   - Placeholder for missing images

3. **Icon Library Showcase**
   - 12+ Material icons in grid layout
   - Color-coded examples
   - Icon variations (filled, outlined, rounded, sharp)

4. **Combined Layouts**
   - Profile card with image and icons
   - Statistics display with icon integration
   - Gradient backgrounds

5. **Background Images**
   - `DecorationImage` usage
   - Overlay gradients for text readability
   - Fallback colors for missing images

6. **Platform-Specific Icons**
   - Material icons (Android style)
   - Cupertino icons (iOS style)
   - Side-by-side comparison

---

## 📖 Code Examples

### 1. Loading Local Images

#### Basic Image Display

```dart
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
  fit: BoxFit.contain,
)
```

**Parameters:**

- `width`/`height`: Fixed dimensions
- `fit`: How to inscribe image (contain, cover, fill, fitWidth, fitHeight)

#### With Error Handling

```dart
Image.asset(
  'assets/images/banner.jpg',
  width: double.infinity,
  height: 150,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Image not found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  },
)
```

**Error Handling Benefits:**

- Prevents app crashes with missing images
- Provides user-friendly fallback UI
- Shows which assets need to be added

---

### 2. Using Built-in Icons

#### Material Icons

```dart
Icon(
  Icons.star,
  color: Colors.amber,
  size: 32,
)
```

**Common Material Icons:**

- `Icons.home` - Home icon
- `Icons.favorite` - Heart icon
- `Icons.star` - Star icon
- `Icons.person` - User icon
- `Icons.settings` - Settings gear
- `Icons.search` - Search magnifier

**Icon Variations:**

```dart
Icon(Icons.favorite)           // Filled
Icon(Icons.favorite_border)    // Outlined
Icon(Icons.favorite_rounded)   // Rounded corners
Icon(Icons.favorite_sharp)     // Sharp edges
```

#### Cupertino Icons (iOS Style)

```dart
import 'package:flutter/cupertino.dart';

Icon(
  CupertinoIcons.heart,
  color: Colors.red,
  size: 28,
)
```

**Common Cupertino Icons:**

- `CupertinoIcons.home`
- `CupertinoIcons.search`
- `CupertinoIcons.person`
- `CupertinoIcons.settings`

---

### 3. Background Images

#### Using DecorationImage

```dart
Container(
  height: 200,
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Center(
    child: Text(
      'Welcome to OpenShelf!',
      style: TextStyle(color: Colors.white, fontSize: 24),
    ),
  ),
)
```

#### With Gradient Overlay

```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.3),
          Colors.black.withOpacity(0.7),
        ],
      ),
    ),
    child: /* Your content */,
  ),
)
```

**Use Case**: Ensures text readability over images

---

### 4. Combining Images and Icons

#### Profile Card Example

```dart
Column(
  children: [
    // Profile Image
    Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/icons/profile.png',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 50, color: Colors.grey);
          },
        ),
      ),
    ),

    SizedBox(height: 16),

    // User Info
    Text('OpenShelf User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    Text('Flutter Developer', style: TextStyle(fontSize: 14, color: Colors.black54)),

    SizedBox(height: 16),

    // Stats with Icons
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Icon(Icons.book, size: 28, color: Colors.deepPurple),
            Text('24', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Books', style: TextStyle(fontSize: 11)),
          ],
        ),
        SizedBox(width: 24),
        Column(
          children: [
            Icon(Icons.favorite, size: 28, color: Colors.deepPurple),
            Text('12', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Favorites', style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    ),
  ],
)
```

---

## 📸 Screenshots

### Required Screenshots for Submission

1. **Asset Demo Screen - Full View**
   - Shows: All sections of AssetDemoScreen
   - Filename: `screenshots/assets/asset_demo_full.png`
   - Capture: Scroll through entire screen

2. **Image Assets Section**
   - Shows: Logo and banner display (or placeholders)
   - Filename: `screenshots/assets/image_assets.png`
   - Highlight: Image.asset() usage

3. **Icon Library Section**
   - Shows: Material icons grid
   - Filename: `screenshots/assets/icon_library.png`
   - Highlight: Various icon styles and colors

4. **Combined Layout**
   - Shows: Profile card with images and icons
   - Filename: `screenshots/assets/combined_layout.png`
   - Highlight: Integration of different asset types

5. **Background Image Section**
   - Shows: DecorationImage with overlay
   - Filename: `screenshots/assets/background_image.png`
   - Highlight: Text over image with gradient

6. **Platform Icons Comparison**
   - Shows: Material vs Cupertino icons
   - Filename: `screenshots/assets/platform_icons.png`
   - Highlight: Side-by-side comparison

7. **Project Folder Structure**
   - Shows: File explorer with assets/ folder
   - Filename: `screenshots/assets/folder_structure.png`
   - Highlight: Organization of images/ and icons/

8. **pubspec.yaml Configuration**
   - Shows: Asset registration section
   - Filename: `screenshots/assets/pubspec_config.png`
   - Highlight: flutter: assets: configuration

---

## 🤔 Reflections

### 1. What steps are necessary to load assets correctly in Flutter?

**Complete Asset Loading Process:**

**Step 1: Create Asset Folders**

- Create `assets/images/` and `assets/icons/` directories in project root
- Organize assets by type (images, icons, fonts, etc.)
- Use consistent naming conventions (lowercase, underscores)

**Step 2: Add Asset Files**

- Place image files in appropriate folders
- Ensure proper file formats (PNG for transparency, JPG for photos)
- Optimize images for mobile (compress, appropriate resolution)
- Recommended: Use 2x and 3x versions for different pixel densities

**Step 3: Register in pubspec.yaml**

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

- Maintain proper YAML indentation (2 spaces)
- Include trailing slashes for directories
- Can register individual files or entire folders

**Step 4: Run flutter pub get**

```bash
flutter pub get
```

- Refreshes project dependencies
- Indexes registered assets
- Validates pubspec.yaml syntax

**Step 5: Load Assets in Code**

```dart
Image.asset('assets/images/logo.png')
```

- Use exact path matching
- Paths are case-sensitive
- Include error handling for missing assets

**Step 6: Test and Verify**

- Hot restart (not just hot reload) after adding new assets
- Test on different devices and screen sizes
- Verify error handling works for missing files

**Common Pitfalls to Avoid:**

- ❌ Forgetting `flutter pub get` after modifying pubspec.yaml
- ❌ Incorrect YAML indentation (tabs vs spaces)
- ❌ Typos in file paths (case-sensitive)
- ❌ Using hot reload instead of hot restart for new assets
- ❌ Not handling missing assets with errorBuilder

---

### 2. What common errors did you face while configuring pubspec.yaml?

**Error 1: YAML Indentation Issues**

**Problem:**

```yaml
flutter:
assets: # ❌ Wrong indentation
  - assets/images/
```

**Solution:**

```yaml
flutter:
  assets: # ✅ Correct: 2 spaces
    - assets/images/ # ✅ Correct: 4 spaces (2 more)
```

**Lesson Learned:**

- YAML is space-sensitive (not tab-sensitive)
- Use exactly 2 spaces per indentation level
- Configure editor to show whitespace characters
- Use YAML linter/validator

---

**Error 2: Missing Trailing Slashes**

**Problem:**

```yaml
assets:
  - assets/images # ❌ Missing slash - registers only if 'images' is a file
```

**Solution:**

```yaml
assets:
  - assets/images/ # ✅ Correct - registers entire directory
```

**Lesson Learned:**

- Trailing `/` indicates directory (registers all files inside)
- Without `/`, Flutter looks for a file named "images"
- Be explicit: use `/` for folders, omit for specific files

---

**Error 3: Path Case Sensitivity**

**Problem:**

```yaml
assets:
  - assets/Images/ # ❌ 'Images' with capital I
```

**Code:**

```dart
Image.asset('assets/images/logo.png')  # ❌ Won't find it
```

**Solution:**

- Ensure path casing matches exactly between pubspec.yaml and code
- Recommended: Use lowercase for all folder/file names

**Lesson Learned:**

- Flutter asset paths are case-sensitive
- Maintain consistent naming conventions
- Use lowercase with underscores (snake_case)

---

**Error 4: Not Running flutter pub get**

**Problem:**

- Modified pubspec.yaml
- Ran app immediately
- Assets not found

**Solution:**

```bash
flutter pub get  # ✅ Always run after modifying pubspec.yaml
flutter clean    # ✅ If issues persist
flutter run
```

**Lesson Learned:**

- `pub get` is required to refresh asset index
- VS Code usually prompts automatically
- Make it a habit after any pubspec.yaml changes

---

**Error 5: Hot Reload vs Hot Restart**

**Problem:**

- Added new image to assets/
- Used hot reload (Ctrl+S or `r` in terminal)
- Image still showing as missing

**Solution:**

```bash
R  # Hot Restart (capital R in terminal)
# or Ctrl+Shift+F5 in VS Code
```

**Lesson Learned:**

- **Hot Reload**: Updates code changes only
- **Hot Restart**: Rebuilds entire app, including asset index
- New assets require hot restart
- Code changes to existing assets work with hot reload

---

**Error 6: Asset Not Found Despite Correct Configuration**

**Problem:**

```dart
Image.asset('assets/images/Logo.png')  // ❌ File is actually logo.png
```

**Solution:**

- Check exact filename (case-sensitive)
- Verify file actually exists in folder
- Use error handling to debug:

```dart
Image.asset(
  'assets/images/logo.png',
  errorBuilder: (context, error, stackTrace) {
    print('Asset loading error: $error');  // Debug in console
    return Text('Image not found: logo.png');
  },
)
```

**Lesson Learned:**

- Always implement `errorBuilder` during development
- Check console for asset loading errors
- Verify file paths in both File Explorer and code

---

### 3. How do proper asset management practices support scalability?

**1. Organized Folder Structure → Easy Collaboration**

**Our Structure:**

```
assets/
├── images/          # All app images
│   ├── logo.png
│   ├── banner.jpg
│   └── backgrounds/
│       └── gradient_bg.png
├── icons/           # Custom icons
│   ├── star.png
│   └── profile.png
└── fonts/           # Custom fonts (future)
    └── Roboto.ttf
```

**Benefits:**

- ✅ Team members know exactly where to add new assets
- ✅ Reduces duplicate assets (everyone looks in same place)
- ✅ Code reviews easier (expected folder structure)
- ✅ Onboarding new developers is faster
- ✅ Consistent naming = predictable paths in code

**Scalability Impact:**

- As team grows, organization prevents chaos
- Prevents "asset sprawl" (random locations)
- Makes refactoring safer (predictable paths)

---

**2. Proper Naming Conventions → Maintainable Code**

**Our Conventions:**

```
❌ Bad:
IMG_1234.jpg
Screenshot 2025.png
myicon.png

✅ Good:
book_cover_placeholder.jpg
user_profile_default.png
star_icon_filled.png
```

**Benefits:**

- ✅ Descriptive names = self-documenting code
- ✅ Easy to search/find specific assets
- ✅ Prevents accidental overwrites
- ✅ Version control diff is meaningful

**Scalability Impact:**

- 10 assets vs 1000 assets: naming matters
- Future developers understand asset purpose
- Easier to identify unused/duplicate assets
- Asset management tools can parse names

---

**3. Error Handling → Robust Production Apps**

**Implementation:**

```dart
Image.asset(
  'assets/images/user_avatar.png',
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.person, size: 50);  // Graceful fallback
  },
)
```

**Benefits:**

- ✅ App doesn't crash with missing assets
- ✅ Provides fallback UI (better UX)
- ✅ Easy to identify missing assets during testing
- ✅ Safe to deploy even if some assets aren't ready

**Scalability Impact:**

- Reduces production bugs
- Enables parallel development (backend team can work while designers finish assets)
- A/B testing with different assets becomes safer
- Easier to add/remove assets without app breaking

---

**4. Asset Optimization → Better Performance**

**Best Practices:**

```
✅ Compress images (TinyPNG, ImageOptim)
✅ Use appropriate formats:
   - PNG: Logos, icons (transparency needed)
   - JPG: Photos, banners (no transparency)
   - SVG: Scalable graphics (future consideration)

✅ Provide multiple resolutions:
   assets/images/
   ├── logo.png       (1x - 512px)
   ├── 2.0x/
   │   └── logo.png   (2x - 1024px)
   └── 3.0x/
       └── logo.png   (3x - 1536px)
```

**Benefits:**

- ✅ Smaller app size = faster downloads
- ✅ Better quality on high-DPI screens
- ✅ Faster load times = better UX
- ✅ Reduced bandwidth usage

**Scalability Impact:**

- App size stays manageable as asset count grows
- Supports wide range of devices (low-end to flagship)
- Better App Store optimization (smaller download = more installs)
- International markets with slower connections benefit

---

**5. Modular Asset Organization → Easy Feature Development**

**Approach:**

```yaml
flutter:
  assets:
    - assets/images/common/ # Shared across app
    - assets/images/auth/ # Login/signup screens
    - assets/images/library/ # Book library feature
    - assets/images/profile/ # User profile feature
```

**Benefits:**

- ✅ Features can be developed independently
- ✅ Easy to remove entire features (delete folder)
- ✅ Asset loading can be lazy-loaded by feature
- ✅ Clear ownership (which team manages which assets)

**Scalability Impact:**

- Supports microservices architecture
- Enables feature flags (enable/disable features)
- Easier code splitting for web/desktop platforms
- Prepares for dynamic feature modules

---

**6. Version Control Integration → Team Workflow**

**Git Best Practices:**

```gitignore
# .gitignore (what NOT to commit)
*.psd              # Source files (keep in design repo)
*.ai
*.sketch
*_unoptimized.png  # Pre-compressed versions
```

```
# What TO commit:
✅ Optimized, final assets
✅ assets/ASSETS_README.md (documentation)
✅ pubspec.yaml asset configuration
```

**Benefits:**

- ✅ Designers and developers in sync
- ✅ Git diffs show asset changes
- ✅ Rollback possible if asset causes issues
- ✅ Design source files kept separate (cleaner repo)

**Scalability Impact:**

- Repository size stays manageable
- Collaboration across distributed teams
- Design iteration doesn't pollute git history
- CI/CD pipelines can validate assets

---

**7. Documentation → Knowledge Transfer**

**Our Documentation:**

- `assets/ASSETS_README.md` - Asset guidelines
- `ASSET_MANAGEMENT_README.md` - This file
- Inline code comments for complex asset usage

**Benefits:**

- ✅ New team members get up to speed quickly
- ✅ Consistent practices across team
- ✅ Reduces back-and-forth questions
- ✅ Serves as reference during code reviews

**Scalability Impact:**

- Team can grow without knowledge silos
- Standards maintained as developers rotate
- Reduces onboarding time from weeks to days
- Institutional knowledge preserved

---

**Summary: Scalability Benefits**

| Practice                 | Small Team (1-3 devs) | Large Team (10+ devs) | Enterprise (100+ devs) |
| ------------------------ | --------------------- | --------------------- | ---------------------- |
| **Organized Folders**    | Nice to have          | Very helpful          | Critical               |
| **Naming Conventions**   | Helpful               | Important             | Critical               |
| **Error Handling**       | Important             | Critical              | Critical               |
| **Optimization**         | Optional              | Important             | Critical               |
| **Modular Organization** | Optional              | Helpful               | Critical               |
| **Version Control**      | Important             | Critical              | Critical               |
| **Documentation**        | Helpful               | Important             | Critical               |

**Key Takeaway:**
Proper asset management isn't just about loading images — it's about building maintainable, performant, collaborative codebases that can grow from MVP to enterprise-scale applications. The practices we implemented in OpenShelf set a foundation for sustainable growth.

---

## ✅ Testing Guide

### Prerequisites

```bash
cd openshelf_app
flutter pub get
```

### Test Checklist

#### 1. Basic Asset Loading

- [ ] App runs without errors
- [ ] Navigate to `/asset-demo` route successfully
- [ ] All sections of AssetDemoScreen visible
- [ ] Scroll functionality works smoothly

#### 2. Image Display (With Assets)

If you've added images to `assets/images/`:

- [ ] Logo appears correctly
- [ ] Banner image displays with proper fit
- [ ] Background image shows in background section
- [ ] No broken image icons

#### 3. Image Display (Without Assets - Fallback)

If assets/images/ is empty:

- [ ] Placeholder icons appear instead of images
- [ ] "Image not found" messages display
- [ ] No app crashes or error screens
- [ ] Helpful text guides user to add images

#### 4. Icon Display

- [ ] All 12+ Material icons display correctly
- [ ] Icons have correct colors
- [ ] Icon variations section shows different styles
- [ ] Platform icons (Material vs Cupertino) appear

#### 5. Combined Layout

- [ ] Profile card renders properly
- [ ] Gradient background applies
- [ ] Stats with icons align correctly
- [ ] Text is readable over backgrounds

#### 6. Responsive Behavior

- [ ] Rotate device: layout adapts gracefully
- [ ] No overflow errors
- [ ] Scrolling works in all orientations
- [ ] Cards resize appropriately

#### 7. Error Handling

- [ ] Remove an image from assets/
- [ ] Run app: fallback UI appears (not crash)
- [ ] Add image back: displays correctly after hot restart

#### 8. Code Quality

- [ ] No compiler errors or warnings
- [ ] Code follows Flutter best practices
- [ ] Comments explain complex sections
- [ ] Consistent formatting throughout

---

## 📚 Resources

### Official Documentation

- [Flutter Asset Management](https://docs.flutter.dev/development/ui/assets-and-images)
- [Using Icons in Flutter](https://docs.flutter.dev/development/ui/widgets/icons)
- [pubspec.yaml Reference](https://docs.flutter.dev/tools/pubspec)
- [Material Icons Gallery](https://fonts.google.com/icons?selected=Material+Icons)
- [Cupertino Icons Reference](https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html)

### Tools & Resources

- [TinyPNG](https://tinypng.com/) - Image compression
- [ImageOptim](https://imageoptim.com/) - Mac image optimizer
- [Squoosh](https://squoosh.app/) - Web-based image compressor
- [Flutter Icon Browser](https://www.fluttericon.com/) - Search all Flutter icons
- [placeholder.com](https://placeholder.com/) - Placeholder images for testing

### Learning Resources

- [Flutter Cookbook: Images](https://docs.flutter.dev/cookbook/images)
- [Flutter Widget of the Week: Image](https://www.youtube.com/watch?v=7oIAs-0G4mw)
- [Working with Assets in Flutter](https://medium.com/flutter-community/working-with-assets-in-flutter-23a10c6d96f4)

---

## 📝 Summary

### What Was Built

**Assets:**

- ✅ Created `assets/images/` and `assets/icons/` directories
- ✅ Registered assets in `pubspec.yaml`
- ✅ Added comprehensive asset documentation

**Code:**

- ✅ `AssetDemoScreen` (850+ lines) - Comprehensive demo
- ✅ Image.asset() examples with error handling
- ✅ Icon library showcases (Material + Cupertino)
- ✅ Combined image/icon layouts
- ✅ Background images with DecorationImage
- ✅ Platform-specific icon comparisons

**Documentation:**

- ✅ This README with code examples and reflections
- ✅ `assets/ASSETS_README.md` for asset guidelines
- ✅ Inline code comments explaining concepts

### Key Takeaways

1. **Asset Registration**: `pubspec.yaml` is the source of truth
2. **Error Handling**: Always implement `errorBuilder` for images
3. **Organization**: Structured folders support team collaboration
4. **Icons**: Flutter provides 1000+ built-in icons
5. **Optimization**: Compress images for better performance
6. **Documentation**: Clear guides reduce onboarding time

---

**Sprint**: #2  
**Task**: Managing Images, Icons, and Local Assets in Flutter  
**Team**: Team Nova  
**Status**: ✅ Complete - Ready for Screenshot Capture & PR Submission

---

_Built with ❤️ using Flutter_
