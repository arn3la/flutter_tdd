import 'package:flutter/material.dart';
import 'package:flutter_tdd/home/weather_dialog.dart';
import 'package:flutter_tdd/main.dart';
import 'package:flutter_tdd/utils/utils.dart';

final dialogController = DialogController();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Hello World!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: () => WeatherRegister(
                  location: InjectorWidget.of(context).location,
                  dio: InjectorWidget.of(context).dio,
                  dialogController: dialogController,
                ).showWeatherToday(context),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                      child: Icon(
                        Icons.wb_sunny,
                        key: Key('icon_weather'),
                      ),
                    ),
                    Text('Weather today'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
