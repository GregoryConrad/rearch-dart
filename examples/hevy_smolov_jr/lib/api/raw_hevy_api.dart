import 'dart:convert';

import 'package:hevy_smolov_jr/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:rearch/rearch.dart';

/// The shared preferences key used to store the user's Hevy API key
const sharedPrefsApiKeyKey = 'api-key';

/// [Capsule] representing the user's Hevy API key.
final Capsule<(String, void Function(String))> apiKeyCapsule = capsule((use) {
  final sharedPrefs = use(sharedPrefsCapsule);
  final (apiKey, setApiKey) = use.state(
    sharedPrefs.getString(sharedPrefsApiKeyKey) ?? '',
  );
  return (
    apiKey,
    (newApiKey) {
      sharedPrefs.setString(sharedPrefsApiKeyKey, newApiKey);
      setApiKey(newApiKey);
    },
  );
});

final Capsule<String> _apiDomainCapsule = capsule((use) => 'api.hevyapp.com');

/// Represents an [Exception] from the Hevy API.
sealed class HevyApiException implements Exception {}

/// Represents an [Exception] while completing a Hevy API request.
final class HevyApiNetworkException implements HevyApiException {
  /// Represents an [Exception] while completing a Hevy API request.
  const HevyApiNetworkException(this.underlyingException);

  /// The underlying [Exception] or [Error] thrown during the request.
  final Object underlyingException;

  @override
  String toString() {
    return 'HevyApiNetworkException(underlyingException: $underlyingException)';
  }
}

/// Represents an [Exception] regarding the [http.Response].
final class HevyApiResponseException implements HevyApiException {
  /// Represents an [Exception] regarding the [http.Response].
  const HevyApiResponseException(this.statusCode, this.errorMessage);

  /// The HTTP status code returned by the Hevy API.
  final int statusCode;

  /// The error message returned by the Hevy API.
  final String errorMessage;

  @override
  String toString() {
    return 'HevyApiResponseException(statusCode: $statusCode, '
        'errorMessage: "$errorMessage")';
  }
}

/// Represents an [Exception] parsing the [http.Response] from the Hevy API.
final class HevyApiResponseParseException implements HevyApiException {
  /// Represents an [Exception] parsing the [http.Response] from the Hevy API.
  HevyApiResponseParseException({
    required this.statusCode,
    required this.responseBody,
    required this.parseException,
  });

  /// The HTTP status code returned by the Hevy API.
  final int statusCode;

  /// The response body returned by the Hevy API that could not be parsed.
  final String responseBody;

  /// The [Exception] or [Error] thrown while parsing [responseBody].
  final Object parseException;

  @override
  String toString() {
    return 'HevyApiResponseParseException(statusCode: $statusCode, '
        'parseException: $parseException, responseBody: $responseBody)';
  }
}

/// Wraps a raw Hevy API HTTP call so that it:
/// - returns the response body as the decoded `Map<String, dynamic>`
/// - throws the appropriate type of [Exception] as needed
final Capsule<Future<Map<String, dynamic>> Function(Future<http.Response>)>
_parseApiRequestAction = capsule((use) {
  return (hevyApiRequest) async {
    late http.Response response;
    try {
      response = await hevyApiRequest;
    } catch (underlyingException, stackTrace) {
      Error.throwWithStackTrace(
        HevyApiNetworkException(underlyingException),
        stackTrace,
      );
    }

    late Map<String, dynamic> body;
    try {
      body = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw HevyApiResponseException(
          response.statusCode,
          body['error'] as String,
        );
      }
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        HevyApiResponseParseException(
          statusCode: response.statusCode,
          responseBody: response.body,
          parseException: e,
        ),
        stackTrace,
      );
    }

    return body;
  };
});

/// Represents an HTTP GET request that returns JSON.
typedef GetRequest =
    Future<Map<String, dynamic>> Function({
      required String path,
      Map<String, String>? queryParams,
    });

/// Represents an HTTP GET request to the Hevy API.
final Capsule<GetRequest> apiGetAction = capsule((use) {
  final parseRequest = use(_parseApiRequestAction);
  final apiDomain = use(_apiDomainCapsule);
  final headers = {
    'accept': 'application/json',
    'api-key': use(apiKeyCapsule).$1,
  };

  return ({required String path, Map<String, dynamic>? queryParams}) {
    return parseRequest(
      http.get(
        Uri.https(apiDomain, path, queryParams),
        headers: headers,
      ),
    );
  };
});

/// Represents an HTTP POST request that returns JSON.
typedef PostRequest =
    Future<Map<String, dynamic>> Function({
      required String path,
      Object? jsonBody,
      Map<String, String>? queryParams,
    });

/// Represents an HTTP POST request to the Hevy API.
final Capsule<PostRequest> apiPostAction = capsule((use) {
  final parseRequest = use(_parseApiRequestAction);
  final apiDomain = use(_apiDomainCapsule);
  final headers = {
    'accept': 'application/json',
    'api-key': use(apiKeyCapsule).$1,
    'Content-Type': 'application/json',
  };

  return ({
    required String path,
    Object? jsonBody,
    Map<String, dynamic>? queryParams,
  }) {
    return parseRequest(
      http.post(
        Uri.https(apiDomain, path, queryParams),
        headers: headers,
        body: json.encode(jsonBody),
      ),
    );
  };
});
