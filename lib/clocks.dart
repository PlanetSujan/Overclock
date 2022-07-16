import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';
import 'dart:async';

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

  Color lightGrey = Color.fromARGB(255, 203, 203, 203);
  Color darkGrey = Color.fromARGB(255, 90, 90, 90);

  var terminal = [
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
  ];

  void startTimer(int n) {
    var _term = terminal[n];
    const oneSec = Duration(seconds: 1);
    _term.timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        //On timer reaching 0 or beyond
        if (_term.curTime <= 0) {
          _term.curTime = _term.startTime;
          _term.totalTimeParsed = "10:00";
          setState(() {
            _term.textColor = lightGrey;
            _term.vacancyState = true;
            _term.timer?.cancel();
          });
          //Timer ticking
        } else {
          //Must be set every time timer ticks to stop duplication
          _term.vacancyState = false;
          _term.minutes = (_term.curTime / 60).floor();
          _term.seconds = _term.curTime % 60;
          //Add a '0' to the beginning if number less than two digits
          if (_term.minutes < 10) {
            _term.minutesParsed = "0" + _term.minutes.toString();
          } else {
            _term.minutesParsed = _term.minutes.toString();
          }
          if (_term.seconds < 10) {
            _term.secondsParsed = "0" + _term.seconds.toString();
          } else {
            _term.secondsParsed = _term.seconds.toString();
          }
          //Finalise timer display
          _term.totalTimeParsed =
              _term.minutesParsed + ":" + _term.secondsParsed;
          setState(() {
            _term.curTime--;
          });
        }
      },
    );
  }

//Initialize function if required
  @override
  void initState() {
    super.initState();
  }

//Check to se if terminal is vacant, if so then perform actions
  void checkForVacancy(int n) {
    if (terminal[n].vacancyState == true) {
      startTimer(n);
      terminal[n].textColor = darkGrey;
      ticketNumber++;
      ticketNumberParsed = ticketNumber.toString();

      setState(() {
        terminal[n].vacancyState == false;
        log(terminal[n].vacancyState.toString());
      });
    }
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
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[0].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[0].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                        checkForVacancy(0);
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
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[1].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[1].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                        checkForVacancy(2);
                      },
                    ),
                    //Sideways timer
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[2].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[2].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                        checkForVacancy(3);
                      },
                    ),
                    //Sideways timer
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[3].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[3].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                        checkForVacancy(4);
                      },
                    ),
                    //Sideways timer
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[4].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[4].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                        checkForVacancy(5);
                      },
                    ),
                    //Sideways timer
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        //color: Colors.red,
                        child: SizedBox(
                          height: 56,
                          width: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                terminal[5].totalTimeParsed,
                                style: TextStyle(
                                  color: terminal[5].textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
