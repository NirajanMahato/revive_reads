import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final Function onShake;
  final double shakeThreshold;

  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  DateTime? _lastShake;

  ShakeDetector({
    required this.onShake,
    this.shakeThreshold = 3.0,
  });

  void startListening() {
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      // Calculate acceleration vector magnitude
      double acceleration = sqrt(x * x + y * y + z * z) - 9.8;

      DateTime now = DateTime.now();

      if (_lastShake == null ||
          now.difference(_lastShake!) > Duration(milliseconds: 1000)) {
        if (acceleration > shakeThreshold) {
          _lastShake = now;
          onShake();
        }
      }
    });
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
