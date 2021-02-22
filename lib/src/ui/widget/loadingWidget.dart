import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

Widget buildLoading(Color color) {
  return Padding(
    padding: const EdgeInsets.only(right: 30),
    child: Loading(color: color,indicator: BallPulseIndicator(), size: 20.0),
  )
      /*Center(
    child: CircularProgressIndicator(),
  )*/
      ;
}
