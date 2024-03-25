import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';
import 'package:weather_app/api.dart';

// ignore_for_file: public_member_api_docs

void main() {
  runApp(const WeatherApp());
}

(String, void Function(String)) locationQueryManager(CapsuleHandle use) =>
    use.state('');

Future<Location> locationAsyncCapsule(CapsuleHandle use) {
  final searchLocation = use(searchLocationAction);
  final (locationQuery, _) = use(locationQueryManager);
  return searchLocation(locationQuery);
}

AsyncValue<Location> locationCapsule(CapsuleHandle use) =>
    use.future(use(locationAsyncCapsule));

Future<Weather> weatherAsyncCapsule(CapsuleHandle use) async {
  final fetchWeather = use(fetchWeatherAction);
  final locationFuture = use(locationAsyncCapsule);

  final location = await locationFuture;
  return fetchWeather(
    latitude: location.latitude,
    longitude: location.longitude,
  );
}

AsyncValue<Weather> weatherCapsule(CapsuleHandle use) =>
    use.future(use(weatherAsyncCapsule));

class WeatherApp extends StatelessWidget {
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

class WeatherHome extends RearchConsumer {
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
            if (location case AsyncError(:final error)
                when locationQuery.isNotEmpty)
              Text('Location not found: $error'),
            if (location.data case Some(value: Location(:final name))
                when location is! AsyncError)
              Text(name, style: textTheme.displayMedium),

            // Weather display
            if (weather.data
                case Some(
                  value: Weather(:final temperature, :final weatherCondition)
                ) when weather is! AsyncError) ...[
              Text(weatherCondition.emoji, style: textTheme.displayLarge),
              Text(weatherCondition.fullName, style: textTheme.headlineLarge),
              Text('${temperature.toInt()}°C', style: textTheme.headlineMedium),
            ],
            if (weather case AsyncError(:final error)
                when location is! AsyncError)
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
