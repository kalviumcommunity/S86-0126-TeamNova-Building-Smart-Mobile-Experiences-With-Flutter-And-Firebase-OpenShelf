import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Centralized error handling service
/// Converts technical errors into user-friendly messages
class ErrorHandlerService {
  /// Get user-friendly error message from exception
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';

    // Firebase Auth Errors
    if (error is FirebaseAuthException) {
      return _handleAuthError(error);
    }

    // Firestore Errors
    if (error is FirebaseException) {
      return _handleFirebaseError(error);
    }

    // Network/Timeout Errors
    if (error.toString().contains('network') ||
        error.toString().contains('timeout') ||
        error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }

    // Permission Errors
    if (error.toString().contains('permission') ||
        error.toString().contains('PERMISSION_DENIED')) {
      return 'You don\'t have permission to perform this action.';
    }

    // Default fallback
    if (kDebugMode) {
      debugPrint('Unhandled error: $error');
    }

    return 'Something went wrong. Please try again.';
  }

  /// Handle Firebase Auth specific errors
  static String _handleAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  /// Handle Firebase (Firestore/Storage) errors
  static String _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'You don\'t have permission to access this resource.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'This resource already exists.';
      case 'resource-exhausted':
        return 'Service temporarily unavailable. Please try later.';
      case 'cancelled':
        return 'Operation was cancelled.';
      case 'invalid-argument':
        return 'Invalid data provided.';
      case 'unauthenticated':
        return 'Please sign in to continue.';
      case 'unavailable':
        return 'Service is currently unavailable. Please try later.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Get error icon based on error type
  static String getErrorIcon(dynamic error) {
    if (error == null) return '⚠️';

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return '📡';
    }

    if (errorString.contains('permission') || errorString.contains('denied')) {
      return '🔒';
    }

    if (errorString.contains('not-found') || errorString.contains('404')) {
      return '🔍';
    }

    return '⚠️';
  }

  /// Log error for debugging (development only)
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔴 ERROR: $error');
      if (stackTrace != null) {
        debugPrint('📍 STACK TRACE:');
        debugPrint(stackTrace.toString());
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    if (error == null) return false;

    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socketexception');
  }

  /// Check if error is permission related
  static bool isPermissionError(dynamic error) {
    if (error == null) return false;

    final errorString = error.toString().toLowerCase();
    return errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('unauthorized');
  }

  /// Get retry-able status
  static bool isRetryable(dynamic error) {
    return isNetworkError(error) ||
        error.toString().contains('timeout') ||
        error.toString().contains('unavailable');
  }
}

/// Error state enum for UI
enum ErrorType { network, permission, notFound, server, validation, unknown }

/// Error state class for structured error handling
class AppError {
  final String message;
  final String? details;
  final ErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    this.details,
    this.type = ErrorType.unknown,
    this.originalError,
    this.stackTrace,
  });

  factory AppError.fromException(dynamic error, [StackTrace? stackTrace]) {
    ErrorHandlerService.logError(error, stackTrace);

    ErrorType type = ErrorType.unknown;
    if (ErrorHandlerService.isNetworkError(error)) {
      type = ErrorType.network;
    } else if (ErrorHandlerService.isPermissionError(error)) {
      type = ErrorType.permission;
    }

    return AppError(
      message: ErrorHandlerService.getUserFriendlyMessage(error),
      type: type,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  bool get isRetryable => ErrorHandlerService.isRetryable(originalError);
}
