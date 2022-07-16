import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:overclock/main.dart';

class Clocks extends StatefulWidget {
  const Clocks({Key? key}) : super(key: key);

  @override
  State<Clocks> createState() => _ClocksState();
}

class _ClocksState extends State<Clocks> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  double globalPadding = 20.0;

  double globalFontSize = 20.0;
  String globalFont = 'Montserrat';

  int ticketNumber = 1;
  String ticketNumberParsed = '1';
  bool ticketButtonsVisible = true;

  Color lightGrey = Color.fromARGB(255, 203, 203, 203);
  Color darkGrey = Color.fromARGB(255, 90, 90, 90);
  Color orange = Color.fromARGB(255, 255, 136, 0);

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
          resetTerminal(n);
          //Timer ticking
        } else {
          if (_term.ticking && !_term.playButtonPaused) {
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
        }
      },
    );
  }

  void resetTimer(int n) {
    var _term = terminal[n];
    _term.curTime = _term.startTime;
    _term.totalTimeParsed = "00:00";
    setState(() {
      _term.textColor = lightGrey;
      _term.vacancyState = true;
      _term.timer?.cancel();
    });
  }

  void resetTerminal(int n) {
    resetTimer(n);
    changePlayButtonState(n, "off");
    terminal[n].ticking = false;
  }

//Check to se if terminal is vacant, if so then perform actions
  void checkForVacancy(int n) {
    if (terminal[n].vacancyState == true) {
      terminal[n].textColor = darkGrey;
      terminal[n].totalTimeParsed = "10:00";
      changePlayButtonState(n, "play");
      ticketNumber++;
      ticketNumberParsed = ticketNumber.toString();
      setState(() {
        terminal[n].vacancyState == false;
        log(terminal[n].vacancyState.toString());
      });
    }
  }

//Set icons, visibility etc. below when play button state is changed
  void changePlayButtonState(int n, String state) {
    switch (state) {
      case "play":
        {
          terminal[n].playButtonIcon = Icon(Icons.play_arrow);
          terminal[n].playButtonColor = darkGrey;
          terminal[n].playButtonVisible = true;
          log("play state initiated");
        }
        break;
      case "pause":
        {
          terminal[n].playButtonIcon = Icon(Icons.stop);
          terminal[n].playButtonColor = darkGrey;
          log("pause state initiated");
        }
        break;
      case "off":
        {
          terminal[n].playButtonVisible = false;
          log("pause state initiated");
        }
        break;
    }
    terminal[n].playButtonState = state;
  }

  //Functionality for what happens when the button is pressed depending on state
  void pressPlayButton(int n, String pressType) {
    if (terminal[n].playButtonState == "play" && !terminal[n].ticking) {
      if (!terminal[0].playButtonPaused) {
        startTimer(n);
        log("play button press");
      }
      changePlayButtonState(n, "pause");
      terminal[n].ticking = true;
    } else if (terminal[n].playButtonState == "pause" && terminal[n].ticking) {
      //Pause
      /*
      if (pressType == "short") {
        terminal[n].playButtonPaused = false;
        changePlayButtonState(n, "play");
        terminal[n].ticking = false;
        log("pause button press");
      }
      */
      //Stop/vacate terminal
      if (pressType == "long") {
        resetTerminal(n);
        log("stop button press");
      }
    }
  }

  void pressTicketButton(String type) {
    if (ticketButtonsVisible) {
      switch (type) {
        case "plus":
          {
            if (ticketNumber < 999) ticketNumber++;
          }
          break;
        case "minus":
          {
            if (ticketNumber > 1) ticketNumber--;
          }
          break;
      }
      setState(() {
        ticketNumberParsed = ticketNumber.toString();
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
                              //Timer text
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[0].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[0].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(0, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[0].playButtonColor,
                              child: terminal[0].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(0, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                              //Timer text
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[1].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[1].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(1, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[1].playButtonColor,
                              child: terminal[1].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(1, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[2].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[2].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(2, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[2].playButtonColor,
                              child: terminal[2].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(2, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                              //Timer text
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[3].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[3].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(3, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[3].playButtonColor,
                              child: terminal[3].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(3, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                              //Timer text
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[4].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[4].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(4, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[4].playButtonColor,
                              child: terminal[4].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(4, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                              //Timer text
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
                    Stack(
                      children: [
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
                        //Play/Pause button
                        Visibility(
                          visible: terminal[5].playButtonVisible,
                          child: InkWell(
                            splashColor: terminal[5].playButtonColor,
                            onLongPress: () {
                              pressPlayButton(5, "long");
                            },
                            child: FloatingActionButton(
                              backgroundColor: terminal[5].playButtonColor,
                              child: terminal[5].playButtonIcon,
                              onPressed: () {
                                pressPlayButton(5, "short");
                                log("play button pressed");
                              },
                            ),
                          ),
                        ),
                      ],
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
                              //Timer text
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
            child: Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Visibility(
                    visible: ticketButtonsVisible,
                    child: InkWell(
                      splashColor: Colors.white,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontFamily: 'Montserrat-SemiBold',
                            color: lightGrey,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          pressTicketButton("minus");
                        },
                      ),
                    ),
                  ),
                ),
                Draggable(
                  data: 1,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: orange,
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
                    backgroundColor: orange,
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
                  onDragStarted: () {
                    setState(() {
                      ticketButtonsVisible = false;
                    });
                  },
                  onDragCompleted: () {
                    setState(() {
                      ticketButtonsVisible = true;
                    });
                  },
                  onDragEnd: (data) {
                    setState(() {
                      ticketButtonsVisible = true;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Visibility(
                    visible: ticketButtonsVisible,
                    child: InkWell(
                      splashColor: Colors.white,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontFamily: 'Montserrat-SemiBold',
                            color: lightGrey,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          pressTicketButton("plus");
                        },
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
