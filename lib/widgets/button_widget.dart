import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/notifier/stream_notifier.dart';
import 'package:kompor_safety/notifier/temporary_notifier.dart';
import 'package:kompor_safety/presenter/fire_presenter.dart';

class ButtonWidget {
  List<String> stringDrpdown = [
    "5 minutes",
    "10 minutes",
    "15 minutes",
    "20 minutes"
  ];
  Widget menuButton(
      {required String buttonName,
      required VoidCallback action,
      required Color buttonColor,
      required double radius,
      required double buttonWidth,
      required Color txtCol,
      required double buttonHeight}) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          onPressed: action,
          child: Text(
            buttonName,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: txtCol),
          )),
    );
  }

  Widget signInButton(String textSign, VoidCallback cb, Size size) {
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.06,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.height * 0.012)),
              backgroundColor: Colors.blueAccent),
          onPressed: cb,
          child: Text(
            textSign,
            style: TextStyle(fontSize: size.height * 0.02),
          )),
    );
  }

  Widget drawerButton(IconData icon, String title, double sizeText) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(sizeText)),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.blueGrey,
            ),
            SizedBox(
              width: sizeText * 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: sizeText, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDownWidget(Size size, WidgetRef red, String fetchTime) {
    final fireService = red.read(firePresenter);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select Item',
          style: TextStyle(
            fontSize: size.height * 0.02,
            color: Colors.white,
          ),
        ),
        items: stringDrpdown
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                    ),
                  ),
                ))
            .toList(),
        value: fetchTime,
        onChanged: (String? value) {
          if (value != null) {
            fireService.fireFunction.updateTimerOff(
                red.read(tempNotifier.notifier).fetchSerialNumber(), value);
            red.read(timeState.notifier).state = value;
          } else {
            print('');
          }
        },
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.height * 0.02)),
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          height: size.height * 0.045,
          width: size.width * 0.4,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: size.height * 0.045,
        ),
      ),
    );
  }
}
