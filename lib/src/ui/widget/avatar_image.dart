import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget prifileImage(BuildContext context) {
  return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.0),
          color: bgdeepColor),
      child: Icon(
        Icons.person,
        color: yellowColor,
      )
      );
}
