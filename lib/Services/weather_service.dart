import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/Models/weather_model.dart';

class WeatherService {
  Future<String> getLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Location service is not enabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }

    final Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final String? city = placemark[0].administrativeArea;

    if (city == null) return Future.error("city is null");

    return city;
  }

  Future<List<WeatherModel>> getWeatherdata() async {
    final String city = await getLocation();

    final String url =
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city';

    final Map<String, dynamic> headers = {
      "authorization": "apikey 5xeoKTyUZQzQACGhu4gKyP:5h9bAIXyCk5ao08zA8asB7",
      'content-type': 'application/json'
    };

    final Dio dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error("error");
    }

    final List<dynamic> data = response.data["result"];

    return data.map((item) => WeatherModel.fromJson(item)).toList();
  }
}
