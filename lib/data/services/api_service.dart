import 'dart:convert';
import 'dart:io';

/// Service for handling API communications.
/// 
/// This service provides a centralized way to handle HTTP requests
/// with proper error handling and response parsing.
/// 
/// Example usage:
/// ```dart
/// final apiService = ApiService();
/// final response = await apiService.get('/jobs');
/// ```
class ApiService {
  /// Base URL for the API
  final String baseUrl;
  
  /// HTTP client for making requests
  final HttpClient _httpClient;

  /// Creates a new [ApiService] instance.
  /// 
  /// [baseUrl] - The base URL for API requests
  /// [timeout] - Request timeout duration (default: 30 seconds)
  ApiService({
    required this.baseUrl,
    Duration timeout = const Duration(seconds: 30),
  }) : _httpClient = HttpClient() {
    _httpClient.connectionTimeout = timeout;
  }

  /// Makes a GET request to the specified endpoint.
  /// 
  /// Returns the response data as a Map.
  /// Throws [ApiException] if the request fails.
  /// 
  /// [endpoint] - The API endpoint (relative to baseUrl)
  /// [queryParameters] - Optional query parameters
  /// [headers] - Optional additional headers
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _makeRequest('GET', endpoint, 
        queryParameters: queryParameters, headers: headers);
  }

  /// Makes a POST request to the specified endpoint.
  /// 
  /// Returns the response data as a Map.
  /// Throws [ApiException] if the request fails.
  /// 
  /// [endpoint] - The API endpoint (relative to baseUrl)
  /// [body] - Request body data
  /// [headers] - Optional additional headers
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _makeRequest('POST', endpoint, body: body, headers: headers);
  }

  /// Makes a PUT request to the specified endpoint.
  /// 
  /// Returns the response data as a Map.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _makeRequest('PUT', endpoint, body: body, headers: headers);
  }

  /// Makes a DELETE request to the specified endpoint.
  /// 
  /// Returns the response data as a Map.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _makeRequest('DELETE', endpoint, headers: headers);
  }

  /// Internal method to handle HTTP requests.
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      // Build URL with query parameters
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      // Create request
      final request = await _httpClient.openUrl(method, finalUri);
      
      // Add headers
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      if (headers != null) {
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });
      }

      // Add body for POST/PUT requests
      if (body != null && (method == 'POST' || method == 'PUT')) {
        final jsonBody = jsonEncode(body);
        request.write(jsonBody);
      }

      // Send request and get response
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      // Handle response based on status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody.isEmpty) {
          return <String, dynamic>{};
        }
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: $responseBody',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Response parsing error: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Disposes of the HTTP client resources.
  void dispose() {
    _httpClient.close();
  }
}

/// Exception thrown when API operations fail.
/// 
/// This exception provides additional context about API failures
/// including status codes and error messages.
class ApiException implements Exception {
  /// The error message
  final String message;
  
  /// HTTP status code (if applicable)
  final int? statusCode;

  /// Creates a new [ApiException].
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException (${statusCode}): $message';
    }
    return 'ApiException: $message';
  }
} 