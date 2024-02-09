import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/model/stove_rtdb.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:kompor_safety/pages/user_page.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';
import 'package:kompor_safety/presenter/widget_presenter.dart';
// import 'dart:math' as math;

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    FlipCardController controlFlip = FlipCardController();
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final widgetUsed = ref.read(widgetPresenter);
    final userData = ref.watch(streamUser);
    final streamDb = ref.watch(dataProvider);
    final fireContent = ref.read(firePresenter);
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: Drawer(
          width: size.width * 0.6,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.02),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(size.height * 0.02)),
                  height: size.height * 0.15,
                  width: size.width * 0.6,
                  child: Center(
                    child: Image.asset(
                      'images/stove_icon.png',
                      scale: size.height * 0.04,
                    ),
                  ),
                ),
                Divider(
                  height: size.height * 0.04,
                ),
                InkWell(
                  child: widgetUsed.buttonWidgets.drawerButton(
                    Icons.person,
                    'user',
                    size.height * 0.022,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UserPage()));
                  },
                ),
                Divider(
                  height: size.height * 0.04,
                ),
                InkWell(
                  child: widgetUsed.buttonWidgets.drawerButton(
                    Icons.settings,
                    'settings',
                    size.height * 0.022,
                  ),
                ),
                Divider(
                  height: size.height * 0.04,
                ),
                InkWell(
                  child: widgetUsed.buttonWidgets.drawerButton(
                    Icons.access_time_filled_sharp,
                    'schedule',
                    size.height * 0.022,
                  ),
                ),
                Divider(
                  height: size.height * 0.45,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.02, right: size.width * 0.02),
                  child: widgetUsed.buttonWidgets.signInButton('LOG OUT', () {
                    fireContent.fireFunction.signOutEmail(context, ref);
                  }, size),
                )
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.02, horizontal: size.width * 0.025),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      return scaffoldKey.currentState?.openDrawer();
                    },
                    child: FlipCard(
                      speed: 2000,
                      onFlipDone: (flip) {
                        Future.delayed(const Duration(seconds: 2))
                            .then((value) {
                          controlFlip.toggleCard();
                        });
                      },
                      controller: controlFlip,
                      autoFlipDuration: const Duration(seconds: 4),
                      flipOnTouch: false,
                      front: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                return scaffoldKey.currentState?.openDrawer();
                              },
                              icon: const Icon(Icons.menu))
                        ],
                      ),
                      back: userData.when(data: (data) {
                        return CircleAvatar(
                          radius: size.height * 0.03,
                          backgroundImage: NetworkImage(data.userProfilePath),
                        );
                      }, error: (e, r) {
                        return Text("error");
                      }, loading: () {
                        return Text('load');
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  userData.when(data: (datas) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                              fontSize: size.height * 0.03, color: Colors.grey),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          datas.userName,
                          style: TextStyle(
                              fontSize: size.height * 0.052,
                              // fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    );
                  }, error: (e, r) {
                    return Text(e.toString());
                  }, loading: () {
                    return Text('loading');
                  }),
                ],
              ),
              streamDb.when(data: (data) {
                if (data.snapshot.value == null) {
                  return const Center(
                    child: Text('failed connecting to database'),
                  );
                }
                final datas = StoveRtdb.fromJson(
                    data.snapshot.value as Map<dynamic, dynamic>);
                return Column(
                  children: [
                    widgetUsed.mainWidgets.cardStove(size, datas.isRunningEsp,
                        datas.stoveName, datas.serialNumber, context),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.52,
                      child: GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 0.1,
                                maxCrossAxisExtent: 200,
                                mainAxisExtent: 180),
                        children: [
                          widgetUsed.mainWidgets.statusCard(
                              size,
                              'Your Stove',
                              'Toogle',
                              () {},
                              Positioned(
                                left: size.width * 0.05,
                                top: size.height * 0.05,
                                child: SizedBox(
                                  width: size.height * 0.16,
                                  child: Image.asset('images/click_hand.png'),
                                ),
                              ),
                              Theme.of(context).hoverColor,
                              // SizedBox()
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Turn Off',
                                    style: TextStyle(
                                        fontSize: size.height * 0.024,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).focusColor),
                                  ),
                                  widgetUsed.buttonWidgets.menuButton(
                                      txtCol: Theme.of(context).hoverColor,
                                      buttonName: 'OFF',
                                      action: () {
                                        print(ref.watch(userNotifier));
                                        datas.isRunningEsp
                                            ? fireContent.fireFunction
                                                .updateStoveStatus(
                                                    ref.watch(userNotifier),
                                                    true,
                                                    ref
                                                        .read(tempNotifier
                                                            .notifier)
                                                        .fetchSerialNumber())
                                            : widgetUsed.mainWidgets
                                                .showTheToast(
                                                    'cant turn off',
                                                    'tour stove is already off',
                                                    context);
                                      },
                                      buttonColor: Theme.of(context).focusColor,
                                      radius: size.height * 0.01,
                                      buttonWidth: size.width * 0.2,
                                      buttonHeight: size.height * 0.048)
                                ],
                              ),
                              context),
                          widgetUsed.mainWidgets.statusCard(
                              size,
                              'Timing Event ',
                              'Get Started',
                              () {},
                              Positioned(
                                  left: -size.width * 0.03,
                                  top: size.height * 0.02,
                                  child: SizedBox(
                                    width: size.height * 0.18,
                                    child: Image.asset('images/clj.png'),
                                  )),
                              Theme.of(context).hoverColor,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Theme.of(context).focusColor,
                                    child: widgetUsed.buttonWidgets
                                        .dropDownWidget(
                                            size,
                                            ref,
                                            fireContent.fireFunction
                                                .fetchToString(datas.timeOff),
                                            context),
                                  ),
                                ],
                              ),
                              context),
                          widgetUsed.mainWidgets.statusCard(
                              size,
                              'Temperature',
                              '',
                              () {},
                              Positioned(
                                  left: -size.width * 0.12,
                                  top: size.height * 0.02,
                                  child: SizedBox(
                                    height: size.height *
                                        0.2, //   width: size.height * 0.2,
                                    child: Transform.rotate(
                                        // angle: math.pi / 15,
                                        angle: 0,
                                        child: Image.asset('images/temps.png')),
                                  )),
                              Theme.of(context).hoverColor,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.14,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Inner Stove :",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: size.height * 0.022,
                                              color:
                                                  Theme.of(context).focusColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          datas.temperature.toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: size.height * 0.02,
                                              color:
                                                  Theme.of(context).focusColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        SizedBox(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Status :",
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .focusColor),
                                              ),
                                              Text(
                                                "Normal",
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .focusColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              context),
                        ],
                      ),
                    )
                  ],
                );
              }, error: (e, r) {
                return Text(e.toString());
              }, loading: () {
                return const Center(
                  child: Text('load the data'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
