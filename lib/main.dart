import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:overclock/clocks.dart';
import 'dart:async';

void main() {
  runApp(const OverClock());
}

class OverClock extends StatelessWidget {
  const OverClock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat-ExtraLight'),
      home: const Clocks(),
    );
  }
}

class Terminal {
  bool vacancyState = true;
  bool ticking = false;
  Timer? timer;
  int startTime = 600; //Amount of seconds to reset to
  int curTime = 600; //Current time in raw seconds
  int minutes = 0;
  int seconds = 0;
  String minutesParsed = "";
  String secondsParsed = "";
  String totalTimeParsed = "10:00";
  Color textColor = Color.fromARGB(255, 203, 203, 203);
  bool playButtonVisible = false;
  String playButtonState = "off";
  bool playButtonPaused = false;
  Color playButtonColor = Color.fromARGB(255, 255, 136, 0);
  Icon playButtonIcon = Icon(Icons.play_arrow);
}
