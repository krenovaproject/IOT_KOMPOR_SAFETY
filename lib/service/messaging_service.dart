import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kompor_safety/model/temporary_storage.dart';

class MessagingService {
  FirebaseMessaging msgService = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
  String getPath() {
    var tempBox = Hive.box('temporary');
    String path = '';
    for (var f in tempBox.values) {
      TemporaryStorage h = f as TemporaryStorage;
      path = h.serialNumber;
      print(path);
      break;
    }
    return path;
  }

  Future<void> theToken() async {
    await msgService.requestPermission();
    if (getPath() != '') {
      DatabaseReference refs =
          FirebaseDatabase.instance.ref().child('stove').child(getPath());
      String? tokenFcm = await msgService.getToken().then((valueToken) async {
        refs.update({"fcmToken": valueToken});
      });
      print(tokenFcm);
    } else {
      print('no path');
    }
  }

  void initNotif() async {
    flp.initialize(const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher")));
  }

  void createNotification(RemoteMessage message) async {
    const notifdetail = NotificationDetails(
        android: AndroidNotificationDetails('notifications', "notifchannel",
            importance: Importance.max, priority: Priority.high));
    await flp.show(8, message.notification!.title,
        message.notification!.body, notifdetail);
  }

  void soundNotification(RemoteMessage msg) async {
    const notifdetail = NotificationDetails(
        android: AndroidNotificationDetails('notifications', "notifchannel",
            // category: AndroidNotificationCategory.call,
            playSound: true,
// vibrationPattern: ,
enableVibration: true,
            // audioAttributesUsage: AudioAttributesUsage.notification,
            sound: RawResourceAndroidNotificationSound("ringtone"),
            importance: Importance.max,
            priority: Priority.high));
    await flp.show(Random().nextInt(100), msg.notification!.title,
        msg.notification!.body, notifdetail);
  }

  Future<void> hitSerial(String path) async {
    Dio dio = Dio();
    await dio.post(
      'http://127.0.0.1:3000/send/',
      data: {"serial": path},
      onSendProgress: (count, total) {
        print('send data $total');
      },
    ).then((value) {
      print('success print $value');
    });
  }
}
