import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifier = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super('');
  void setUser(String email) {
    state = email;
    print('success setUser $state');
  }
}
