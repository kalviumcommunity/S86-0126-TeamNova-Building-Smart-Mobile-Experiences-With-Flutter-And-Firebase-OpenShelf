# Screenshot Capture Instructions

## For Windows Users

This guide helps you capture the required screenshots for your Sprint #2 deliverable.

---

## 📸 Screenshot 1: Flutter Doctor Output

**File**: `screenshots/flutter_doctor_output.png`

**Steps**:

1. Open PowerShell or Command Prompt
2. Navigate to your project:
   ```powershell
   cd "C:\Users\G YASHMIEEN\OneDrive\Desktop\OpenShelf\S86-0126-TeamNova-Building-Smart-Mobile-Experiences-With-Flutter-And-Firebase-OpenShelf\openshelf_app"
   ```
3. Run:
   ```powershell
   flutter doctor -v
   ```
4. Press **Windows Key + Shift + S** to open Snipping Tool
5. Capture the terminal window showing the full output
6. Save as `screenshots/flutter_doctor_output.png`

---

## 📸 Screenshot 2: Flutter Devices

**File**: `screenshots/flutter_devices.png`

**Steps**:

1. In the same terminal, run:
   ```powershell
   flutter devices
   ```
2. Press **Windows Key + Shift + S**
3. Capture the output showing all available devices
4. Save as `screenshots/flutter_devices.png`

---

## 📸 Screenshot 3: App on Android Emulator

**File**: `screenshots/app_on_emulator.png`

**Steps**:

1. Make sure your emulator is running (check with `flutter devices`)
2. Run the app:
   ```powershell
   flutter run -d emulator-5554
   ```
3. Wait for the app to launch (you'll see the login screen with gradient background)
4. On the emulator window, look for the **camera icon** (📷) in the right sidebar
5. Click it to take a screenshot
6. The screenshot will be saved automatically, then move it to `screenshots/app_on_emulator.png`

**Alternative method**:

- Use Windows Snipping Tool (Win + Shift + S)
- Capture the entire emulator window showing your app
- Save as `screenshots/app_on_emulator.png`

---

## 📸 Screenshot 4: App on Chrome

**File**: `screenshots/app_on_chrome.png`

**Steps**:

1. Stop the emulator app (press 'q' in terminal)
2. Run on Chrome:
   ```powershell
   flutter run -d chrome
   ```
3. Chrome will open with your app
4. Make sure the URL bar is visible (shows localhost address)
5. Press **Windows Key + Shift + S**
6. Capture the Chrome window with your app
7. Save as `screenshots/app_on_chrome.png`

---

## ✅ Verify All Screenshots

After capturing, check your screenshots folder:

```
screenshots/
├── flutter_doctor_output.png
├── flutter_devices.png
├── app_on_emulator.png
└── app_on_chrome.png
```

**All 4 files should be present!**

---

## 🔧 Quick Screenshot Commands

Run these one by one and capture each output:

```powershell
# 1. Flutter Doctor (capture this)
flutter doctor -v

# 2. Flutter Devices (capture this)
flutter devices

# 3. Run on Emulator (capture the emulator window)
flutter run -d emulator-5554

# After app loads, press 'q' to quit, then:

# 4. Run on Chrome (capture the browser window)
flutter run -d chrome
```

---

## 💡 Tips

- **High Quality**: Capture screenshots at full resolution
- **Full Context**: Include window borders and titles
- **Readable Text**: Ensure all text is clear and readable
- **No Personal Info**: Check if any sensitive information is visible
- **File Names**: Use exact file names as specified
- **File Format**: PNG format is required

---

## 🎯 What Should Be Visible?

### Flutter Doctor Screenshot:

- ✅ All green checkmarks
- ✅ Flutter version 3.38.7
- ✅ Dart version 3.10.7
- ✅ Android toolchain
- ✅ "No issues found!" message

### Flutter Devices Screenshot:

- ✅ "sdk gphone16k x86 64" emulator
- ✅ Windows desktop
- ✅ Chrome web
- ✅ Edge web

### Emulator Screenshot:

- ✅ Login screen with gradient background
- ✅ Email and password fields
- ✅ Login button
- ✅ "Don't have an account? Sign Up" link
- ✅ OpenShelf branding/icon

### Chrome Screenshot:

- ✅ Same login screen
- ✅ Chrome browser visible
- ✅ URL bar showing localhost
- ✅ Full app interface

---

## 🚨 Common Issues

**Issue**: Emulator not showing in devices list

- **Fix**: Start the emulator from Android Studio AVD Manager

**Issue**: Chrome doesn't open

- **Fix**: Install Chrome or use Edge: `flutter run -d edge`

**Issue**: App takes long to build

- **Fix**: First build is slow, subsequent builds are faster

**Issue**: Screenshots folder doesn't exist

- **Fix**: The folder was created for you. If missing, create it manually

---

Now you're ready to capture all screenshots! 📸✨
