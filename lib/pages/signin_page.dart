import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/model/user_fire.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/pages/main_page.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';
import 'package:kompor_safety/presenter/widget_presenter.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  var controlUsername = TextEditingController();
  var controlEmail = TextEditingController();
  var controlPass = TextEditingController();
  var controlSerialNumber = TextEditingController();
  @override
  Widget build(
    BuildContext context,
  ) {
    var widgetUse = ref.read(widgetPresenter);
    var fireFunc = ref.read(firePresenter);
    var logs = ref.watch(logState);
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
                controlUsername,
                'username',
                context,
                Colors.blueGrey,
                const Icon(
                  Icons.nest_cam_wired_stand_sharp,
                  color: Colors.lightBlue,
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            widgetUse.mainWidgets.textForm1(
                controlEmail,
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
              controlPass,
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
              controlSerialNumber,
              'seral number',
              context,
              Colors.blueGrey,
              const Icon(
                Icons.numbers_sharp,
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
            widgetUse.buttonWidgets.signInButton('SIGN UP', () {
              fireFunc.fireFunction
                  .signUpEmail(
                      UserFire(
                        userProfilePath: '',
                        stoveName: '',
                          email: controlEmail.text,
                          pass: controlPass.text,
                          serialNumber: controlSerialNumber.text,
                          userName: controlUsername.text,
                          stoveStatus: false),
                      ref)
                  .then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const MainPage()));
              });
            }, size)
          ],
        ),
      ),
    );
  }
}
