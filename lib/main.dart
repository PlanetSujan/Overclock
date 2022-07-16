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
  int startTime = 600;
  int curTime = 600;
  int minutes = 0;
  int seconds = 0;
  String minutesParsed = "";
  String secondsParsed = "";
  double totalTime = 0;
  String totalTimeParsed = "10:00";
  Color textColor = Color.fromARGB(255, 203, 203, 203);
}
