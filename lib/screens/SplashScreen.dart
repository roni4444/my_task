import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:timezone/data/latest.dart' as ltz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'MyHomePage.dart';

void callbackDispatcher() {
// this method will be called every hour
  Workmanager.executeTask((task, inputdata) async {
    switch (task) {
      case "registeralarm":
        var _list = inputdata.values.toList();
        var flattenList = _list.expand((number) => number).toList();
        Workmanager.registerOneOffTask(flattenList[1], "setalarm",
            initialDelay: Duration(seconds: flattenList[3]),
            inputData: <String, dynamic>{
              'name': flattenList[5],
              'priority': flattenList[7],
            });
        break;
      case myTask:
        print("this method was called from native!");
        //Fluttertoast.showToast(msg: "this method was called from native!");
        break;

      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
      case alarm:
        FlutterRingtonePlayer.playAlarm(
          //android: AndroidSounds.alarm,
          //ios: IosSounds.alarm,
          looping: true, // Android only - API >= 28
          //volume: 0.1, // Android only - API >= 28
          asAlarm: true, // Android only - all APIs
        );

        Timer(Duration(minutes: 1), () {
          FlutterRingtonePlayer.stop();
        });
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}

String priority;
String name;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const myTask = "syncWithTheBackEnd";
const alarm = "setalarm";

/*
void showNotification(String name, String priority) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
          importance: (priority.compareTo("High") == 0)
              ? Importance.high
              : Importance.low,
          priority:
              (priority.compareTo("High") == 0) ? Priority.high : Priority.low,
          showWhen: false);
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.cancel(0);
  //FlutterRingtonePlayer.stop();
  flutterLocalNotificationsPlugin
      .show(0, 'My Task', name, platformChannelSpecifics, payload: name);
}
*/
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }

  @override
  void initState() {
    super.initState();

    ltz.initializeTimeZones();
    // needs to be initialized before using workmanager package
    WidgetsFlutterBinding.ensureInitialized();

    // initialize Workmanager with the function which you want to invoke after any periodic time
    Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
    //Workmanager.cancelAll();

    if (setNewAlarm()) {
      Timer(
        Duration(seconds: 10),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        ),
      );
    }
  }

  bool setNewAlarm() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false);

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin
        .show(0, 'My Task', "name", platformChannelSpecifics, payload: "name");
    //WidgetsFlutterBinding.ensureInitialized();
    //Workmanager.initialize(callbackDispatcher);
    //DateTime _currentDate = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day);
    //DateTime tillDate = DateTime(_currentDate.year, _currentDate.month + 1, _currentDate.day);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("My Task")
        .doc("App")
        .collection("Task")
        //.where('DateTime', isLessThan: Timestamp.fromDate(tillDate))
        //.where('DateTime',
        //    isGreaterThanOrEqualTo: Timestamp.fromDate(_currentDate))
        .where('AlarmAssigned', isEqualTo: false)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            if (querySnapshot.docs.isNotEmpty)
              {
                querySnapshot.docs.forEach(
                  (doc) {
                    print(doc.id);
                    int alarmId = Random().nextInt(pow(2, 31));
                    Timestamp time = doc['DateTime'];
                    DateTime datetime = time.toDate();
                    Timestamp ts = Timestamp.now();
                    DateTime nowdatetime = ts.toDate();
                    int diff = datetime.difference(nowdatetime).inSeconds;
                    int xdiff = datetime
                        .difference(DateTime(datetime.year, datetime.month,
                            datetime.day, 0, 0, 0))
                        .inSeconds;
                    print(diff);
                    print(xdiff);
                    if (diff > 0) {
                      Workmanager.initialize(callbackDispatcher,
                          isInDebugMode: true);
                      //print('Alarm Set ' + alarmId.toString());
                      //Workmanager.cancelByUniqueName(doc.id);
                      Workmanager.registerOneOffTask(doc.id, alarm,
                          initialDelay: Duration(seconds: diff),
                          inputData: <String, dynamic>{
                            'name': doc['Name'],
                            'priority': doc['Priority'],
                          });
                      var detroit = tz.getLocation('Asia/Kolkata');
                      tz.TZDateTime schdate = tz.TZDateTime.now(detroit).add(
                        Duration(seconds: diff),
                      );
                      print(schdate);
                      flutterLocalNotificationsPlugin
                          .zonedSchedule(
                              --alarmId,
                              "My Task",
                              doc['Name'],
                              schdate,
                              const NotificationDetails(
                                android: AndroidNotificationDetails(
                                    'your channel id',
                                    'your channel name',
                                    'your channel description'),
                              ),
                              uiLocalNotificationDateInterpretation: null,
                              androidAllowWhileIdle: true)
                          .catchError((error) {
                        print("hello");
                      });
                      firestore
                          .collection("My Task")
                          .doc("App")
                          .collection("Task")
                          .doc(doc.id)
                          .update(
                              {'AlarmAssigned': true, 'WorkManagerID': doc.id});
                    }
                  },
                )
              },
          },
        );
    return true;
  }
}

Future selectNotification(String payload) {
  FlutterRingtonePlayer.stop();
  return null;
}
