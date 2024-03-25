part of '../api.dart';

// ignore_for_file: public_member_api_docs

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

// NOTE: I typically use and recommend freezed + json_serializable,
// but for this simple example app, I didn't see a need to bring in codegen.
class Location extends Equatable {
  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'] as int,
        name: json['name'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );

  final int id;
  final String name;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}

class Weather extends Equatable {
  const Weather({required this.temperature, required this.weatherCode});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        temperature: json['temperature'] as double,
        weatherCode: json['weathercode'] as double,
      );

  final double temperature;
  final double weatherCode;

  @override
  List<Object?> get props => [temperature, weatherCode];
}

enum WeatherCondition {
  clear,
  cloudy,
  rainy,
  snowy,
  unknown,
}

extension WeatherConditionConversion on Weather {
  WeatherCondition get weatherCondition {
    return switch (weatherCode.toInt()) {
      0 => WeatherCondition.clear,
      1 || 2 || 2 || 3 || 45 || 48 => WeatherCondition.cloudy,
      51 ||
      53 ||
      55 ||
      56 ||
      57 ||
      61 ||
      63 ||
      65 ||
      66 ||
      67 ||
      80 ||
      81 ||
      82 ||
      95 ||
      96 ||
      99 =>
        WeatherCondition.rainy,
      71 || 73 || 75 || 77 || 85 || 86 => WeatherCondition.snowy,
      _ => WeatherCondition.unknown,
    };
  }
}
