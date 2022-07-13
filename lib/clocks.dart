import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';

import 'package:overclock/main.dart';

class Clocks extends StatefulWidget {
  const Clocks({Key? key}) : super(key: key);

  @override
  State<Clocks> createState() => _ClocksState();
}

class _ClocksState extends State<Clocks> {
  double globalPadding = 20.0;

  double globalFontSize = 20.0;
  String globalFont = 'Montserrat';

  int ticketNumber = 13;
  String ticketNumberParsed = '13';

  var terminal = [
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
  ];

  @override
  void initState() {
    super.initState();
    initTerminals();
  }

  void initTerminals() {
    for (var i = 0; i < 6; i++) {
      terminal[i].timer = 2.00;
      String timerParsed = terminal[i].timer.toString();
      log(timerParsed);
    }
    setState(() {});
  }

  void checkForVacancy(int _terminal) {
    switch (_terminal) {
      case 1:
        {
          log('Terminal 1 vacant');
        }
        break;
      case 2:
        {
          log('Terminal 2 vacant');
        }
        break;
      case 3:
        {
          log('Terminal 3 vacant');
        }
        break;
      case 4:
        {
          log('Terminal 4 vacant');
        }
        break;
      case 5:
        {
          log('Terminal 5 vacant');
        }
        break;
      case 6:
        {
          log('Terminal 6 vacant');
        }
        break;
    }
    ticketNumber++;
    ticketNumberParsed = ticketNumber.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //>>>>>>>>>>>>>>>>>>>>> TOP CLOCKS
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                //Spacers divide space between elements
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(1);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 350.0),
                    ),
                  ],
                ),
                const Spacer(),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(2);
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 350.0),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          //>>>>>>>>>>>>>>>>>> BOTTOM CLOCKS
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                //Spacers divide space between elements
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 300.0),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(3);
                      },
                    ),
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 425.0),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(4);
                      },
                    ),
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 425.0),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(5);
                      },
                    ),
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 300.0),
                    ),
                    //Call to action
                    DragTarget(
                      builder: (context, data, rejectedDate) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: SvgPicture.asset(
                              'assets/ui/empty_slot_dark.svg',
                            ),
                          ),
                        );
                      },
                      onAccept: (data) {
                        checkForVacancy(6);
                      },
                    ),
                    //Sideways timer
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '10:00',
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 169, 169),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          //>>>>>>>>>>>>>> DRAGGABLE TICKET WIDGET
          Align(
            alignment: Alignment.center,
            child: Draggable(
              data: 1,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 255, 136, 0),
                child: Text(
                  ticketNumberParsed,
                  style: const TextStyle(
                    fontFamily: 'Montserrat-SemiBold',
                    fontSize: 20,
                  ),
                ),
              ),
              feedback: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 255, 136, 0),
                child: Text(
                  ticketNumberParsed,
                  style: const TextStyle(
                    fontFamily: 'Montserrat-SemiBold',
                    fontSize: 20,
                  ),
                ),
              ),
              childWhenDragging: SizedBox(
                height: 56,
                width: 56,
                child: SvgPicture.asset(
                  'assets/ui/empty_slot_light.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
