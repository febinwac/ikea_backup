import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/colors.dart';

class CustomTextField extends StatelessWidget {
  final double? textFontSize;
  final double? hintFontSize;
  final FontWeight? fontWeight;
  final Widget? prefix;
  final FontStyle? fontStyle;
  final UnderlineInputBorder? underlineInputBorder;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final Function()? onTap;
  final Function? onSaved;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool enableBorder;
  final InputBorder? enabledBorder;
  final bool enableFocusBorder;
  final InputBorder? focusedBorder;
  final Function? validator;

  CustomTextField(
      {this.textFontSize,
      this.hintFontSize,
      this.underlineInputBorder,
      this.fontWeight,
      this.fontStyle,
      this.hintText,
      this.prefix,
      this.controller,
      this.onChanged,
      required this.onTap,
      this.onSaved,
      this.maxLength,
      this.focusNode,
      this.enableBorder = false,
      this.enabledBorder,
      this.enableFocusBorder = false,
      this.focusedBorder,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,
      onTap: onTap,
      cursorColor: HexColor("424242"),
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: onChanged,
      validator: validator == null
          ? (val) {
              return null;
            }
          : (val) => validator!(val),
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
        FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
      ],
      style: TextStyle(
          color: HexColor(boldBlack),
          fontSize: textFontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle),
      maxLines: 1,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        counterText: "",
        enabledBorder: !enableBorder
            ? underlineInputBorder ??
                UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor(boldBlack)),
                )
            : enabledBorder,
        focusedBorder: !enableFocusBorder
            ? underlineInputBorder ??
                UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor(boldBlack)),
                )
            : focusedBorder,
        contentPadding: EdgeInsets.only(top: 12.0.h, bottom: 5.h),
        hintText: hintText,
        prefix: Padding(padding: EdgeInsets.only(right: 2.w), child: prefix),
        hintStyle: TextStyle(
            color: HexColor(lightGrey),
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal),
      ),
    );
  }
}
