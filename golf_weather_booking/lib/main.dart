import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'dart:js' as js;

void main() {
  runApp(const GolfWeatherBookingApp());
}

class GolfWeatherBookingApp extends StatelessWidget {
  const GolfWeatherBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Golf Weather Booking'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            Divider(),
            GolfCourseCard("Centennial Park Golf Course", 'Etobicoke, Ontario, Canada', "(416)-620-1392"),
            CityWeather("Toronto", "https://www.golfcpgc.com/"),
            Divider(),
            GolfCourseCard("Richmond Park Golf Course", 'London, England', "+44 20 8876 3205"),
            CityWeather("London", "https://richmond.intelligentgolf.co.uk/visitorbooking/"),
          ],
        ),
      ),
    );
  }
}

class GolfCourseCard extends StatelessWidget {
  String golfCourse;
  String golfCourseLocation;
  String golfCoursePhone;

  GolfCourseCard(this.golfCourse, this.golfCourseLocation, this.golfCoursePhone);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        semanticContainer: true,
        child: SizedBox(
          width: 250 ,
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(golfCourse),
                Text(golfCourseLocation),
                Text(golfCoursePhone)
              ]
            )
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  String date;
  String time;
  String weather;
  String temperature;
  String wind;
  String url;

  WeatherCard(this.date, this.time, this.weather, this.temperature, this.wind, this.url);
  Set<String> validTimes = {"7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM",  "4 PM",  "5 PM",  "6 PM", "7 PM"};

  //// Text("BUTTON GOES HERE") ? validTimes.contains(time) : Text("")
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        semanticContainer: true,
        child: SizedBox(
          width: 250 ,
          height: 170,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(date),
                Text(time),
                Text(weather),
                Text(temperature),
                Text(wind),
                FilledButton(
                  onPressed: () {
                    js.context.callMethod('open', [url]);
                }, child: Text("Book now"))
              ]
            )
          ),
        ),
      ),
    );
  }
}

class CityWeather extends StatefulWidget {
  String city;
  String url;
  CityWeather(this.city, this.url);

	@override
	State<CityWeather> createState() => WeatherContainer(city, url);
}

class WeatherContainer extends State<CityWeather>  {
  String city;
  String url;
  WeatherContainer(this.city, this.url);

  var _weatherData = [];

  void _fetchCityWeather() async {

      const WEATHER_API_KEY = '32e0b7d3ea253ead457145ad787ba7e6';
      WeatherFactory wf = WeatherFactory(WEATHER_API_KEY);

      final dayData = { "1" : "Monday", "2" : "Tuesday", "3" : "Wednesday", "4" : "Thursday", "5" : "Friday", "6" : "Saturday", "7" : "Sunday" };

      final monthData = { "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" };

      final timeData = { "1": "1 AM", "2": "2 AM", "3": "3 AM", "4": "4 AM", "5": "5 AM", "6": "6 AM", "7": "7 AM", "8": "8 AM", "9": "9 AM", "10": "10 AM", "11": "11 AM", "12": "12 PM",
      "13": "1 PM", "14": "2 PM", "15": "3 PM", "16": "4 PM", "17": "5 PM", "18": "6 PM", "19": "7 PM", "20": "8 PM", "21": "9 PM", "22": "10 PM", "23": "11 PM", "24": "12 AM"};
    
      final currData = await wf.fiveDayForecastByCityName(city);
      
      for (var day in currData) {

        _weatherData.add({
          'Date': (dayData[day.date?.day.toString()].toString() + ' ' + monthData[day.date?.month.toString()].toString() + ' ' + (day.date?.day).toString()),
          'Time': timeData[day.date?.hour.toString()],
          'Weather': 'Forecase: ' + day.weatherDescription.toString(),
          'Temp': day.temperature.toString(),
          'Wind': 'Wind Speeds: ' + day.windSpeed.toString() + 'm/s',
          'Url': url,
        });
        setState( () {
          _weatherData = _weatherData.toSet().toList();
        });
      }
	  }

    void initState() {
      _fetchCityWeather();
    }

  @override
  Widget build(BuildContext context) {
    print(_weatherData);

    return Center(
      child: Card(
        semanticContainer: true,
        child: SizedBox(
          height: 180,
          child: Center(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var data in _weatherData) WeatherCard(data['Date'], data['Time'], data['Weather'], data['Temp'], data['Wind'], data['Url'])
                ]
              )
            )
          ),
        ),
      ),
    );
  }
}
