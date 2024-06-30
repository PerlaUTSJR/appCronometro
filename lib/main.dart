import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _count = 0;
  String _strCount = "00:00:00";
  String _status = "Start";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active ? Colors.grey[300] : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cronómetro',
              style: TextStyle(
                fontSize: 17,
                color: widget.mode == WearMode.active ? const Color.fromARGB(255, 204, 79, 241) : const Color.fromARGB(255, 132, 26, 153),
              ),
            ),
            const SizedBox(height: 16.0),
            const Center(
              child: Image(
                image: AssetImage('assets/1.png'),
                width: 50.0,
                height: 50.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  fontSize: 20,
                  color: widget.mode == WearMode.active ? const Color.fromARGB(255, 204, 79, 241) : const Color.fromARGB(255, 132, 26, 153),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer?.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
            child: Icon(
              _status == "Start" || _status == "Continue"
                  ? Icons.play_arrow
                  : Icons.pause,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_timer != null) {
                _timer?.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
            child: const Icon(Icons.stop),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    setState(() {
      _status = "Stop";
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
