import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kompor_safety/pages/log_page.dart';
import 'package:kompor_safety/service/messaging_service.dart';

import 'main_page.dart';

class EntryPage extends ConsumerStatefulWidget {
  const EntryPage({super.key});

  @override
  ConsumerState<EntryPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<EntryPage> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.data);
   
  }
User? user;
  void delayedLogin() async{
    await Future.delayed(Duration(seconds: 1)).then((value) {
      ref.read(userNotifier.notifier).setUser(user!.email!);
    });
  }

  @override
  void initState() {
    setupInteractedMessage();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var msgH = message.notification!.title;
  print('Got a message whilst in the foreground!');
  print('Message data: $msgH');

  if (msgH == "Time Safety") {
    MessagingService().soundNotification(message);
  }else{
     MessagingService().createNotification(message);
  }
});
    user = FirebaseAuth.instance.currentUser;
    delayedLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final streamUser = ref.watch(authUser);
    return Scaffold(
      body: streamUser.when(data: (userLoggedIn){
        if(userLoggedIn != null){
          return const MainPage();
        }else{
          return const LogPage();
        }
      }, error: (e,r){
    return const Center(
      child: Text('error'),
    );
      }, loading: (){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}