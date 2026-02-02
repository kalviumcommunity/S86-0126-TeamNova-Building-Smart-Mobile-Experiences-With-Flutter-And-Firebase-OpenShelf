# Assets Folder - OpenShelf

This folder contains all local assets used in the OpenShelf application.

## Folder Structure

```
assets/
├── images/          # Application images (PNG, JPG, SVG)
│   ├── logo.png
│   ├── banner.jpg
│   └── background.png
│
└── icons/           # Custom icon images
    ├── star.png
    └── profile.png
```

## Adding Your Own Assets

### Required Images for Demo:

1. **logo.png** (Recommended: 512x512px, transparent background)
   - Your team logo or OpenShelf app icon
   - Place in: `assets/images/logo.png`

2. **banner.jpg** (Recommended: 1200x400px)
   - App banner or feature image
   - Place in: `assets/images/banner.jpg`

3. **background.png** (Recommended: 1080x1920px)
   - Background texture or pattern
   - Place in: `assets/images/background.png`

4. **star.png** (Recommended: 128x128px, transparent)
   - Custom star icon
   - Place in: `assets/icons/star.png`

5. **profile.png** (Recommended: 256x256px, transparent)
   - Profile/user icon
   - Place in: `assets/icons/profile.png`

## Quick Start

### Option 1: Use Placeholder Images

For quick testing, you can use placeholder images from:

- https://placeholder.com/
- https://picsum.photos/
- Create simple colored squares in any image editor

### Option 2: Use Your Team Assets

1. Prepare your images with the recommended dimensions
2. Name them according to the structure above
3. Place them in the correct folders
4. Run `flutter pub get` to refresh assets

## Image Guidelines

- **Format**: PNG for logos/icons (supports transparency), JPG for photos
- **Size**: Keep images under 2MB for optimal app performance
- **Resolution**: Use 2x and 3x versions for better quality on different devices
- **Naming**: Use lowercase with underscores (e.g., `app_logo.png`)

## After Adding Images

1. Ensure `pubspec.yaml` has these assets registered:

   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/icons/
   ```

2. Run in terminal:

   ```bash
   flutter pub get
   flutter clean
   flutter run
   ```

3. Verify images load correctly in the AssetDemoScreen

## Troubleshooting

**Images not showing?**

- Check file paths match exactly (case-sensitive)
- Verify `pubspec.yaml` indentation (2 spaces)
- Run `flutter pub get` after adding new assets
- Perform hot restart (not just hot reload) after asset changes

**Large app size?**

- Compress images using TinyPNG or similar tools
- Use appropriate image formats (PNG for transparency, JPG for photos)
- Consider using vector graphics (SVG) when possible

---

**Note**: This folder is registered in `pubspec.yaml` and all files here will be bundled with your app.
