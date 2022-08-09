import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(getColorFromHex(hexColor));

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

const String black = '#111111';
const String white = '#ffffff';
const String subTitleColor = '#404040';
const String primaryColor = '#0058A3';
const String viewAllGrey = '#6E6E6E';
const String dividerColor = '#E5E5E5';
const String blueTitleColor = '#0557AC';
const String orange = '#CA5008';
const String red = '#B71C1C';
const String darkRed = '#B9271D';
const String lightGrey = '#9B9B9B';
const String blueButtonColor =  '#0058A3';//'#0557AC';
const String viewGrey = '#EDEDED';
const String darkGrey = '#9B9B9B';
const String green = '#07890B';
const String nearlyGrey = '#F5F5F5';
const String boldBlack = '#000000';
const String lightBlack = '#484848';
const String greyColor = '#9c9c9c';
const String lightGrey01 = '#F6F6F6';
const String darkYellow = '#ffdb00';

