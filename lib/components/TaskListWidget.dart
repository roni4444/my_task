import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final Color colour;
  final String name;
  final String time;
  const TaskListWidget(
      {Key key,
      @required this.colour,
      @required this.name,
      @required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: colour, width: 4.0, style: BorderStyle.solid),
      ),
      child: ListTile(
        title: Text(name),
        trailing: Text(time),
      ),
    );
  }
}
