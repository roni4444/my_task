import 'package:flutter/material.dart';

class HolidayWidget extends StatelessWidget {
  final DateTime day;
  const HolidayWidget({Key key, @required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Text(
          day.day.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              fontFamily: 'LibreBaskerville'),
        ),
      ),
    );
  }
}
