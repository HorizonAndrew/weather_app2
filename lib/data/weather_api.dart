import 'dart:convert';
import 'package:http/http.dart';
import 'package:weather_app2/models/city.dart';
import 'package:weather_app2/models/weather.dart';

class WeatherApi {
  const WeatherApi(this._client);

  final Client _client;

  Future<List<City>> getCities(String cityName) async {
    final Response response = await _client.get(
      Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=efc2113600604544cf7407bcd6ff4d8e',
      ),
    );

    final List<dynamic> result = jsonDecode(response.body) as List<dynamic>;
    final List<dynamic> cities = result;

    final List<City> list = <City>[];
    for (int i = 0; i < cities.length; i++) {
      final Map<String, dynamic> item = cities[i] as Map<String, dynamic>;
      list.add(City.fromJson(item));
    }

    return list;
  }

  Future<List<Weather>> getWeather(double lat, double lon, String name) async {
    // final int indexOfWeather = findWeatherUsingIndexWhere(_weather, name);
    //if (indexOfWeather == -1) {
    final Response response = await get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=efc2113600604544cf7407bcd6ff4d8e',
      ),
    );

    final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;

    final String cityName = name;
    final int id = result['weather'][0]['id'] as int;
    final String main = result['weather'][0]['main'] as String;
    final String description = result['weather'][0]['description'] as String;
    final String icon = result['weather'][0]['icon'] as String;
    final double temp = result['main']['temp'] as double;
    final double feelsLike = result['main']['feels_like'] as double;
    final double tempMin = result['main']['temp_min'] as double;
    final double tempMax = result['main']['temp_max'] as double;
    final int pressure = result['main']['pressure'] as int;
    final int humidity = result['main']['humidity'] as int;
    final double windSpeed = result['wind']['speed'] as double;

    final Weather weather = Weather(
      cityName: cityName,
      id: id,
      main: main,
      description: description,
      icon: icon,
      temp: temp,
      feelsLike: feelsLike,
      tempMin: tempMin,
      tempMax: tempMax,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
    );

    final List<Weather> list = <Weather>[];
    list.add(weather);

    return list;
  }
}