import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Service class to interact with Firebase Cloud Functions
///
/// This service provides methods to call serverless backend functions
/// for operations like data processing, validation, and background tasks.
class CloudFunctionsService {
  // Firebase Functions instance
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Call the 'sayHello' cloud function
  ///
  /// This is a simple callable function that returns a personalized greeting.
  ///
  /// Parameters:
  /// - [name]: The name to include in the greeting
  ///
  /// Returns a Map containing:
  /// - message: The greeting message
  /// - timestamp: When the function was called
  /// - userId: The authenticated user's ID (or 'anonymous')
  ///
  /// Example:
  /// ```dart
  /// final result = await CloudFunctionsService().sayHello('Alex');
  /// print(result['message']); // "Hello, Alex! Welcome to OpenShelf 📚"
  /// ```
  Future<Map<String, dynamic>> sayHello(String name) async {
    try {
      // Get reference to the callable function
      final callable = _functions.httpsCallable('sayHello');

      // Call the function with parameters
      final result = await callable.call<Map<String, dynamic>>({'name': name});

      debugPrint('✅ sayHello function executed successfully');
      debugPrint('Response: ${result.data}');

      return result.data as Map<String, dynamic>;
    } catch (error) {
      debugPrint('❌ Error calling sayHello function: $error');
      rethrow;
    }
  }

  /// Add a book recommendation using a cloud function
  ///
  /// This function processes the book data, validates it, and stores it
  /// in Firestore with additional metadata.
  ///
  /// Parameters:
  /// - [title]: Book title (required)
  /// - [author]: Book author (required)
  /// - [genre]: Book genre (optional, defaults to "General")
  ///
  /// Returns a Map containing:
  /// - success: Whether the operation succeeded
  /// - bookId: The Firestore document ID of the new recommendation
  /// - message: Success message
  ///
  /// Throws:
  /// - FirebaseFunctionsException if user is not authenticated
  /// - FirebaseFunctionsException if required fields are missing
  ///
  /// Example:
  /// ```dart
  /// final result = await CloudFunctionsService().addBookRecommendation(
  ///   title: 'Clean Code',
  ///   author: 'Robert C. Martin',
  ///   genre: 'Programming',
  /// );
  /// print(result['bookId']); // Firestore document ID
  /// ```
  Future<Map<String, dynamic>> addBookRecommendation({
    required String title,
    required String author,
    String? genre,
  }) async {
    try {
      // Get reference to the callable function
      final callable = _functions.httpsCallable('addBookRecommendation');

      // Call the function with book data
      final result = await callable.call<Map<String, dynamic>>({
        'title': title,
        'author': author,
        'genre': genre ?? 'General',
      });

      debugPrint('✅ Book recommendation added via Cloud Function');
      debugPrint('Book ID: ${result.data['bookId']}');

      return result.data as Map<String, dynamic>;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Cloud Functions Error: ${e.code} - ${e.message}');
      debugPrint('Details: ${e.details}');
      rethrow;
    } catch (error) {
      debugPrint('❌ Error calling addBookRecommendation: $error');
      rethrow;
    }
  }

  /// Generic method to call any Cloud Function
  ///
  /// Use this for custom function calls or testing new functions
  ///
  /// Parameters:
  /// - [functionName]: The name of the cloud function to call
  /// - [parameters]: Map of parameters to pass to the function
  ///
  /// Returns the function's response data
  ///
  /// Example:
  /// ```dart
  /// final result = await CloudFunctionsService().callFunction(
  ///   'customFunction',
  ///   {'param1': 'value1', 'param2': 'value2'},
  /// );
  /// ```
  Future<dynamic> callFunction(
    String functionName,
    Map<String, dynamic> parameters,
  ) async {
    try {
      final callable = _functions.httpsCallable(functionName);
      final result = await callable.call(parameters);

      debugPrint('✅ Function $functionName executed successfully');
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Function Error [$functionName]: ${e.code} - ${e.message}');
      rethrow;
    } catch (error) {
      debugPrint('❌ Error calling function $functionName: $error');
      rethrow;
    }
  }

  /// Use Firebase Functions emulator for local development
  ///
  /// Call this during development to connect to local emulator
  /// instead of production functions.
  ///
  /// Parameters:
  /// - [host]: Emulator host (default: 'localhost')
  /// - [port]: Emulator port (default: 5001)
  ///
  /// Example:
  /// ```dart
  /// if (kDebugMode) {
  ///   CloudFunctionsService().useEmulator('localhost', 5001);
  /// }
  /// ```
  void useEmulator(String host, int port) {
    _functions.useFunctionsEmulator(host, port);
    debugPrint('🔧 Using Cloud Functions emulator at $host:$port');
  }
}
