import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
 await Firebase.initializeApp();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      print('foreground');
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      print('background');
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // flutterLocalNotificationsPlugin.show(888, 'my_foreground', 'Safety Stove', const NotificationDetails(
        //   android: AndroidNotificationDetails('my_foreground', 'MY FOREGROUND SERVICE', ongoing: true)
        // ));
        print(Random().nextInt(20));
        // DatabaseReference refs =
        //     FirebaseDatabase.instance.ref().child('stove').child('3134');
        // refs.onValue.listen((event) {
        //   final res =
        //       StoveRtdb.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
        //   if (res.isRunning) {
        //     print('running');
        //   } else {
        //     print('not running');
        //   }
        // });
      }
    }
  });
}

final bgServiceProvider =
    Provider<BackgroundService>((ref) => BackgroundService());

class BackgroundService {
// this will be used for notification id, So you can update your custom notification with this id.
  final notificationId = 888;
  String notificationChannelId = 'my_foreground';

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await service.configure(
        iosConfiguration: IosConfiguration(
          // auto start service
          autoStart: true,

          // this will be executed when app is in foreground in separated isolate
          onForeground: onStart,

          // you have to enable background fetch capability on xcode project
          onBackground: onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,

          // auto start service
          autoStart: true,
          isForegroundMode: true,
        ));
    await service.startService();
  }
}
