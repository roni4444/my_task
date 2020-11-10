import 'package:flutter/material.dart';

class TaskDotWidget extends StatelessWidget {
  final Color colour;
  const TaskDotWidget({Key key, @required this.colour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      color: colour,
      height: 5.0,
      width: 5.0,
    );
  }
}
