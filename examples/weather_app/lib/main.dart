import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';
import 'package:weather_app/api.dart';

// NOTE: the directory/file structure of this example is simply what made sense
// to me when I was writing the example based on its size (several hundred LoC).
// Feel free to bring your own file/directory layout preferences to the table.

void main() {
  runApp(const WeatherApp());
}

/// Root/application widget for the weather application.
class WeatherApp extends StatelessWidget {
  /// Constructs a [WeatherApp].
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RearchBootstrapper(
      child: MaterialApp(
        home: WeatherHome(),
      ),
    );
  }
}

/// Home page widget for the weather application.
class WeatherHome extends RearchConsumer {
  /// Constructs a [WeatherHome].
  const WeatherHome({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (locationQuery, setLocationQuery) = use(locationQueryManager);
    final location = use(locationCapsule);
    final weather = use(weatherCapsule);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Location input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: setLocationQuery,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
              ),
            ),
            const Spacer(),

            // Location display
            if (locationQuery.isEmpty) const Text('Enter a city above!'),
            if (location case AsyncError(
              :final error,
            ) when locationQuery.isNotEmpty)
              Text('Location not found: $error'),
            if (location.data case Some(
              value: Location(:final name),
            ) when location is! AsyncError)
              Text(name, style: textTheme.displayMedium),

            // Weather display
            if (weather.data case Some(
              value: Weather(:final temperature, :final weatherCondition),
            ) when weather is! AsyncError) ...[
              Text(weatherCondition.emoji, style: textTheme.displayLarge),
              Text(weatherCondition.fullName, style: textTheme.headlineLarge),
              Text('${temperature.toInt()}°C', style: textTheme.headlineMedium),
            ],
            if (weather case AsyncError(
              :final error,
            ) when location is! AsyncError)
              Text('Failed to fetch weather: $error'),

            // Loading display
            if (weather case AsyncLoading())
              const Expanded(child: CircularProgressIndicator.adaptive())
            else
              const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// Manages the current location query.
(String, void Function(String)) locationQueryManager(CapsuleHandle use) =>
    use.state('');

/// Gets a [Location] based on the current query in the [locationQueryManager].
Future<Location> locationAsyncCapsule(CapsuleHandle use) {
  final searchLocation = use(searchLocationAction);
  final (locationQuery, _) = use(locationQueryManager);
  return searchLocation(locationQuery);
}

/// Eagerly caches the state of the current [locationAsyncCapsule].
AsyncValue<Location> locationCapsule(CapsuleHandle use) =>
    use.future(use(locationAsyncCapsule));

/// Fetches the [Weather] based on the [Location] from [locationAsyncCapsule].
Future<Weather> weatherAsyncCapsule(CapsuleHandle use) async {
  final fetchWeather = use(fetchWeatherAction);
  final locationFuture = use(locationAsyncCapsule);

  final location = await locationFuture;
  return fetchWeather(
    latitude: location.latitude,
    longitude: location.longitude,
  );
}

/// Eagerly caches the state of the current [weatherAsyncCapsule].
AsyncValue<Weather> weatherCapsule(CapsuleHandle use) =>
    use.future(use(weatherAsyncCapsule));

extension on WeatherCondition {
  String get emoji {
    return switch (this) {
      WeatherCondition.clear => '☀️',
      WeatherCondition.cloudy => '☁️',
      WeatherCondition.rainy => '🌧️',
      WeatherCondition.snowy => '🌨️',
      WeatherCondition.unknown => '❓',
    };
  }

  String get fullName {
    return switch (this) {
      WeatherCondition.clear => 'Clear Skies',
      WeatherCondition.cloudy => 'Cloudy Skies',
      WeatherCondition.rainy => 'Rainy Skies',
      WeatherCondition.snowy => 'Snowy Skies',
      WeatherCondition.unknown => 'Unknown Conditions',
    };
  }
}
