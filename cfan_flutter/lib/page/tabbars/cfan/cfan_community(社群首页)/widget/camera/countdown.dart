import 'dart:async';

import 'package:flutter/material.dart';

/// 倒计时
class Countdown extends StatefulWidget {
  final Duration time;
  final Function callback;
  const Countdown({
    super.key,
    required this.time,
    required this.callback,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Duration _currentTime;
  late final Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTime = widget.time;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final newTime = _currentTime - const Duration(seconds: 1);
      if (newTime == Duration.zero) {
        widget.callback();
        _timer.cancel();
      } else {
        setState(() {
          _currentTime = newTime;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_currentTime.inSeconds}s',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
      ),
    );
  }
}
