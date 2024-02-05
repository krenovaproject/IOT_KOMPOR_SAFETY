import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/model/stove_rtdb.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:kompor_safety/pages/user_page.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';
import 'package:kompor_safety/presenter/widget_presenter.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final widgetUsed = ref.read(widgetPresenter);
    final userData = ref.watch(streamUser);
    final streamDb = ref.watch(dataProvider);
    final fireContent = ref.read(firePresenter);
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
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
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const UserPage()));
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
                  IconButton(
                      onPressed: () {
                        return scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu))
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
                    widgetUsed.mainWidgets.cardStove(
                      size,
                      datas.isRunningEsp,
                      datas.stoveName,
                      datas.serialNumber,
                    ),
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
                                  width: size.width * 0.2,
                                  child: Image.asset('images/click_hand.png'),
                                ),
                              ),
                              Colors.lightBlue,
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
                                        color: const Color.fromARGB(
                                            255, 238, 238, 238)),
                                  ),
                                  widgetUsed.buttonWidgets.menuButton(
                                    txtCol: Colors.blueAccent,
                                      buttonName: 'OFF',
                                      action: () {
                                        print(ref.watch(userNotifier));
                                        datas.isRunningEsp ? 
                                        fireContent.fireFunction
                                            .updateStoveStatus(
                                                ref.watch(userNotifier),
                                                true,
                                                ref
                                                    .read(tempNotifier.notifier)
                                                    .fetchSerialNumber()) : widgetUsed.mainWidgets.showTheToast('cant turn off', 'tour stove is already off', context);
                                      },
                                      buttonColor: Colors.white,
                                      radius: size.height * 0.01,
                                      buttonWidth: size.width * 0.2,
                                      buttonHeight: size.height * 0.048)
                                ],
                              )),
                          widgetUsed.mainWidgets.statusCard(
                              size,
                              'Timing Event For Safety',
                              'Get Started',
                              () {},
                              Positioned(
                                  left: size.width * 0.05,
                                  top: size.height * 0.05,
                                  child: SizedBox(
                                    width: size.width * 0.12,
                                    child: Image.asset('images/klk.png'),
                                  )),
                              Colors.blueAccent,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: widgetUsed.buttonWidgets
                                        .dropDownWidget(size, ref, fireContent.fireFunction.fetchToString(datas.timeOff)),
                                  ),
                                ],
                              )),
                          widgetUsed.mainWidgets.statusCard(
                              size,
                              'Inner Temperature',
                              '',
                              () {},
                              Positioned(
                                  left: size.width * 0.05,
                                  top: size.height * 0.05,
                                  child: SizedBox(
                                    width: size.width * 0.12,
                                    child: Image.asset('images/temperature.png'),
                                  )),
                              Colors.blueGrey[300]!,
                              Row(
                                children: [
                                  Text(
                                    'Temperature:',
                                    style: TextStyle(
                                        fontSize: size.height * 0.024,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: Text(
                                      datas.temperature.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: size.height * 0.022,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                );
              }, error: (e, r) {
                return Text(e.toString());
              }, loading: () {
                return const Center(
                  child: Text('loading'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
