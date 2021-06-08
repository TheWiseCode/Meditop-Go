import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  late double? width;

  TextFieldContainer({
    Key? key,
    required this.child,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(width == null)
      width = size.width * 0.8;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: width,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
