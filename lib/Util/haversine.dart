import 'dart:math';

import 'package:flutter/material.dart';

class Haversine {
  static const _R = 6372.8;

  static double distancia(
      {@required double lat1,
      @required double lon1,
      @required lat2,
      @required lon2}) {
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return _R * c * 1000;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
