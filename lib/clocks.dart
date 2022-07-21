import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:overclock/main.dart';

class name extends StatefulWidget {
  name({Key? key}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
  Color red = Colors.red;

  var terminal = [
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
    Terminal(),
  ];

  void startTimer(int n) {
    const oneSec = Duration(seconds: 1);
    terminal[n].timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        //On timer reaching 0 or beyond
        if (terminal[n].curTime <= 0) {
          terminal[n].slotImage = 'assets/ui/empty_slot_end.svg';
          resetTerminal(n, "timeout");
          //Timer ticking
        } else {
          if (terminal[n].ticking && !terminal[n].playButtonPaused) {
            //Must be set every time timer ticks to stop duplication
            terminal[n].vacancyState = false;
            terminal[n].minutes = (terminal[n].curTime / 60).floor();
            terminal[n].seconds = terminal[n].curTime % 60;
            //Add a '0' to the beginning if number less than two digits
            if (terminal[n].minutes < 10) {
              terminal[n].minutesParsed = "0" + terminal[n].minutes.toString();
            } else {
              terminal[n].minutesParsed = terminal[n].minutes.toString();
            }
            if (terminal[n].seconds < 10) {
              terminal[n].secondsParsed = "0" + terminal[n].seconds.toString();
            } else {
              terminal[n].secondsParsed = terminal[n].seconds.toString();
            }
            //Finalise timer display
            terminal[n].totalTimeParsed =
                terminal[n].minutesParsed + ":" + terminal[n].secondsParsed;
            setState(() {
              terminal[n].curTime--;
            });
          }
        }
      },
    );
  }

  void resetTimer(int n, String type) {
    terminal[n].curTime = terminal[n].startTime;
    terminal[n].totalTimeParsed = "00:00";
    setState(() {
      terminal[n].timer?.cancel();
    });
    switch (type) {
      case "reset":
        {
          terminal[n].textColor = lightGrey;
        }
        break;
      case "timeout":
        {
          terminal[n].textColor = red;
        }
        break;
    }
  }

  void resetTerminal(int n, String type) {
    switch (type) {
      case "reset":
        {
          resetTimer(n, type);
          changePlayButtonState(n, "off");
          terminal[n].vacancyState = true;
          terminal[n].ticking = false;
        }
        break;
      case "timeout":
        {
          resetTimer(n, type);
          changePlayButtonState(n, "finished");
          terminal[n].ticking = false;
        }
        break;
    }
  }

  //Set icons, visibility etc. below when play button state is changed
  void changePlayButtonState(int n, String state) {
    switch (state) {
      case "play":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_dark.svg';
          terminal[n].playButtonIcon = Icon(Icons.play_arrow);
          terminal[n].playButtonColor = darkGrey;
          terminal[n].playButtonVisible = true;
        }
        break;
      case "pause":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_dark.svg';
          terminal[n].playButtonIcon = Icon(Icons.stop);
          terminal[n].playButtonColor = darkGrey;
        }
        break;
      case "finished":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_end.svg';
          terminal[n].playButtonIcon = Icon(Icons.close);
          terminal[n].playButtonColor = red;
        }
        break;
      case "off":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_light.svg';
          terminal[n].playButtonVisible = false;
        }
        break;
    }
    terminal[n].playButtonState = state;
  }

  //Check if terminal is vacant, if so then perform actions
  void checkForVacancy(int n) {
    if (terminal[n].vacancyState == true) {
      terminal[n].textColor = darkGrey;
      terminal[n].totalTimeParsed = "10:00";
      changePlayButtonState(n, "play");
      ticketNumber++;
      ticketNumberParsed = ticketNumber.toString();
      setState(() {
        terminal[n].vacancyState == false;
      });
    }
  }

  //Functionality for what happens when the button is pressed depending on state
  void pressPlayButton(int n, String pressType) {
    if (terminal[n].playButtonState == "play" && !terminal[n].ticking) {
      //If play button short pressed
      if (pressType == "short") {
        if (!terminal[0].playButtonPaused) {
          startTimer(n);
        }
        changePlayButtonState(n, "pause");
        terminal[n].ticking = true;
        //If play button long pressed
      } else if (pressType == "long") {
        ticketNumber--;
        setState(() {
          ticketNumberParsed = ticketNumber.toString();
        });
        resetTerminal(n, "reset");
      }
    } else if (terminal[n].playButtonState == "pause" ||
        terminal[n].playButtonState == "finished") {
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
        resetTerminal(n, "reset");
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

  void changeOutline(int n, String state) {
    switch (state) {
      case "light":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_light';
        }
        break;
      case "dark":
        {
          terminal[n].outlineImage = 'assets/ui/terminal_outline_dark';
        }
        break;
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
                    //Call to action
                    Stack(
                      children: [
                        Column(
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 15),
                                          ),
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
                                      //Timer text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(27),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 350.0),
                            ),
                          ],
                        ),
                        //Outline
                        RotatedBox(
                          quarterTurns: 2,
                          child: SizedBox(
                            height: 168,
                            width: 56,
                            child: Visibility(
                              visible: terminal[0].outlineVisible,
                              child: SvgPicture.asset(
                                terminal[0].outlineImage,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 110)),
                            Stack(
                              children: [
                                //Empty slot
                                DragTarget(
                                  builder: (context, data, rejectedDate) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 0.0),
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
                                  //onWillAccept: (data) => changeOutline(0, "dark"),
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
                                      backgroundColor:
                                          terminal[0].playButtonColor,
                                      child: terminal[0].playButtonIcon,
                                      onPressed: () {
                                        pressPlayButton(0, "short");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Call to action
                    Stack(
                      children: [
                        Column(
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 15),
                                          ),
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
                                      //Timer text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(27),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 350.0),
                            ),
                          ],
                        ),
                        //Outline
                        RotatedBox(
                          quarterTurns: 2,
                          child: SizedBox(
                            height: 168,
                            width: 56,
                            child: Visibility(
                              visible: terminal[1].outlineVisible,
                              child: SvgPicture.asset(
                                terminal[1].outlineImage,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 110)),
                            Stack(
                              children: [
                                //Empty slot
                                DragTarget(
                                  builder: (context, data, rejectedDate) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 0.0),
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
                                      backgroundColor:
                                          terminal[1].playButtonColor,
                                      child: terminal[1].playButtonIcon,
                                      onPressed: () {
                                        pressPlayButton(1, "short");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                        SizedBox(
                          height: 168,
                          width: 56,
                          child: Visibility(
                            visible: terminal[2].outlineVisible,
                            child: SvgPicture.asset(
                              terminal[2].outlineImage,
                            ),
                          ),
                        ),
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
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(27),
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
                        SizedBox(
                          height: 168,
                          width: 56,
                          child: Visibility(
                            visible: terminal[3].outlineVisible,
                            child: SvgPicture.asset(
                              terminal[3].outlineImage,
                            ),
                          ),
                        ),
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
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(27),
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        SizedBox(
                          height: 168,
                          width: 56,
                          child: Visibility(
                            visible: terminal[4].outlineVisible,
                            child: SvgPicture.asset(
                              terminal[4].outlineImage,
                            ),
                          ),
                        ),
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
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(27),
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 300.0),
                    ),
                    //Call to action
                    Stack(
                      children: [
                        SizedBox(
                          height: 168,
                          width: 56,
                          child: Visibility(
                            visible: terminal[5].outlineVisible,
                            child: SvgPicture.asset(
                              terminal[5].outlineImage,
                            ),
                          ),
                        ),
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
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(27),
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
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        mini: true,
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
                        mini: true,
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
