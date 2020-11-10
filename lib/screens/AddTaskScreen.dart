import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'MyHomePage.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  int radio = 1;
  int j = 0, k = 0;
  List<Widget> _datepickerlist = [];
  bool switchvalue = false;
  String repeatvalue = "No repeat";
  bool norepeatchecked = false;
  bool dailychecked = false;
  bool monthlychecked = false;
  bool weeklychecked = false;
  bool interleaveddaychecked = false;

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(DateTime.now().year, 1),
      lastDate: DateTime(9999),
    );
    if (picked != null && picked != today) {
      setState(() {
        today = picked;
        _datepickerlist.removeAt(1);
        _datepickerlist.insert(
            1,
            Flexible(
              flex: 3,
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  DateFormat.yMMMd().format(today),
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  _showDatePicker();
                },
                tileColor: Colors.white70,
              ),
            ));
      });
    }
  }

  Future<void> _showNextDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(DateTime.now().year, 1),
      lastDate: DateTime(9999),
    );
    if (picked != null && picked != today) {
      setState(() {
        tomorrow = picked;
        _datepickerlist.removeAt(3);
        _datepickerlist.insert(
            3,
            Flexible(
              flex: 3,
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  DateFormat.yMMMd().format(tomorrow),
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  _showNextDatePicker();
                },
                tileColor: Colors.white70,
              ),
            ));
      });
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Task"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 2, 5),
                    child: Text(
                      "Enter Task Name : ",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      hintText: 'Enter task name here',
                      border: const OutlineInputBorder(),
                      labelText: 'Task Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter task name';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: radio,
                        onChanged: (int value) {
                          setState(() {
                            radio = value;
                            _datepickerlist.clear();
                            _datepickerlist.add(
                              Flexible(
                                flex: 1,
                                child: Text(
                                  "On : ",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            );
                            _datepickerlist.add(Flexible(
                              flex: 3,
                              child: ListTile(
                                leading: Icon(Icons.event),
                                title: Text(
                                  DateFormat.yMMMd().format(today),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  _showDatePicker();
                                },
                                tileColor: Colors.white70,
                              ),
                            ));
                          });
                        },
                      ),
                      Text(
                        "Single day event",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Radio(
                        value: 2,
                        groupValue: radio,
                        onChanged: (int value) {
                          setState(() {
                            radio = value;
                            _datepickerlist.clear();
                            _datepickerlist.add(
                              Flexible(
                                flex: 1,
                                child: Text(
                                  "From : ",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            );
                            _datepickerlist.add(Flexible(
                              flex: 3,
                              child: ListTile(
                                leading: Icon(Icons.event),
                                title: Text(
                                  DateFormat.yMMMd().format(today),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  _showDatePicker();
                                },
                                tileColor: Colors.white70,
                              ),
                            ));
                            _datepickerlist.add(
                              Flexible(
                                flex: 1,
                                child: Text(
                                  "To : ",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            );
                            _datepickerlist.add(Flexible(
                              flex: 3,
                              child: ListTile(
                                leading: Icon(Icons.event),
                                title: Text(
                                  DateFormat.yMMMd().format(tomorrow),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  _showNextDatePicker();
                                },
                                tileColor: Colors.white70,
                              ),
                            ));
                          });
                        },
                      ),
                      Text(
                        "Multi-day event",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _datepickerlist,
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          "At : ",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: ListTile(
                          leading: Icon(Icons.timer),
                          title: Text(
                            _fromTime.format(context),
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            _showTimePicker();
                          },
                          tileColor: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Priority: ",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(width: 25.0),
                      Text(
                        "Low ",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Switch(
                        onChanged: (value) {
                          setState(() {
                            switchvalue = value;
                            if (switchvalue) {}
                          });
                        },
                        value: switchvalue,
                      ),
                      Text("High"),
                    ],
                  ),
                ),
                /*
                PopupMenuButton(
                  padding: EdgeInsets.all(0.0),
                  initialValue: Text("Select Color"),
                  child: ListTile(
                    title: Text("Select Color"),
                    subtitle: Text("White"),
                  ),
                  itemBuilder: (context) => <PopupMenuItem>[],
                ),
                */
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text("Repeat : "),
                      ),
                      Flexible(
                        flex: 3,
                        child: PopupMenuButton(
                          padding: EdgeInsets.all(0.0),
                          child: ListTile(
                            title: Text(repeatvalue),
                            trailing: Icon(Icons.keyboard_arrow_down),
                          ),
                          initialValue: repeatvalue,
                          onSelected: (value) {
                            if (value == 0) {
                              setState(() {
                                norepeatchecked = true;
                                dailychecked = false;
                                weeklychecked = false;
                                interleaveddaychecked = false;
                                monthlychecked = false;
                                repeatvalue = "No Repeat";
                              });
                            } else if (value == 1) {
                              setState(() {
                                norepeatchecked = false;
                                dailychecked = true;
                                weeklychecked = false;
                                interleaveddaychecked = false;
                                monthlychecked = false;
                                repeatvalue = "Daily";
                              });
                            } else if (value == 2) {
                              setState(() {
                                norepeatchecked = false;
                                dailychecked = false;
                                weeklychecked = false;
                                interleaveddaychecked = true;
                                monthlychecked = false;
                                repeatvalue = "Alternate Day";
                              });
                            } else if (value == 3) {
                              setState(() {
                                norepeatchecked = false;
                                dailychecked = false;
                                weeklychecked = true;
                                interleaveddaychecked = false;
                                monthlychecked = false;
                                repeatvalue = "Weekly";
                              });
                            } else if (value == 4) {
                              setState(() {
                                norepeatchecked = false;
                                dailychecked = false;
                                weeklychecked = false;
                                interleaveddaychecked = false;
                                monthlychecked = true;
                                repeatvalue = "Monthly";
                              });
                            }
                          },
                          itemBuilder: (context) => <PopupMenuItem>[
                            CheckedPopupMenuItem(
                              child: Text("No Repeat"),
                              value: 0,
                              checked: norepeatchecked,
                            ),
                            CheckedPopupMenuItem(
                              child: Text("Daily"),
                              value: 1,
                              checked: dailychecked,
                            ),
                            CheckedPopupMenuItem(
                              child: Text("Alternate Day"),
                              value: 2,
                              checked: interleaveddaychecked,
                            ),
                            CheckedPopupMenuItem(
                              child: Text("Weekly"),
                              value: 3,
                              checked: weeklychecked,
                            ),
                            CheckedPopupMenuItem(
                              child: Text("Monthly"),
                              value: 4,
                              checked: monthlychecked,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (radio == 1) {
                              firestore
                                  .collection("My Task")
                                  .doc("App")
                                  .collection("Task")
                                  .add({
                                    'Name': myController.text,
                                    'Type': "Single day",
                                    'DateTime': DateTime(
                                        today.year,
                                        today.month,
                                        today.day,
                                        _fromTime.hour,
                                        _fromTime.minute),
                                    'Priority': switchvalue ? "High" : "Low",
                                    'Repeat': repeatvalue,
                                    'AlarmAssigned': false,
                                  })
                                  .then((value) => () {
                                        if (repeatvalue.compareTo("Daily") ==
                                            0) {
                                          j = 0;
                                          k = 0;
                                          for (int i = 1; i <= 365; i++) {
                                            DateTime newDate = DateTime(
                                                today.year + k,
                                                today.month + j,
                                                today.day + i);
                                            if (newDate.month == 1 ||
                                                newDate.month == 3 ||
                                                newDate.month == 5 ||
                                                newDate.month == 7 ||
                                                newDate.month == 8 ||
                                                newDate.month == 10 &&
                                                    newDate.day == 31) {
                                              j++;
                                            } else if (newDate.month == 4 ||
                                                newDate.month == 6 ||
                                                newDate.month == 9 ||
                                                newDate.month == 11 &&
                                                    newDate.day == 30) {
                                              j++;
                                            } else if (((newDate.year % 4 ==
                                                        0) &&
                                                    (newDate.year % 100 !=
                                                        0)) ||
                                                (newDate.year % 400 == 0)) {
                                              if (newDate.month == 2 &&
                                                  newDate.day == 29) {
                                                j++;
                                              } else if (newDate.month == 2 &&
                                                  newDate.day == 29) {
                                                j++;
                                              }
                                            } else if (newDate.month == 12 &&
                                                newDate.day == 31) {
                                              j++;
                                              k++;
                                            }
                                            firestore
                                                .collection("My Task")
                                                .doc("App")
                                                .collection("Task")
                                                .add({
                                              'Name': myController.text,
                                              'Type': "Single day",
                                              'DateTime': newDate,
                                              'Priority':
                                                  switchvalue ? "High" : "Low",
                                              'Repeat': repeatvalue,
                                              'AlarmAssigned': false,
                                            });
                                          }
                                        } else if (repeatvalue
                                                .compareTo("Alternate Day") ==
                                            0) {
                                          j = 0;
                                          k = 0;
                                          for (int i = 1; i <= 365; i++) {
                                            if (i % 2 == 0) {
                                              DateTime newDate = DateTime(
                                                  today.year + k,
                                                  today.month + j,
                                                  today.day + i);
                                              if (newDate.month == 1 ||
                                                  newDate.month == 3 ||
                                                  newDate.month == 5 ||
                                                  newDate.month == 7 ||
                                                  newDate.month == 8 ||
                                                  newDate.month == 10 &&
                                                      newDate.day == 31) {
                                                j++;
                                              } else if (newDate.month == 4 ||
                                                  newDate.month == 6 ||
                                                  newDate.month == 9 ||
                                                  newDate.month == 11 &&
                                                      newDate.day == 30) {
                                                j++;
                                              } else if (((newDate.year % 4 ==
                                                          0) &&
                                                      (newDate.year % 100 !=
                                                          0)) ||
                                                  (newDate.year % 400 == 0)) {
                                                if (newDate.month == 2 &&
                                                    newDate.day == 29) {
                                                  j++;
                                                } else if (newDate.month == 2 &&
                                                    newDate.day == 29) {
                                                  j++;
                                                }
                                              } else if (newDate.month == 12 &&
                                                  newDate.day == 31) {
                                                j++;
                                                k++;
                                              }
                                              firestore
                                                  .collection("My Task")
                                                  .doc("App")
                                                  .collection("Task")
                                                  .add({
                                                'Name': myController.text,
                                                'Type': "Single day",
                                                'DateTime': newDate,
                                                'Priority': switchvalue
                                                    ? "High"
                                                    : "Low",
                                                'Repeat': repeatvalue,
                                                'AlarmAssigned': false,
                                              });
                                            }
                                          }
                                        } else if (repeatvalue
                                                .compareTo("Weekly") ==
                                            0) {
                                          j = 0;
                                          k = 0;
                                          for (int i = 1; i <= 365; i++) {
                                            if (i % 7 == 0) {
                                              DateTime newDate = DateTime(
                                                  today.year + k,
                                                  today.month + j,
                                                  today.day + i);
                                              if (newDate.month == 1 ||
                                                  newDate.month == 3 ||
                                                  newDate.month == 5 ||
                                                  newDate.month == 7 ||
                                                  newDate.month == 8 ||
                                                  newDate.month == 10 &&
                                                      newDate.day == 31) {
                                                j++;
                                              } else if (newDate.month == 4 ||
                                                  newDate.month == 6 ||
                                                  newDate.month == 9 ||
                                                  newDate.month == 11 &&
                                                      newDate.day == 30) {
                                                j++;
                                              } else if (((newDate.year % 4 ==
                                                          0) &&
                                                      (newDate.year % 100 !=
                                                          0)) ||
                                                  (newDate.year % 400 == 0)) {
                                                if (newDate.month == 2 &&
                                                    newDate.day == 29) {
                                                  j++;
                                                } else if (newDate.month == 2 &&
                                                    newDate.day == 29) {
                                                  j++;
                                                }
                                              } else if (newDate.month == 12 &&
                                                  newDate.day == 31) {
                                                j++;
                                                k++;
                                              }
                                              firestore
                                                  .collection("My Task")
                                                  .doc("App")
                                                  .collection("Task")
                                                  .add({
                                                'Name': myController.text,
                                                'Type': "Single day",
                                                'DateTime': newDate,
                                                'Priority': switchvalue
                                                    ? "High"
                                                    : "Low",
                                                'Repeat': repeatvalue,
                                                'AlarmAssigned': false,
                                              });
                                            }
                                          }
                                        } else if (repeatvalue
                                                .compareTo("Monthly") ==
                                            0) {
                                          j = 0;
                                          for (int i = 1; i <= 12; i++) {
                                            DateTime newDate = DateTime(
                                                today.year + j,
                                                today.month + i,
                                                today.day);
                                            if (newDate.month == 12) {
                                              j++;
                                            } else if (newDate.day == 29 &&
                                                newDate.month == 2) {
                                              newDate = DateTime(newDate.year,
                                                  newDate.month, 28);
                                            } else if (newDate.day == 30 &&
                                                newDate.month == 2) {
                                              newDate = DateTime(newDate.year,
                                                  newDate.month, 28);
                                            } else if (newDate.day == 31 &&
                                                newDate.month == 2) {
                                              newDate = DateTime(newDate.year,
                                                  newDate.month, 28);
                                            } else if (newDate.day == 31 &&
                                                (newDate.month == 4 ||
                                                    newDate.month == 6 ||
                                                    newDate.month == 9 ||
                                                    newDate.month == 11)) {
                                              newDate = DateTime(newDate.year,
                                                  newDate.month, 30);
                                            } else
                                              firestore
                                                  .collection("My Task")
                                                  .doc("App")
                                                  .collection("Task")
                                                  .add({
                                                'Name': myController.text,
                                                'Type': "Single day",
                                                'DateTime': newDate,
                                                'Priority': switchvalue
                                                    ? "High"
                                                    : "Low",
                                                'Repeat': repeatvalue,
                                                'AlarmAssigned': false,
                                              });
                                          }
                                        }
                                      })
                                  .whenComplete(
                                    () => Navigator.pop(context),
                                  );
                            } else if (radio == 2) {
                              firestore
                                  .collection("My Task")
                                  .doc("App")
                                  .collection("Task")
                                  .add({
                                'Name': myController.text,
                                'Type': "Multi-day",
                                'FromDateTime': DateTime(
                                    today.year,
                                    today.month,
                                    today.day,
                                    _fromTime.hour,
                                    _fromTime.minute),
                                'ToDateTime': DateTime(
                                    tomorrow.year,
                                    tomorrow.month,
                                    tomorrow.day,
                                    _fromTime.hour,
                                    _fromTime.minute),
                                'Priority': switchvalue ? "High" : "Low",
                                'Repeat': repeatvalue,
                                'AlarmAssigned': false,
                              }).whenComplete(
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                ),
                              );
                            }

                            /*Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Processing Data'),
                              ),
                            );*/
                          }
                        },
                        child: Text("Add Task"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _datepickerlist.clear();
      _datepickerlist.add(
        Flexible(
          flex: 1,
          child: Text(
            "On : ",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      );
      _datepickerlist.add(Flexible(
        flex: 3,
        child: ListTile(
          leading: Icon(Icons.event),
          title: Text(
            DateFormat.yMMMd().format(today),
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            _showDatePicker();
          },
          tileColor: Colors.white70,
        ),
      ));
    });
  }
}
