import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static const String prefAuthToken = "token";
  static const String prefIsLoggedin = "isUserLoggedIn";
  static const String prefUsername = "firstname";
  static const String selectedLocation = "selectedLocation";
  static const String recentLocation = "recentLocation";
  static const String storeId = "storeId";
  static const String region = "region";
  static const String currency = "currency";
  static const String customerCartId = "id";
  static const String cartId = "cartId";
  static const String phone = "phone";
  static const String countryId = "countryId";
  static const String addToCartQuantity = "addToCartQuantity";
  static const String addToCartProduct = "addToCartProduct";
  static const String currencyCode = "currency_code";
  static const String cartCount = "cartCount";
  static const String baseUrl = "baseUrl";
  static const String restApiUrl = "restApiUrl";
  static const String refreshTokenId = "refreshTokenId";
  static const String email = "email";
  static const String customerPhone = "customer_phone";

  static setStringToSF(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, val);
  }

  static setIntToSF(String key, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  static setDoubleToSF(String key, double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, val);
  }

  static setBoolToSF(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  static Future<String?> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    return boolValue;
  }

  static getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    return intValue;
  }

  static getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble(key);
    return doubleValue;
  }

  static checkKeyExist(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey(key);
    return CheckValue;
  }

  static setObjectToSF(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static getObject(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

 static Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    if (data != null) {
      await prefs.remove(key);
    }
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(prefAuthToken);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? stringValue
            : ""
        : "";
  }

  getStoreCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(storeId);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(baseUrl);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getRestApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(restApiUrl);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getCartId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(cartId);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getRegion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(region);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(refreshTokenId);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(email);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }
  getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(phone);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }
  getCustomerPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(customerPhone);
    return stringValue != null
        ? stringValue.isNotEmpty
            ? "$stringValue"
            : ''
        : '';
  }
}
