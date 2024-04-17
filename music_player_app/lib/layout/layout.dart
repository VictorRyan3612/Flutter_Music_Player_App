import 'package:flutter/material.dart';


class LayoutDecider extends StatelessWidget {
  final ValueNotifier<bool> isMobile;
  final Widget option1;
  final Widget option2;

  const LayoutDecider({Key? key, required this.isMobile, required this.option1, required this.option2}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        isMobile.value = constraints.maxWidth < 600;
        return isMobile.value ? option1 : option2;        
      },
    );
  }
}
