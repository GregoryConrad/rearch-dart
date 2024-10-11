import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rearch/rearch.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/main.dart';

// NOTE: error paths are not tested for simplicity.
void main() {
  group('weather api interop', () {
    test('searchLocationAction returns correct Location', () async {
      final (container, mockClient) = useMockedClientContainer();

      const queryString = 'bost';
      const id = 123;
      const cityName = 'Boston';
      const latitude = 123.0;
      const longitude = 321.0;
      Future<http.Response> expectedCall() => mockClient.get(
            Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
              'name': queryString,
              'count': '1',
            }),
          );
      when(expectedCall).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'results': [
              {
                'id': id,
                'name': cityName,
                'latitude': latitude,
                'longitude': longitude,
              },
            ],
          }),
          200,
        ),
      );

      final actualLocation =
          await container.read(searchLocationAction)(queryString);
      verify(expectedCall).called(1);
      expect(
        actualLocation,
        const Location(
          id: id,
          name: cityName,
          latitude: latitude,
          longitude: longitude,
        ),
      );
    });

    test('fetchWeatherAction returns correct Weather', () async {
      final (container, mockClient) = useMockedClientContainer();

      const latitude = 123.0;
      const longitude = 321.0;
      const temperature = 20.0;
      const weatherCode = 1.0; // = cloudy
      Future<http.Response> expectedCall() => mockClient.get(
            Uri.https('api.open-meteo.com', '/v1/forecast', {
              'latitude': '$latitude',
              'longitude': '$longitude',
              'current_weather': 'true',
            }),
          );
      when(expectedCall).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'current_weather': {
              'temperature': temperature,
              'weathercode': weatherCode,
            },
          }),
          200,
        ),
      );

      final actualWeather = await container.read(fetchWeatherAction)(
        latitude: latitude,
        longitude: longitude,
      );
      verify(expectedCall).called(1);
      expect(
        actualWeather,
        const Weather(temperature: temperature, weatherCode: weatherCode),
      );
    });
  });

  testWidgets('ui shows current weather', (WidgetTester tester) async {
    const expectedLatitude = 123.0;
    const expectedLongitude = 321.0;
    const cityQuery = 'Bost';
    const expectedCity = 'Boston';
    const expectedTemperature = 11.0;
    const expectedWeatherCode = 1.0; // = cloudy
    final container = useContainer()
      ..mock(searchLocationAction).apply(
        (use) => (String query) async {
          if (query != cityQuery) {
            throw Exception('Location query did not match expectations');
          }
          return const Location(
            id: 0,
            name: expectedCity,
            latitude: expectedLatitude,
            longitude: expectedLongitude,
          );
        },
      )
      ..mock(fetchWeatherAction).apply(
        (use) => ({
          required double latitude,
          required double longitude,
        }) async {
          if (latitude != expectedLatitude && longitude != expectedLongitude) {
            throw Exception('Weather query did not match expectations');
          }
          return const Weather(
            temperature: expectedTemperature,
            weatherCode: expectedWeatherCode,
          );
        },
      );

    await tester.pumpWidget(
      CapsuleContainerProvider(
        container: container,
        child: const MaterialApp(home: WeatherHome()),
      ),
    );

    await tester.enterText(find.byType(TextField), cityQuery);
    await tester.pumpAndSettle();

    expect(find.text(expectedCity), findsOneWidget);
    expect(find.text('Cloudy Skies'), findsOneWidget);
    expect(find.text('☁️'), findsOneWidget);
    expect(find.text('${expectedTemperature.toInt()}°C'), findsOneWidget);
  });
}

MockableContainer useContainer() {
  final container = MockableContainer();
  addTearDown(container.dispose);
  return container;
}

(MockableContainer, MockClient) useMockedClientContainer() {
  final mockClient = MockClient();
  final container = useContainer()
    ..mock(httpClientCapsule).apply((use) => mockClient);
  return (container, mockClient);
}

class MockClient extends Mock implements http.Client {}
