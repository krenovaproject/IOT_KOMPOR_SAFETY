import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/model/stove_rtdb.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/notifier/user_notifier.dart';
import 'package:kompor_safety/pages/error_page.dart';
import 'package:kompor_safety/pages/loading_page.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';
import 'package:kompor_safety/presenter/widget_presenter.dart';
import 'package:toastification/toastification.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  // FirePresenter? fireC;

  @override
  void initState() {
    // final fireC = ref.read(firePresenter);
    // fireC.fireFunction.fetchImage(ref);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final fireC = ref.read(firePresenter);
    final streamDB = ref.watch(dataProvider);
    TextEditingController controlUser = TextEditingController();
    TextEditingController controlStove = TextEditingController();
    final streamUserData = ref.watch(streamUser);
    final size = MediaQuery.sizeOf(context);
    final widgetUsed = ref.read(widgetPresenter);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04, horizontal: size.width * 0.01),
            width: size.width,
            height: size.height,
            child: streamUserData.when(data: (datas) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.blueGrey,
                            size: size.height * 0.04,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SizedBox(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: size.height * 0.1,
                          backgroundImage: NetworkImage(datas.userProfilePath),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 8,
                            child: IconButton(
                                onPressed: () async {
                                  await fireC.fireFunction.pathFile(ref);
                                },
                                icon: Icon(
                                  Icons.add_photo_alternate_sharp,
                                  color: Colors.grey,
                                  size: size.height * 0.05,
                                )))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.087),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widgetUsed.mainWidgets.formEdit(
                            controlUser,
                            Icons.person,
                            'username',
                            datas.userName, context
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          streamDB.when(data: (datasR){
                            final refQ = datasR.snapshot.value as Map<dynamic, dynamic>;
                            final stoveNameR = StoveRtdb.fromJson(refQ);
                            if(stoveNameR.stoveName != datas.stoveName){
                             Future.delayed(const Duration(seconds: 1)).then((value){
                              widgetUsed.mainWidgets.showTheToast("upsss... your stovename is changed by the last user", "try to changed your stovename", context);
                             } ); 
                            }
                            return widgetUsed.mainWidgets.formEdit(
                              controlStove,
                              Icons.border_top_outlined,
                              'stove name',
                              datas.stoveName == "" ? stoveNameR.stoveName : datas.stoveName, context);
                          }, error: (e,r){
                            return Text("fail when fetching data");
                          }, loading: (){
                            return CircularProgressIndicator();
                          })
                        ],
                      ),
                    ),
                  ),
                  widgetUsed.buttonWidgets.menuButton(
                      buttonName: "save",
                      action: () async {
                        if (controlStove.text == '' && controlUser.text == '') {
                          print('no text');
                          toastification.show(
                              context: context,
                              title: Text("fill up the form"),
                              showProgressBar: false,
                              style: ToastificationStyle.flat,
                              autoCloseDuration:
                                  const Duration(milliseconds: 2000));
                        } else {
                          await fireC.fireFunction.updateUserName(
                              controlUser.text == ''
                                  ? datas.userName
                                  : controlUser.text,
                              ref.watch(userNotifier),
                              ref
                                  .read(tempNotifier.notifier)
                                  .fetchSerialNumber(),
                              controlStove.text == ''
                                  ? datas.stoveName
                                  : controlStove.text);
                        }
                      },
                      buttonColor: Colors.blueAccent,
                      radius: size.height * 0.012,
                      buttonWidth: size.width * 0.3,
                      txtCol: Colors.white,
                      buttonHeight: size.height * 0.06)
                ],
              );
            }, error: (e, r) {
              return const ErrorPage();
            }, loading: () {
              return const LoadingPage();
            })),
      ),
    );
  }
}
