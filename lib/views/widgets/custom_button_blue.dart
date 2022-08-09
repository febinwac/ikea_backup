import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sfm_module/common/colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double width;
  final double textSize;
  final double height;
  final Widget? loader;
  final double elevation;
  final Color? raisedBtnColour;

  CustomButton(
      {required this.buttonText,
      required this.onPressed,
      required this.width,
      this.elevation = 0.0,
      this.height = 45.0,
      this.textSize = 14.0,
      this.loader,
      required this.raisedBtnColour});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: raisedBtnColour,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: loader ??
              Text(buttonText,
                  style: TextStyle(
                      color: HexColor(white),
                      fontSize: textSize,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
        ));
  }
}
