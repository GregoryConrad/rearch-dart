part of '../api.dart';

// NOTE: This file was modified from the flutter_weather BLoC example app
// with changes for ReArch.
// A copy of BLoC's license is included below.

/*
MIT License

Copyright (c) 2024 Felix Angelov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/// Encapsulates a [http.Client], which in turn enables easy mocking in tests.
http.Client httpClientCapsule(CapsuleHandle use) => http.Client();

String _baseWeatherUrlCapsule(CapsuleHandle use) => 'api.open-meteo.com';
String _baseGeocodingUrlCapsule(CapsuleHandle use) =>
    'geocoding-api.open-meteo.com';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

/// Action capsule that finds a [Location] via `/v1/search/?name=(query)`.
Future<Location> Function(String) searchLocationAction(CapsuleHandle use) {
  final client = use(httpClientCapsule);
  final baseGeocodingUrl = use(_baseGeocodingUrlCapsule);

  return (String query) async {
    final locationRequest = Uri.https(baseGeocodingUrl, '/v1/search', {
      'name': query,
      'count': '1',
    });

    final locationResponse = await client.get(locationRequest);
    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;
    if (!locationJson.containsKey('results')) {
      throw LocationNotFoundFailure();
    }

    final results = locationJson['results'] as List;
    if (results.isEmpty) {
      throw LocationNotFoundFailure();
    }

    return Location.fromJson(results.first as Map<String, dynamic>);
  };
}

/// Action capsule that fetches [Weather] for a given latitude and longitude.
Future<Weather> Function({
  required double latitude,
  required double longitude,
})
fetchWeatherAction(CapsuleHandle use) {
  final client = use(httpClientCapsule);
  final baseWeatherUrl = use(_baseWeatherUrlCapsule);

  return ({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(baseWeatherUrl, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
    });

    final weatherResponse = await client.get(weatherRequest);
    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;
    return Weather.fromJson(weatherJson);
  };
}
