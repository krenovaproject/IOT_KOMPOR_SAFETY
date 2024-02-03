// import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kompor_safety/model/temporary_storage.dart';
import 'package:kompor_safety/pages/entry_page.dart';
import 'package:kompor_safety/service/background_service.dart';
// import 'package:kompor_safety/service/messaging_service.dart';
import 'firebase_options.dart';
import 'service/messaging_service.dart';

// ...

@pragma('vm:entry-point')
Future<void> handlerBackgroundMessaging(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  MessagingService().createNotification(remoteMessage);
  print(remoteMessage.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://safetystove-3ff9e-default-rtdb.firebaseio.com/');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(null, [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              // groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              // defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.blueAccent,
              defaultRingtoneType: DefaultRingtoneType.Ringtone,
              ledColor: Colors.white),
        ],
        
        debug: true);
  await Hive.initFlutter();
  Hive.registerAdapter(TemporaryStorageAdapter());
  var box = await Hive.openBox('temporary');
  FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessaging);
  MessagingService().initNotif();
  MessagingService().theToken();
  BackgroundService().initializeService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: EntryPage());
  }
}
