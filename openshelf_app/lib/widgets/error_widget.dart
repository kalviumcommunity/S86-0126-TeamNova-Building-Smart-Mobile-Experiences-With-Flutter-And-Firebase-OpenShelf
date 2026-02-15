import 'package:flutter/material.dart';

/// Reusable error state widget
/// Shows user-friendly error message with retry option
class AppErrorWidget extends StatelessWidget {
  final String? message;
  final String? details;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool showRetryButton;

  const AppErrorWidget({
    super.key,
    this.message,
    this.details,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
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

/// Network error specific widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.wifi_off,
      message: 'No Internet Connection',
      details: 'Please check your connection and try again',
      onRetry: onRetry,
    );
  }
}

/// Permission error widget
class PermissionErrorWidget extends StatelessWidget {
  final String? permissionType;
  final VoidCallback? onRequestPermission;

  const PermissionErrorWidget({
    super.key,
    this.permissionType,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.lock_outline,
      message: 'Permission Required',
      details: permissionType != null
          ? 'This feature requires $permissionType permission'
          : 'Please grant the necessary permissions',
      onRetry: onRequestPermission,
      showRetryButton: onRequestPermission != null,
    );
  }
}

/// Inline error message (for forms, etc.)
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
          if (onDismiss != null) ...[
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
