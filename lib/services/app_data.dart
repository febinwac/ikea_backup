import 'package:flutter/material.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() => _instance;

  AppData._internal();

  static String baseUrl = "";
  static String restApiUrl = "";
  static String hostAppLanguage = "";
  static String flavourEnv = "";
  static String accessToken = "";
  static String storeCode = "";
  static String region = "";
  static String cartId = "";
  static String apiKey = "AIzaSyAt8LczltdkDYhiYDyGLKfQUB9Mt_dpn-Q";
  static String currencySymbol = "";
  static String currencyCode = "";
  static String countryCode = "";
  static String phone = "";
  static String refreshToken = "";
  static String email = "";
  static String name = "";
  static String navFrom = "";
  static FormFieldState<String>? state;

  void clearInfo() {
    accessToken = "";
    currencySymbol = "";
    countryCode = "";
    cartId = "";
    storeCode = "";
    navFrom = "";
    name = "";
    phone = "";
  }
}
