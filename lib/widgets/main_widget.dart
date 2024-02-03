import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

class MainWidget {
  Widget cardStove(
    Size size,
    bool statusColor,
    String stoveName,
    String serialNumber,
  ) {
    return SizedBox(
      width: size.width,
      height: size.height * 0.2,
      child: Card(
        color:
            statusColor ? Color.fromARGB(255, 200, 237, 255) : Colors.lightBlue,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * 0.024)),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.w500,
                                // fontFamily: 'Lato',
                                color:
                                    statusColor ? Colors.black : Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        stoveName,
                        style: TextStyle(
                            fontSize: size.height * 0.04,
                            // fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                            color: statusColor ? Colors.black : Colors.white),
                      ),
                      Text(
                        serialNumber,
                        style: TextStyle(
                            fontSize: size.height * 0.024,
                            // fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            color: statusColor ? Colors.black : Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: statusColor
                      ? Lottie.asset('images/blue_flame.json')
                      : Lottie.asset('images/black_flame.json'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ToastificationItem showTheToast(
      String title, String content, BuildContext context) {
    return toastification.show(
        context: context,
        title: Text(title),
        description: Text(content),
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false);
  }

  Widget formEdit(TextEditingController controller, IconData icon, String param,
      String titleText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          hintText: param,
          label: Text(titleText),
          icon: Icon(icon),
          focusColor: Colors.grey,
          suffixIconColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          )
          // border: OutlineInputBorder(

          // )
          ),
    );
  }

  Widget statusCard(Size size, String upperText, String downText,
      VoidCallback cb, Widget asst, Color color, Widget righB) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.002,
      ),
      child: InkWell(
        onTap: cb,
        child: SizedBox(
          width: size.width * 0.37,
          // height: size.height * 0.3,
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.height * 0.02)),
            child: Stack(
              children: [
                asst,
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        upperText,
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 246, 246, 246)),
                        maxLines: 3,
                      ),
                      righB
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textForm1(TextEditingController controllerText, String label,
      BuildContext context, Color focusBorderColor, Icon iconLeft) {
    return TextField(
      controller: controllerText,
      autofocus: false,
      decoration: InputDecoration(
          icon: iconLeft,
          labelText: label,
          disabledBorder: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2, color: Colors.blueAccent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 2, color: focusBorderColor))),
    );
  }
}
