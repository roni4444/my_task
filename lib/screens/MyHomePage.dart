import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_task/components/HolidayWidget.dart';
import 'package:my_task/components/TaskDotWidget.dart';
import 'package:my_task/components/TaskListWidget.dart';
import 'package:my_task/screens/AddTaskScreen.dart';
import 'package:timezone/data/latest.dart' as ltz;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EventList<Event> _markedDateMap = new EventList<Event>();
  List<Widget> taskList = [];

  /* static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2021, 2, 10): [
        new Event(
          date: new DateTime(2021, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: TaskDotWidget(colour: Colors.red),
        ),
        new Event(
          date: new DateTime(2021, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2021, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );
*/
  DateTime _currentDate = new DateTime(new DateTime.now().year,
      new DateTime.now().month, new DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Task"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  setState(() {
                    _currentDate = date;
                    taskList.clear();
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    firestore
                        .collection("My Task")
                        .doc("App")
                        .collection("Task")
                        .where('DateTime',
                            isLessThan:
                                Timestamp.fromDate(date.add(Duration(days: 1))))
                        .where('DateTime',
                            isGreaterThan: Timestamp.fromDate(
                                date.subtract(Duration(microseconds: 1))))
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                              if (querySnapshot.docs.isNotEmpty)
                                {
                                  querySnapshot.docs.forEach((doc) {
                                    String priority = doc['Priority'];
                                    Timestamp doctime = doc['DateTime'];
                                    DateTime datetime = doctime.toDate();
                                    //DateTime time = DateTime(datetime.hour,datetime.minute, datetime.second);
                                    if (priority.compareTo('High') == 0) {
                                      setState(() {
                                        taskList.add(
                                          TaskListWidget(
                                            colour: Colors.red,
                                            name: doc['Name'],
                                            time: datetime.hour.toString() +
                                                ":" +
                                                datetime.minute.toString(),
                                          ),
                                        );
                                      });
                                    } else if (priority.compareTo('Low') == 0) {
                                      setState(() {
                                        taskList.add(
                                          TaskListWidget(
                                            colour: Colors.blue,
                                            name: doc['Name'],
                                            time: datetime.hour.toString() +
                                                ":" +
                                                datetime.minute.toString(),
                                          ),
                                        );
                                      });
                                    }
                                  })
                                }
                            });
                    firestore
                        .collection("My Task")
                        .doc("App")
                        .collection("Task")
                        .where('FromDateTime',
                            isLessThan:
                                Timestamp.fromDate(date.add(Duration(days: 1))))
                        .where('FromDateTime',
                            isGreaterThan: Timestamp.fromDate(
                                date.subtract(Duration(microseconds: 1))))
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                              if (querySnapshot.docs.isNotEmpty)
                                {
                                  querySnapshot.docs.forEach((doc) {
                                    String priority = doc['Priority'];
                                    Timestamp doctime = doc['FromDateTime'];
                                    DateTime datetime = doctime.toDate();
                                    //DateTime time = DateTime(datetime.hour,datetime.minute, datetime.second);
                                    if (priority.compareTo('High') == 0) {
                                      setState(() {
                                        taskList.add(
                                          TaskListWidget(
                                            colour: Colors.red,
                                            name: doc['Name'],
                                            time: datetime.hour.toString() +
                                                ":" +
                                                datetime.minute.toString(),
                                          ),
                                        );
                                      });
                                    } else if (priority.compareTo('Low') == 0) {
                                      setState(() {
                                        taskList.add(
                                          TaskListWidget(
                                            colour: Colors.blue,
                                            name: doc['Name'],
                                            time: datetime.hour.toString() +
                                                ":" +
                                                datetime.minute.toString(),
                                          ),
                                        );
                                      });
                                    }
                                  })
                                }
                            });
                  });
                },
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                thisMonthDayBorderColor: Colors.grey,
                customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                ) {
                  for (int i = 0; i < 10; i++) {
                    switch (day.month) {
                      case 1:
                        if (day.day == 1) {
                          return HolidayWidget(day: day);
                        } else if (day.day == 23) {
                          return HolidayWidget(day: day);
                        } else if (day.day == 26) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 4:
                        if (day.day == 14) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 5:
                        if (day.day == 1) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 8:
                        if (day.day == 15) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 9:
                        if (day.day == 5) {
                          return HolidayWidget(day: day);
                        } else if (day.day == 17) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 10:
                        if (day.day == 2) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      case 12:
                        if (day.day == 25) {
                          return HolidayWidget(day: day);
                        }
                        break;
                      default:
                        return null;
                        break;
                    }
                  }
                  /*
                  if (day.day == 15) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Icon(
                                Icons.local_airport,
                                color: Colors.black,
                              ),
                              top: 1.0,
                              left: 1.0,
                            ),
                            Positioned(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(color: Colors.red),
                              ),
                              bottom: 1.0,
                              right: 1.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }*/
                  return null;
                },
                weekFormat: false,
                markedDatesMap: _markedDateMap,
                height: 420.0,
                selectedDateTime: _currentDate,
                daysHaveCircularBorder: false,

                /// null for not rendering any border, true for circular border, false for rectangular border
              ),
              Column(children: taskList),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
        },
        tooltip: 'Add Task',
        backgroundColor: Colors.red,
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    ltz.initializeTimeZones();
    super.initState();
    getTaskForCalendar();
    //setNewAlarm();
    //showNotification();
  }

  void showNotification() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
    //tz.setLocalLocation(tz.);
    //tz.TZDateTime schdate = tz.TZDateTime.local(2020);
    //flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, schdate, notificationDetails, uiLocalNotificationDateInterpretation: null, androidAllowWhileIdle: null)
  }

  void addMarkedDateMap(
      {String priority, DocumentSnapshot doc, DateTime date}) {
    if (priority.compareTo('High') == 0) {
      setState(() {
        _markedDateMap.add(
          date,
          Event(
            title: doc['Name'],
            date: date,
            dot: TaskDotWidget(colour: Colors.red),
          ),
        );
      });
    } else if (priority.compareTo('Low') == 0) {
      setState(() {
        _markedDateMap.add(
          date,
          Event(
            title: doc['Name'],
            date: date,
            dot: TaskDotWidget(colour: Colors.blue),
          ),
        );
      });
    }
  }

  void getTaskForCalendar() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("My Task")
        .doc("App")
        .collection("Task")
        .orderBy("DateTime", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    String priority = doc['Priority'];
                    String type = doc['Type'];
                    if (type.compareTo("Single day") == 0) {
                      Timestamp time = doc['DateTime'];
                      DateTime datetime = time.toDate();
                      DateTime date =
                          DateTime(datetime.year, datetime.month, datetime.day);
                      addMarkedDateMap(
                          priority: priority, doc: doc, date: date);
                      /*if (repeat.compareTo("Daily") == 0) {
                    j = 0;
                    k = 0;
                    for (int i = 1; i <= 365; i++) {
                      DateTime newDate =
                          DateTime(date.year + k, date.month + j, date.day + i);
                      if (newDate.month == 1 ||
                          newDate.month == 3 ||
                          newDate.month == 5 ||
                          newDate.month == 7 ||
                          newDate.month == 8 ||
                          newDate.month == 10 && newDate.day == 31) {
                        j++;
                      } else if (newDate.month == 4 ||
                          newDate.month == 6 ||
                          newDate.month == 9 ||
                          newDate.month == 11 && newDate.day == 30) {
                        j++;
                      } else if (((newDate.year % 4 == 0) &&
                              (newDate.year % 100 != 0)) ||
                          (newDate.year % 400 == 0)) {
                        if (newDate.month == 2 && newDate.day == 29) {
                          j++;
                        } else if (newDate.month == 2 && newDate.day == 29) {
                          j++;
                        }
                      } else if (newDate.month == 12 && newDate.day == 31) {
                        j++;
                        k++;
                      }
                      addMarkedDateMap(
                          priority: priority, doc: doc, date: newDate);
                    }
                  } else if (repeat.compareTo("Alternate Day") == 0) {
                    j = 0;
                    k = 0;
                    for (int i = 1; i <= 365; i++) {
                      if (i % 2 == 0) {
                        DateTime newDate =
                            DateTime(date.year, date.month, date.day + i);
                        if (newDate.month == 1 ||
                            newDate.month == 3 ||
                            newDate.month == 5 ||
                            newDate.month == 7 ||
                            newDate.month == 8 ||
                            newDate.month == 10 && newDate.day == 31) {
                          j++;
                        } else if (newDate.month == 4 ||
                            newDate.month == 6 ||
                            newDate.month == 9 ||
                            newDate.month == 11 && newDate.day == 30) {
                          j++;
                        } else if (((newDate.year % 4 == 0) &&
                                (newDate.year % 100 != 0)) ||
                            (newDate.year % 400 == 0)) {
                          if (newDate.month == 2 && newDate.day == 29) {
                            j++;
                          } else if (newDate.month == 2 && newDate.day == 29) {
                            j++;
                          }
                        } else if (newDate.month == 12 && newDate.day == 31) {
                          j++;
                          k++;
                        }
                        addMarkedDateMap(
                            priority: priority, doc: doc, date: newDate);
                      }
                    }
                  } else if (repeat.compareTo("Weekly") == 0) {
                    j = 0;
                    k = 0;
                    for (int i = 1; i <= 365; i++) {
                      if (i % 7 == 0) {
                        DateTime newDate =
                            DateTime(date.year, date.month, date.day + i);
                        if (newDate.month == 1 ||
                            newDate.month == 3 ||
                            newDate.month == 5 ||
                            newDate.month == 7 ||
                            newDate.month == 8 ||
                            newDate.month == 10 && newDate.day == 31) {
                          j++;
                        } else if (newDate.month == 4 ||
                            newDate.month == 6 ||
                            newDate.month == 9 ||
                            newDate.month == 11 && newDate.day == 30) {
                          j++;
                        } else if (((newDate.year % 4 == 0) &&
                                (newDate.year % 100 != 0)) ||
                            (newDate.year % 400 == 0)) {
                          if (newDate.month == 2 && newDate.day == 29) {
                            j++;
                          } else if (newDate.month == 2 && newDate.day == 29) {
                            j++;
                          }
                        } else if (newDate.month == 12 && newDate.day == 31) {
                          j++;
                          k++;
                        }
                        addMarkedDateMap(
                            priority: priority, doc: doc, date: newDate);
                      }
                    }
                  } else if (repeat.compareTo("Monthly") == 0) {
                    j = 0;
                    for (int i = 1; i <= 12; i++) {
                      DateTime newDate =
                          DateTime(date.year + j, date.month + i, date.day);
                      if (newDate.month == 12) {
                        j++;
                      }
                      addMarkedDateMap(
                          priority: priority, doc: doc, date: newDate);
                    }
                  }*/
                    } else if (type.compareTo("Multi-day") == 0) {
                      Timestamp time1 = doc['FromDateTime'];
                      DateTime datetime1 = time1.toDate();
                      DateTime date1 = DateTime(
                          datetime1.year, datetime1.month, datetime1.day);
                      Timestamp time2 = doc['ToDateTime'];
                      DateTime datetime2 = time2.toDate();
                      DateTime date2 = DateTime(
                          datetime2.year, datetime2.month, datetime2.day);
                      Duration diff = date1.difference(date2);
                      int diffInDays = diff.inDays;
                      for (int i = 0; i < diffInDays; i++) {
                        addMarkedDateMap(
                            priority: priority, doc: doc, date: date1);
                        date1.add(Duration(days: 1));
                      }
                    }
                  })
                }
            });
  }

  void setNewAlarm() {
    DateTime _currentDate = new DateTime(new DateTime.now().year,
        new DateTime.now().month, new DateTime.now().day);
    DateTime tillDate =
        DateTime(_currentDate.year, _currentDate.month + 1, _currentDate.day);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("My Task")
        .doc("App")
        .collection("Task")
        .where('DateTime', isLessThan: Timestamp.fromDate(tillDate))
        .where('DateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(_currentDate))
        .where('AlarmAssigned', isEqualTo: false)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            if (querySnapshot.docs.isNotEmpty)
              {
                querySnapshot.docs.forEach(
                  (doc) {
                    int alarmId = Random().nextInt(pow(2, 31));
                    //Timestamp time = doc['DateTime'];
                    //DateTime datetime = time.toDate();
                    //DateTime alarmTime = DateTime(
                    //    datetime.hour, datetime.minute, datetime.second);

                    print('Alarm Set ' + alarmId.toString());
                    firestore
                        .collection("My Task")
                        .doc("App")
                        .collection("Task")
                        .doc(doc.id)
                        .update({'AlarmAssigned': true, 'AlarmID': alarmId});
                  },
                )
              },
          },
        );
  }

  Future selectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    return null;
  }
}
