import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';
import 'package:kompor_safety/presenter/widget_presenter.dart';

import '../notifier/stream_notifier.dart';
import 'main_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  var controlemail = TextEditingController();
  var controlpass = TextEditingController();
  var controlSerialLog = TextEditingController();

  @override
  void dispose() {
    controlemail.dispose();
    controlpass.dispose();
    controlSerialLog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var logs = ref.watch(logState);
    var widgetUse = ref.read(widgetPresenter);
    var fireFunction = ref.read(firePresenter);
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.03, horizontal: size.width * 0.025),
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: Image.asset('images/signIm-removebg.png'),
            ),
            widgetUse.mainWidgets.textForm1(
                controlemail,
                'email',
                context,
                Colors.blueGrey,
                const Icon(
                  Icons.person,
                  color: Colors.lightBlue,
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            widgetUse.mainWidgets.textForm1(
              controlpass,
              'password',
              context,
              Colors.blueGrey,
              const Icon(
                Icons.password_sharp,
                color: Colors.lightBlue,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            widgetUse.mainWidgets.textForm1(
              controlSerialLog,
              'serial number',
              context,
              Colors.blueGrey,
              const Icon(
                Icons.password_sharp,
                color: Colors.lightBlue,
              ),
            ),
            SizedBox(
              height: size.height * 0.002,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(logState.notifier).state = !logs;
                  },
                  child: const Text(
                    'already have an account',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
            widgetUse.buttonWidgets.signInButton('LOGIN', () {
              if (controlemail.text != '' &&
                  controlSerialLog.text != '') {
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  fireFunction.fireFunction
                      .signInEmail(controlemail.text, controlpass.text, ref,
                          controlSerialLog.text, context);
                });
              } else {
                widgetUse.mainWidgets.showTheToast("invalid text in form", "try login with your account", context);
              }
            }, size)
          ],
        ),
      ),
    );
  }
}
