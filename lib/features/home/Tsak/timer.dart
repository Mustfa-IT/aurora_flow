import 'dart:async';

import 'package:flutter/material.dart';

class TimerController {
  // Use a ValueNotifier to update the elapsed seconds.
  final ValueNotifier<int> elapsedSeconds;
  Timer? _timer;
  bool isRunning = false;

  TimerController({int initialSeconds = 0})
      : elapsedSeconds = ValueNotifier<int>(initialSeconds);

  void start() {
    if (!isRunning) {
      isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        elapsedSeconds.value++;
      });
    }
  }

  void stop() {
    if (isRunning) {
      isRunning = false;
      _timer?.cancel();
    }
  }

  void toggle() {
    if (isRunning) {
      stop();
    } else {
      start();
    }
  }

  /// Returns the formatted time in hh:mm:ss with leading zeros.
  String get formattedTime {
    int totalSeconds = elapsedSeconds.value;
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void dispose() {
    _timer?.cancel();
    elapsedSeconds.dispose();
  }
}
