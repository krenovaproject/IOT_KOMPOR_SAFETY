import 'package:flutter/widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.4,
      child: Column(
        children: [SizedBox(), SizedBox()],
      ),
    );
  }
}
