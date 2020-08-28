import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isPlaying = false;
  String time = '00:00';
  Timer timing;
  DateTime data, original;
  Duration sec = Duration(seconds: 0);

  void _startClock(DateTime received) {
    setState(() {
      // Switches the icon from 'play' to 'pause'
      isPlaying = !isPlaying;
    });

    // If the clock was playing and it was just reversed, we need to stop the clock
    if (isPlaying == false) {
      stopClock(original);
      return;
    }

    // Starting a timer with a constant duration of 1 second
    const duration = const Duration(seconds: 1);
    timing = Timer.periodic(duration, (Timer t) => _getTime(received));
  }

  void _getTime(DateTime received) {
    // Keeping track of the time the play/pause button was clicked
    original = received;

    int segundosPausados = sec.inSeconds;

    final DateTime now = DateTime.now();

    int seconds = now.difference(received).inSeconds + segundosPausados;

    // Creating a new Date to use the format function
    data = DateTime.utc(2000, 1, 0, 0, 0, seconds);

    String form = _formatDateTime(data);
    print('data: $form');

    setState(() {
      time = form;
    });

    // time = seconds.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    int minutes = now.difference(original).inMinutes;
    print(minutes);

    if (minutes > 59) return DateFormat('hh:mm:ss').format(dateTime);

    return DateFormat('mm:ss').format(dateTime);
  }

  void stopClock(DateTime original) {
    final DateTime now = DateTime.now();
    // Keeping track of the amount of seconds there were when the clock was paused
    int seconds = now.difference(original).inSeconds;

    int prev = seconds + sec.inSeconds;

    setState(() {
      sec = Duration(seconds: prev);
    });

    print(seconds);
    print(prev);

    // Stopping the timer
    timing.cancel();
  }

  void restartClock() {
    setState(() {
      time = "00:00";
      isPlaying = false;
      sec = Duration(seconds: 0);
    });
    timing.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Stopwatch'),
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: AssetImage('assets/galaxy.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$time',
                    style: TextStyle(fontSize: 60, color: Colors.white)),
                SizedBox(
                  height: 50.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton.icon(
                        label: Text(
                          'RESTART',
                          style: GoogleFonts.raleway(
                              color: Colors.grey[300],
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        icon: Icon(
                          Icons.replay,
                          color: Colors.grey[300],
                          size: 26,
                        ),
                        onPressed: () {
                          restartClock();
                        },
                        splashColor: Colors.blue[900],
                        highlightedBorderColor: Colors.blue[900],
                        borderSide: BorderSide(
                          color: Colors.grey[300],
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      OutlineButton.icon(
                        label: Text(
                          isPlaying == false ? 'PLAY' : 'PAUSE',
                          style: GoogleFonts.raleway(
                              color: Colors.grey[300],
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        icon: isPlaying == true
                            ? Icon(
                                Icons.pause_circle_outline,
                                color: Colors.grey[300],
                                size: 26,
                              )
                            : Icon(
                                Icons.play_circle_outline,
                                color: Colors.grey[300],
                                size: 26,
                              ),
                        onPressed: () {
                          _startClock(DateTime.now());
                        },
                        splashColor: Colors.blue[900],
                        highlightedBorderColor: Colors.blue[900],
                        borderSide: BorderSide(
                          color: Colors.grey[300],
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0),
                      ),
                    ])
              ],
            ),
          ),
        ));
  }
}
