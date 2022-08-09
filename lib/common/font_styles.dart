import 'package:flutter/cupertino.dart';

import 'colors.dart';

class FontStyle {
  static const themeFont = "NotoIKEALatin";

  static TextStyle productTitleStyle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle productSubTitleStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: HexColor(subTitleColor));
  static TextStyle productAmtStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle productCurrencyStyle = TextStyle(
      fontSize: 10, fontWeight: FontWeight.bold, color: HexColor(black));

  static TextStyle ikeaFamilyStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: HexColor(blueTitleColor));
  static TextStyle productBlueTitleStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: HexColor(blueTitleColor));
  static TextStyle recentItemStyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle noInternet = TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: HexColor(white));
  static TextStyle removedProductTitle = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(white));
  static TextStyle retry = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: HexColor(blueTitleColor));
  static TextStyle placesItemSub = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(lightGrey));
  static TextStyle placesItem = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle edit = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(black), decoration: TextDecoration.underline);
  static TextStyle title = TextStyle( 
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle orderTitle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(boldBlack));
  static TextStyle selectQty = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle totPrice = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle priceBold = TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle priceBoldBlue = TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: HexColor("#057BC1"));
  static TextStyle applyCoupon = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(darkGrey));
  static TextStyle applyCouponBlue = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(primaryColor));
  static TextStyle green10 = TextStyle(
      fontSize: 10, fontWeight: FontWeight.bold, color: HexColor(green));
  static TextStyle greenNormal = TextStyle(
      fontSize: 10, fontWeight: FontWeight.normal, color: HexColor(green));
  static TextStyle green14Bold = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(green));
  static TextStyle green14Normal = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(green));
  static TextStyle green20Bold = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: HexColor(black));

  static TextStyle productSearchTitleStyle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: HexColor(boldBlack));

  static TextStyle categoryTitle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(boldBlack));

  static TextStyle productCategory = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor(boldBlack));

  static TextStyle categoryProductAmtStyle = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: HexColor(boldBlack));

  static TextStyle productDetailsAmtStyle = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: HexColor(boldBlack));

  static TextStyle categoryTile = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(boldBlack));
  static TextStyle blue13Normal = TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: HexColor(blueTitleColor),
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: HexColor(blueTitleColor));
  static TextStyle black24Bold = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: HexColor(black));

  static TextStyle black26Bold = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle blue26Bold = TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: HexColor("#057BC1"));
  static TextStyle applyCouponRed = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(red));

  static TextStyle black11Normal = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.normal,color: HexColor(black));

  static TextStyle white11Bold = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,color: HexColor(white));

  static TextStyle grey14Normal = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(lightGrey));

  static TextStyle addToCartButtonStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,color: HexColor(white));


  static TextStyle pendingStatus = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor("#A66E05"));

  static TextStyle pendingStatusbold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor("#A66E05"));

  static TextStyle cancelledStatus = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(red));

  static TextStyle cancelledStatusbold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor(red));

  static TextStyle otherStatus = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(green));

  static TextStyle otherStatusBold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor(green));

  static TextStyle userrText = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold,color: HexColor(boldBlack));

  static TextStyle accountTile = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(subTitleColor));

  static TextStyle productRegularPrice = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w500, color: HexColor(lightGrey));

  static TextStyle logout = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: HexColor(boldBlack));

  static TextStyle blue16 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: HexColor(blueTitleColor));

  static TextStyle defaultQuantity = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(darkGrey));

  static TextStyle orderNoTitle = TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: HexColor(subTitleColor));
  static TextStyle orderTitleBold = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(boldBlack));
  static TextStyle delSlotsUnavailable = TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: HexColor(greyColor));

  static TextStyle boldBlack12 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(boldBlack));

  static TextStyle lightBlack12 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: HexColor(lightBlack));

  static TextStyle focusedColor = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: HexColor(primaryColor));


  static TextStyle currencyBlue = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: HexColor(blueTitleColor));

  static TextStyle lightGrey11 = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: HexColor(lightGrey));



  static TextStyle strikeText = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: HexColor(darkGrey),
      decorationColor: HexColor(darkGrey),
      decorationStyle: TextDecorationStyle.solid,
      decoration: TextDecoration.lineThrough);
  static TextStyle editAddressHintStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,color: HexColor(lightGrey));
  static TextStyle editAddressTextStyle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle black13Normal = TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle black12Bold = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor(black));

  static TextStyle addOnTitle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: HexColor(blueTitleColor));
  static TextStyle addOnTitle12 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, color: HexColor(black));

  static TextStyle style1 = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle style2 = TextStyle(
      fontSize: 10, fontWeight: FontWeight.normal, color: HexColor(black));
  static TextStyle style3 = TextStyle(
      fontSize: 10, fontWeight: FontWeight.normal, color: HexColor(black),backgroundColor: HexColor(white));
  static TextStyle lightGrey16 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: HexColor(lightGrey));
  static TextStyle black15Bold = TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: HexColor(black));
  static TextStyle black13Bold = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: HexColor(black));

}
