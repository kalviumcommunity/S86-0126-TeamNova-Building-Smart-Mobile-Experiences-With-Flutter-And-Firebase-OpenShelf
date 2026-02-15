# Quick Start: Error Handling, Loaders & Empty States

Get professional error handling working in your app in under 5 minutes!

## 🚀 Instant Setup

### 1. Run the Demo
```bash
flutter run
# Navigate to /error-handling-demo
```

### 2. Explore 5 Tabs
- **Loading** - See all loading widget styles
- **Errors** - See all error displays
- **Empty** - See all empty state widgets
- **Future** - See FutureBuilder examples
- **Stream** - See StreamBuilder examples

## ⚡ Quick Usage Examples

### Show Loading
```dart
// During async operation
const LoadingWidget(message: 'Loading...')
```

### Show Error
```dart
// When error occurs
AppErrorWidget(
  message: 'Failed to load',
  onRetry: () => retry(),
)
```

### Show Empty State
```dart
// When no data
EmptyListWidget(
  itemName: 'book',
  onAdd: () => addBook(),
)
```

## 📱 Common Patterns

### Pattern 1: FutureBuilder
```dart
FutureBuilder<List<Item>>(
  future: fetchItems(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingWidget(message: 'Loading...');
    }
    
    if (snapshot.hasError) {
      return AppErrorWidget(
        message: ErrorHandlerService.getUserFriendlyMessage(snapshot.error),
        onRetry: () => setState(() {}),
      );
    }
    
    final items = snapshot.data ?? [];
    if (items.isEmpty) {
      return EmptyListWidget(itemName: 'item');
    }
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(items[index]),
    );
  },
)
```

### Pattern 2: StreamBuilder
```dart
StreamBuilder<List<Item>>(
  stream: itemsStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingWidget();
    }
    
    if (snapshot.hasError) {
      return NetworkErrorWidget(onRetry: reconnect);
    }
    
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return EmptyStateWidget(title: 'No items');
    }
    
    return ListView(children: snapshot.data!.map((item) => ItemCard(item)).toList());
  },
)
```

### Pattern 3: Error Handling
```dart
try {
  await someOperation();
} catch (error, stackTrace) {
  ErrorHandlerService.logError(error, stackTrace);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(ErrorHandlerService.getUserFriendlyMessage(error)),
    ),
  );
}
```

## 🎨 Widget Gallery

### Loading Widgets
```dart
// Basic
const LoadingWidget()

// With message
const LoadingWidget(message: 'Loading books...')

// Inline
const InlineLoadingWidget(message: 'Saving...')

// Skeleton
const SkeletonLoader(itemCount: 5)
```

### Error Widgets
```dart
// Generic error
AppErrorWidget(onRetry: retry)

// Network error
NetworkErrorWidget(onRetry: retry)

// Permission error
PermissionErrorWidget(permissionType: 'camera')

// Inline error
InlineErrorWidget(message: 'Invalid input')
```

### Empty State Widgets
```dart
// Generic
EmptyStateWidget(title: 'Nothing here')

// Empty list
EmptyListWidget(itemName: 'book', onAdd: add)

// Empty search
EmptySearchWidget(searchTerm: 'flutter')

// Empty favorites
EmptyFavoritesWidget(onBrowse: browse)

// No connection
NoConnectionWidget(onRetry: retry)
```

## 🔧 Quick Customization

### Change Loading Color
```dart
LoadingWidget(
  message: 'Loading...',
  color: Colors.green,
  size: 60,
)
```

### Customize Error Message
```dart
AppErrorWidget(
  icon: Icons.cloud_off,
  message: 'Custom error message',
  details: 'More details here',
  onRetry: retry,
)
```

### Custom Empty State
```dart
EmptyStateWidget(
  icon: Icons.bookmark_border,
  title: 'No bookmarks',
  message: 'Save items to view them here',
  actionLabel: 'Browse Books',
  onAction: browse,
)
```

## 🐛 Troubleshooting

### Error shows technical message?
```dart
// ❌ Don't do this
Text(error.toString())

// ✅ Do this
Text(ErrorHandlerService.getUserFriendlyMessage(error))
```

### Loading never ends?
```dart
// Check your Future/Stream completes
// Add timeout if needed
future.timeout(Duration(seconds: 30))
```

### Empty state not showing?
```dart
// Make sure to check for empty data
if (items.isEmpty) {
  return EmptyListWidget(itemName: 'item');
}
```

## 📖 Learn More

- Full guide: [ERROR_HANDLING_README.md](ERROR_HANDLING_README.md)
- Complete lesson: [ERROR_HANDLING_LEARNING_GUIDE.md](ERROR_HANDLING_LEARNING_GUIDE.md)
- See demo: Navigate to `/error-handling-demo`

## ✅ What You Get

✨ **Out of the Box:**
- 3 loading widget types
- 5 error widget types
- 5 empty state widgets
- Error handler service
- Complete demo screen
- FutureBuilder examples
- StreamBuilder examples

## 🎉 You're Ready!

All widgets are ready to use. Just import and add to your screens!

```dart
import 'package:openshelf_app/widgets/loading_widget.dart';
import 'package:openshelf_app/widgets/error_widget.dart';
import 'package:openshelf_app/widgets/empty_state_widget.dart';
import 'package:openshelf_app/services/error_handler_service.dart';
```

**Happy Coding! 🚀**
