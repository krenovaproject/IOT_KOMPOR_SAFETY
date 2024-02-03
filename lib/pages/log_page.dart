import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
// import 'package:kompor_safety/pages/login_page.dart';
import 'login_page.dart';
import 'signin_page.dart';

class LogPage extends ConsumerWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final logPage = ref.watch(logState);
    return logPage ? const SignInPage() : const LoginPage();
  }
}