import 'package:cloud_firestore/cloud_firestore.dart';

class UserFire {
  final String userName;
  final String userProfilePath;
  final String email;
  final String pass;
  final String serialNumber;
  final bool stoveStatus;
  final String stoveName;

  UserFire(
      {required this.email,
      required this.pass,
      required this.stoveName,
      required this.userProfilePath,
      required this.serialNumber,
      required this.userName,
      required this.stoveStatus});

  factory UserFire.fromSnapshot(DocumentSnapshot data) {
    Map<String, dynamic> userData = data.data() as Map<String, dynamic>;
    return UserFire(
        email: userData['userEmail'] ?? '',
        userProfilePath: userData['userProfilePath'],
        stoveName: userData['stoveName'] ?? '',
        pass: userData['password'] ?? '',
        serialNumber: userData['serialNumber'] ?? '',
        userName: userData['userName'] ?? '',
        stoveStatus: userData['stoveStatus'] ?? false);
  }
}
