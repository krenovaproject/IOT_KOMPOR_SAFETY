import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/service/background_service.dart';
import 'package:kompor_safety/service/firebase_service.dart';

final firebaseFunction =
    Provider<FirebaseFunction>((ref) => FirebaseFunction());

final firePresenter = Provider<FirePresenter>(
  (ref) => FirePresenter(
      fireFunction: ref.read(firebaseFunction),
      bgService: ref.read(bgServiceProvider)),
);

class FirePresenter {
  final FirebaseFunction fireFunction;
  final BackgroundService bgService;
  FirePresenter({required this.fireFunction, required this.bgService});
}
