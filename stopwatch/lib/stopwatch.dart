import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var isPlaying = false;
  String time = '00:00';
  Timer timing;

  void _startClock(DateTime received) {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying == false) {
      stopClock();
      return;
    }

    const duration = const Duration(seconds: 1);
    timing = Timer.periodic(duration, (Timer t) => _getTime(received));
  }

  void _getTime(DateTime received) {
    final DateTime now = DateTime.now();

    int difference = now.difference(received).inSeconds;

    DateTime data = DateTime.utc(2000, 1, 0, 0, 0, difference);

    String form = _formatDateTime(data);
    print('data: $form');

    setState(() {
      time = form;
    });

    // time = difference.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    // return DateFormat('hh:mm:ss').format(dateTime);
    return DateFormat('mm:ss').format(dateTime);
  }

  void stopClock() {
    timing.cancel();
  }

  void restartClock() {
    setState(() {
      time = "00:00";
      isPlaying = false;
    });
    timing.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Stopwatch'),
        ),
        body: Center(
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.8,
            color: Colors.green[200],
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Time $time'),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.replay),
                        onPressed: () {
                          restartClock();
                        },
                      ),
                      IconButton(
                        icon: isPlaying == true
                            ? Icon(Icons.pause_circle_outline)
                            : Icon(Icons.play_circle_outline),
                        onPressed: () {
                          _startClock(DateTime.now());
                          // initState();
                        },
                      ),
                    ])
              ],
            ),
          ),
        ));
  }
}
