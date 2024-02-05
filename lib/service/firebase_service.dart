import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:kompor_safety/pages/entry_page.dart';
import 'package:kompor_safety/widgets/main_widget.dart';
// import 'package:toastification/toastification.dart';
import '../model/user_fire.dart';
import '../pages/main_page.dart';
import 'messaging_service.dart';

class FirebaseFunction {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  FirebaseDatabase dataRef = FirebaseDatabase.instance;

  //Auth Function
  Future<void> signInEmail(String email, String pass, WidgetRef ref,
      String serial, BuildContext c) async {
    try {
      // ref.read(userNotifier.notifier).setUser(email);
      // ref.read(tempNotifier.notifier).setSerialNumber(serial);
      // var printUser = ref.watch(userNotifier);
      // print('success login as $printUser');
      MessagingService().theToken();
      await auth.signInWithEmailAndPassword(email: email, password: pass).then((value) {
        ref.read(userNotifier.notifier).setUser(email);
      ref.read(tempNotifier.notifier).setSerialNumber(serial);
      var printUser = ref.watch(userNotifier);
      print('success login as $printUser');

        Navigator.pushReplacement(
            c, MaterialPageRoute(builder: (_) => const MainPage()));
      });
    } on FirebaseAuthException catch (error) {
      print(error.code);
      switch (error.code) {
        case "":
          print(error.code);
          // error.code = "Anonymous accounts are not enabled";
          // ignore: use_build_context_synchronously
          MainWidget().showTheToast('Error Occured', "Try new Email", c);
          break;
        case "invalid-credential":
          print(error.code);
          // error.code = "Your password is too weak";
          MainWidget()
              .showTheToast('Invalid Credential', "Your password is wrong or incorrect Email", c);
          break;
        case "wrong-password":
          print(error.code);
          // error.code = "Your email is invalid";
          MainWidget().showTheToast(
              'Error Occured', "User with this email doesn't exist", c);
          break;
        case "user-disabled":
          print(error.code);
          // error = "Email is already in use  different account";
          MainWidget().showTheToast(
              'Error Occured', "User with this email has been disabled", c);
          break;
        case "too-many-requests":
          print(error.code);
          MainWidget().showTheToast(
              'Error Occured', "Too many requests. Network Error", c);
          // error = "Your email is invalid";
          break;

        default:
          print("undefined error");
        // error = "An undefined Error happened.";
      }
    }
  }

  Future<void> signUpEmail(UserFire data, WidgetRef ref) async {
    saveUser(data);
    ref.read(userNotifier.notifier).setUser(data.email);
    ref.read(tempNotifier.notifier).setSerialNumber(data.serialNumber);
    MessagingService().theToken();
    print('success create an accout');
    await auth.createUserWithEmailAndPassword(
        email: data.email, password: data.pass);
  }

  Future<void> signOutEmail(BuildContext context, WidgetRef ref) async {
    ref.read(tempNotifier.notifier).clearOldSerial();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const EntryPage()));
    await auth.signOut();
  }

  // FireStore & Realtime DB Function
  Stream<UserFire> fetchUser(String docPathEmail) async* {
    final data = fire
        .collection('user')
        .doc(docPathEmail)
        .snapshots()
        .map((event) => UserFire.fromSnapshot(event));
    yield* data;
  }

  Future<void> saveUser(UserFire dataToSend) async {
    await fire.collection('user').doc(dataToSend.email).set({
      "userName": dataToSend.userName,
      "userEmail": dataToSend.email,
      "password": dataToSend.pass,
      "serialNumber": dataToSend.serialNumber,
      "stoveStatus": dataToSend.stoveStatus,
      "userProfilePath": "",
      "stoveName": ""
    });
  }

  Future<void> updateStoveStatus(
      String email, bool sstatus, String serialNums) async {
    print('r');
    final refs = dataRef.ref().child('stove').child(serialNums);
    await fire.collection('user').doc(email).update({"stoveStatus": sstatus});
    await refs.update({
      //stoveStatus
      "isRunningGUI": sstatus,
      // "notifCondition": sstatus ? 1 : 2
      "notifCondition": 2
    });
  }

  int getStringToInt(String input) {
    switch (input) {
      case "1 minutes":
        return 60000;
      case "5 minutes":
        return 300000;
      case "10 minutes":
        return 600000;
      case "20 minutes":
        return 1200000;
      default:
        return 60000;
    }
  }

  String fetchToString(int inp) {
    switch (inp) {
      case 60000:
        return "1 minutes";
      case 300000:
        return "5 minutes";
      case 600000:
        return "10 minutes";
      case 1200000:
        return "20 minutes";
      default:
        return "1 minutes";
    }
  }

  Future<void> updateTimerOff(String serialNumber, int inputStr) async {
    final refd = dataRef.ref().child('stove').child(serialNumber);
    await refd.update({"timeOff": inputStr, "notifCondition": 3});
    print('success input timer');
  }

  // user update
  Future<void> updateUserName(
      String userName, String path, String rtdbPath, String stoveNew) async {
    final refs = dataRef.ref().child('stove').child(rtdbPath);
    await fire
        .collection('user')
        .doc(path)
        .update({"userName": userName, "stoveName": stoveNew});
    await refs.update({"stoveName": stoveNew});
  }

  Future<void> pathFile(
    WidgetRef refs,
  ) async {
    final userPath = refs.watch(userNotifier);
    Reference ref =
        FirebaseStorage.instance.ref().child('user').child('/$userPath.jpg');

    ImagePicker pickImage = ImagePicker();
    XFile? fileRES = await pickImage
        .pickImage(source: ImageSource.gallery)
        .then((value) async {
      uploadUserImage(refs, value!.path);
      print(refs.watch(stateImage));
    });
    // return fileRES!.path;
  }

  Future<void> uploadUserImage(WidgetRef refs, String fileF) async {
    final userPath = refs.watch(userNotifier);
    Reference ref =
        FirebaseStorage.instance.ref().child('user').child('/$userPath.jpg');

    await ref.putFile(File(fileF));
    await fire
        .collection('user')
        .doc(userPath)
        .update({"userProfilePath": await ref.getDownloadURL()});
  }
}
