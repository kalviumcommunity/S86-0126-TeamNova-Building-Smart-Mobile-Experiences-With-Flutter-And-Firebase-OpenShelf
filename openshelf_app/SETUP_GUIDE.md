# Flutter Setup Verification Guide - Sprint #2 Deliverable 1

## Quick Reference for TeamNova

This guide helps you capture the required screenshots and create your Pull Request for the Flutter environment setup verification.

---

## 📸 Screenshot Checklist

You need to capture **4 screenshots** and save them in the `screenshots/` folder:

### 1. Flutter Doctor Output ✅

**File name**: `flutter_doctor_output.png`

**How to capture**:

```bash
# Run flutter doctor with verbose output
flutter doctor -v

# Take a screenshot of the terminal showing all green checkmarks
```

**What to show**: All components with ✅ checkmarks, no errors

---

### 2. Flutter Devices List ✅

**File name**: `flutter_devices.png`

**How to capture**:

```bash
# List all available devices
flutter devices

# Take screenshot showing emulator-5554 and other devices
```

**What to show**: At least your Android emulator listed

---

### 3. App Running on Android Emulator 📱

**File name**: `app_on_emulator.png`

**How to capture**:

1. Make sure your Android emulator is running
2. Run the app:
   ```bash
   flutter run -d emulator-5554
   ```
3. Once the app loads, take a screenshot of the emulator showing the login screen
4. Use emulator's built-in screenshot tool (camera icon in sidebar) or use Windows Snipping Tool

**What to show**: Your OpenShelf app login screen with the beautiful gradient UI running on the emulator

---

### 4. App Running on Chrome (Web) 🌐

**File name**: `app_on_chrome.png`

**How to capture**:

1. Run the app on Chrome:
   ```bash
   flutter run -d chrome
   ```
2. The app will open in Chrome browser
3. Take a screenshot showing the app running in the browser
4. Include the browser window with URL bar visible to prove it's running on web

**What to show**: Same login screen but in Chrome browser, demonstrating cross-platform capability

---

## 📁 Organizing Screenshots

Your folder structure should look like this:

```
openshelf_app/
├── screenshots/
│   ├── flutter_doctor_output.png
│   ├── flutter_devices.png
│   ├── app_on_emulator.png
│   └── app_on_chrome.png
├── README.md (already updated with Setup Verification section)
├── lib/
├── android/
└── ... (other project files)
```

---

## 📝 Creating Your Pull Request

### Step 1: Check Current Status

```bash
# See what files have changed
git status

# You should see:
# - README.md (modified)
# - screenshots/ (new folder with 4 images)
# - Any other modified files
```

### Step 2: Stage Your Changes

```bash
# Add all changes
git add .

# Or add specific files
git add README.md
git add screenshots/
git add lib/screens/login_screen.dart
git add lib/screens/signup_screen.dart
```

### Step 3: Commit Your Changes

```bash
git commit -m "setup: completed Flutter SDK installation and first emulator run

- Installed Flutter SDK 3.38.7 on Windows 11
- Configured Android Studio with Flutter/Dart plugins
- Set up Android emulator (API 36)
- Verified environment with flutter doctor (all checks passed)
- Successfully ran OpenShelf app on emulator and Chrome
- Enhanced login/signup screens with modern UI/UX
- Added comprehensive setup verification documentation
- Included screenshots for all deliverable requirements"
```

### Step 4: Create a Branch (if not already on one)

```bash
# Create and switch to a new branch
git checkout -b sprint-2/setup-verification

# Or if you're already on a branch, just push
```

### Step 5: Push to GitHub

```bash
# Push your branch to GitHub
git push origin sprint-2/setup-verification

# If this is your first push on this branch:
git push -u origin sprint-2/setup-verification
```

### Step 6: Create Pull Request on GitHub

1. Go to your GitHub repository
2. You'll see a banner: "sprint-2/setup-verification had recent pushes"
3. Click **"Compare & pull request"**
4. Fill in the PR details:

**Title**:

```
[Sprint-2] Flutter Environment Setup – TeamNova
```

**Description**:

```markdown
## 📋 Setup Verification Deliverable

### ✅ Completed Tasks

- [x] Installed Flutter SDK 3.38.7 (stable channel)
- [x] Configured Android Studio with Flutter & Dart plugins
- [x] Set up Android emulator (sdk gphone16k x86 64, API 36)
- [x] Verified environment with `flutter doctor` - all checks passed
- [x] Successfully ran OpenShelf app on Android emulator
- [x] Successfully ran OpenShelf app on Chrome (web)
- [x] Enhanced login and signup screens with modern UI/UX
- [x] Added comprehensive documentation to README.md

### 📸 Screenshots Included

All screenshots are in the `screenshots/` folder:

1. ✅ Flutter Doctor output (all green checks)
2. ✅ Flutter devices list (emulator detected)
3. ✅ App running on Android emulator
4. ✅ App running on Chrome browser

### 🔧 Environment Details

- **OS**: Windows 11 Home (64-bit)
- **Flutter Version**: 3.38.7 (stable)
- **Dart Version**: 3.10.7
- **Android SDK**: 36.1.0 (API 36)
- **Emulator**: sdk gphone16k x86 64
- **IDE**: Visual Studio Code / Android Studio

### 💭 Setup Reflection

#### Challenges Faced:

1. **Developer Mode**: Required enabling Windows Developer Mode for symlink support
2. **Firebase Configuration**: Ensured proper placement of google-services.json
3. **Emulator Performance**: Optimized RAM allocation for smooth operation

#### Key Learnings:

- Understanding Flutter's multi-platform development workflow
- Importance of proper environment verification before development
- Cross-platform testing capabilities (Android + Web)
- Firebase integration requirements and setup

#### How This Prepares Us:

This complete development environment enables our team to:

- Build responsive mobile apps for multiple platforms
- Test on various devices and screen sizes
- Integrate Firebase for authentication and cloud services
- Collaborate effectively using Git workflows
- Deploy production-ready applications

### 🎨 Bonus: Enhanced UI/UX

While setting up, we also improved the login and signup screens with:

- Gradient backgrounds
- Form validation
- Password strength indicators
- Loading states
- Smooth animations
- Responsive design
- Professional Material Design components

### 📚 Documentation

All setup steps, screenshots, and reflections are documented in:

- `README.md` → Setup Verification section (comprehensive guide)
- `SETUP_GUIDE.md` → Step-by-step screenshot and PR guide

### ✅ Ready for Sprint #2 Development

Our environment is fully configured and ready for:

- Firebase authentication implementation
- Cloud Firestore integration
- Advanced responsive layouts
- Production deployment

---

**Submitted by**: TeamNova  
**Date**: January 27, 2026  
**Sprint**: Sprint #2 - Deliverable 1
```

5. Click **"Create pull request"**

---

## 🔍 Verification Before Submitting

Before you submit your PR, verify:

✅ All 4 screenshots are in the `screenshots/` folder  
✅ README.md has the "Setup Verification" section  
✅ Flutter doctor shows no errors  
✅ App runs successfully on emulator  
✅ Commit message follows the format  
✅ PR title matches: `[Sprint-2] Flutter Environment Setup – TeamNova`  
✅ PR description is complete with all sections

---

## ⚡ Quick Commands Reference

```bash
# Check Flutter environment
flutter doctor -v

# List devices
flutter devices

# Run on emulator
flutter run -d emulator-5554

# Run on Chrome
flutter run -d chrome

# Check git status
git status

# Add all changes
git add .

# Commit with message
git commit -m "setup: completed Flutter SDK installation and first emulator run"

# Push to GitHub
git push origin sprint-2/setup-verification
```

---

## 🎯 Success Criteria

Your PR will be approved if it includes:

1. ✅ **Complete README.md** with Setup Verification section
2. ✅ **4 Screenshots** proving successful setup
3. ✅ **Clean flutter doctor** output (no errors)
4. ✅ **Working app** on emulator and web
5. ✅ **Thoughtful reflection** on challenges and learnings
6. ✅ **Proper commit message** format
7. ✅ **Complete PR description** with all sections

---

## 📞 Need Help?

If you encounter issues:

1. Check `flutter doctor` for any missing dependencies
2. Ensure Developer Mode is enabled on Windows
3. Verify emulator is running: `flutter devices`
4. Check Firebase configuration in `android/app/google-services.json`
5. Review README.md Setup Verification section for troubleshooting

---

**Good luck, TeamNova! You've got this! 🚀**
