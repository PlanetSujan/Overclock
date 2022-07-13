import 'package:flutter/material.dart';
import 'package:overclock/clocks.dart';

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
