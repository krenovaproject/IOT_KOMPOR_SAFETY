import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kompor_safety/model/temporary_storage.dart';

final tempNotifier = StateNotifierProvider<TemporaryNotifier, TemporaryStorage>((ref)  {
  return TemporaryNotifier();
});

class TemporaryNotifier extends StateNotifier<TemporaryStorage> {
  TemporaryNotifier() : super(TemporaryStorage(serialNumber: ''));
  Box stoveBox = Hive.box('temporary');

  void setSerialNumber(String serialNum) async {
    print('success set SerialNumber');
    state = TemporaryStorage(serialNumber: serialNum);
    await stoveBox.add(TemporaryStorage(serialNumber: serialNum)).then((value) {
      print('success add $serialNum');
      print(state.serialNumber);
    });
  }

  String fetchSerialNumber() {
    final printy = stoveBox.values;
    String jaw = '';
    TemporaryStorage tempData ;
    for (var i in printy){
      // jaw = i;
      final tempD = i as TemporaryStorage;
      jaw = tempD.serialNumber; 
    }
    print('this is $jaw');
    // state = tempData;
    // return tempData.serialNumber;
    return jaw;
  }

  void clearOldSerial() async {
    print('delete old SerialNumber');
    await stoveBox.clear();
  }
}
