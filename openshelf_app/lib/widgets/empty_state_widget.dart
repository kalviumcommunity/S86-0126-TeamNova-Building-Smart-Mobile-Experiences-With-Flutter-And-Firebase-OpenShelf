import 'package:flutter/material.dart';

/// Reusable empty state widget
/// Shows when no data is available with helpful messaging
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (illustration != null)
              illustration!
            else
              Icon(
                icon,
                size: 80,
                color: Theme.of(context).colorScheme.outline,
              ),
            const SizedBox(height: 24),
            Text(
              title ?? 'Nothing here yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty list state widget
class EmptyListWidget extends StatelessWidget {
  final String itemName;
  final VoidCallback? onAdd;

  const EmptyListWidget({
    super.key,
    required this.itemName,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.list_alt,
      title: 'No $itemName yet',
      message: 'Start by adding your first $itemName',
      actionLabel: onAdd != null ? 'Add $itemName' : null,
      onAction: onAdd,
    );
  }
}

/// Empty search results widget
class EmptySearchWidget extends StatelessWidget {
  final String? searchTerm;
  final VoidCallback? onClearSearch;

  const EmptySearchWidget({
    super.key,
    this.searchTerm,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      message: searchTerm != null
          ? 'No results for "$searchTerm"\nTry a different search term'
          : 'Try searching for something else',
      actionLabel: onClearSearch != null ? 'Clear Search' : null,
      onAction: onClearSearch,
    );
  }
}

/// Empty favorites widget
class EmptyFavoritesWidget extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EmptyFavoritesWidget({
    super.key,
    this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No favorites yet',
      message: 'Items you favorite will appear here',
      actionLabel: onBrowse != null ? 'Browse Items' : null,
      onAction: onBrowse,
    );
  }
}

/// No internet connection empty state
class NoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoConnectionWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.cloud_off,
      title: 'You\'re offline',
      message: 'Connect to the internet to view content',
      actionLabel: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }
}
