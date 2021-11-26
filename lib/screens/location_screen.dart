import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;
  LocationScreen(this.weatherData);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();

  late String tempo;
  late String tempoM;
  late String weatherEmoji;
  late String cityName;

  void updateUi(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        tempo = '0';
        tempoM = 'Unable to get data';
        weatherEmoji = 'Error';
        cityName = '';
        return;
      }
      double temp = weatherData["main"]["temp"];
      tempo = temp.toStringAsFixed(1);
      tempoM = weatherModel.getMessage(temp.toInt());
      var condition = weatherData["weather"][0]["id"];
      weatherEmoji = weatherModel.getWeatherIcon(condition);
      cityName = weatherData["name"];
    });
  }

  @override
  void initState() {
    super.initState();
    updateUi(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/image2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          var weatherData =
                              await weatherModel.getLocationWeather();
                          updateUi(weatherData);
                        },
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('My location',
                            style: TextStyle(color: Colors.blue[200])),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CityScreen();
                              },
                            ),
                          );
                          if (typedName != null) {
                            var weatherData =
                                await weatherModel.getCityWeather(typedName);
                            updateUi(weatherData);
                          }
                        },
                        child: Icon(
                          Icons.public_outlined,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text('Worldwide',
                            style: TextStyle(color: Colors.blue[200])),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$tempo°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherEmoji,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10),
                child: Text(
                  "$tempoM in $cityName",
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
