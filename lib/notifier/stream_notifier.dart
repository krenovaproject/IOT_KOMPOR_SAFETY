// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';

final logState = StateProvider<bool>((ref) => false);
var timeState = StateProvider<String>((ref) => '');
var stateImage = StateProvider<String>((ref) => '');

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authUser = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final databaseReferenceProvider = Provider<DatabaseReference>((ref) {
  final database = ref.watch(firebaseDatabaseProvider);
  return database.ref();
});
Stream<dynamic> getDataStream(DatabaseReference reference) {
  return reference.onValue;
}

final streamRTD = StreamProvider<Map<dynamic, dynamic>>((ref) {
  final databaseReference = ref.watch(databaseProvider);
  final ser = ref.read(tempNotifier.notifier).fetchSerialNumber();
  print(databaseReference.ref.child('stove/$ser/').onValue);
  return databaseReference.ref.child('stove').child(ser)
      .onValue
      .asyncMap((event) => event.snapshot.value as Map<dynamic, dynamic>)
      .distinct();
});

final streamUser = StreamProvider.autoDispose((ref) {
  final data = ref.read(firebaseFunction);
  final namePath = ref.watch(userNotifier);
  return data.fetchUser(namePath);
});

final databaseProvider = Provider<DatabaseReference>((ref) {
  final data = ref.read(tempNotifier.notifier).fetchSerialNumber();
  // print(ref.read(tempNotifier.notifier).fetchSerialNumber());
  return FirebaseDatabase.instance.ref().child('stove').child(data);
});

final dataProvider = StreamProvider<DatabaseEvent>((ref) {
  // final to = ref.read(tempNotifier.notifier).fetchSerialNumber();
  DatabaseReference rt = ref.watch(databaseProvider);

  return rt.onValue;
});

