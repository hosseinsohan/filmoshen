import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String text;
  final String pic;
  EmptyPage({this.text, this.pic});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: Column(
          children: <Widget>[
            Image.asset(pic, height: 100,),
            SizedBox(height: 20,),
            ListTile(title: Text(text, style: TextStyle(fontSize: 14), strutStyle: StrutStyle(height: 2),))
          ],
        ),
      
    );
  }
}