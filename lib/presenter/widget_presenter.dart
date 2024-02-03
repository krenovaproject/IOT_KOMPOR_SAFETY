import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompor_safety/widgets/button_widget.dart';
import 'package:kompor_safety/widgets/main_widget.dart';

final buttonProvider = Provider<ButtonWidget>((ref) => ButtonWidget());
final mainWidgetProvider = Provider<MainWidget>((ref) => MainWidget());

final widgetPresenter = Provider<WidgetPresenter>((ref) => WidgetPresenter(
    buttonWidgets: ref.read(buttonProvider),
    mainWidgets: ref.read(mainWidgetProvider)));

class WidgetPresenter {
  final ButtonWidget buttonWidgets;
  final MainWidget mainWidgets;
  WidgetPresenter({required this.buttonWidgets, required this.mainWidgets});
}
