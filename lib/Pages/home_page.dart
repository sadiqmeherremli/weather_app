import 'package:flutter/material.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<WeatherModel> weathers = [];

class _HomePageState extends State<HomePage> {
  void getWeatherData() async {
    weathers = await WeatherService().getWeatherdata();
    setState(() {});
  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: ListView.builder(
        itemCount: weathers.length,
        itemBuilder: (BuildContext context, int index) {
          var weaathers = weathers[index];
          String? data = weaathers.degree;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            child: ListTile(
              leading: Image.network(weaathers.icon ?? ""),
              title: Text(
                weaathers.day ?? "",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                children: [
                  Text(
                    "${((double.tryParse(weaathers.degree ?? '0')! - 32) * 5 / 9 * -1).toStringAsFixed(1)} °C",
                    style:
                        TextStyle(fontSize: 20, color: const Color(0xFFD3D1D1)),
                  ),
                  Text(
                    weaathers.description ?? "",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  Text(
                    "Min: ${weaathers.min ?? ""} Max: ${weaathers.max ?? ""}",
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    "Humidity: ${weaathers.humidity}",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
