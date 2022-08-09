import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart' as _toast;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/providers/app_provider.dart';

import '../models/cart_model.dart';
import '../models/home_model.dart';
import '../services/app_data.dart';
import 'colors.dart';
import 'font_styles.dart';
import 'constants.dart';
import 'preference_utils.dart';

class Helpers {
  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> isLocationServiceEnabled() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static double convertToDouble(var val) {
    double _val = 0.0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case int:
        _val = val.toDouble();
        break;
      case String:
        _val = double.tryParse(val) ?? _val;
        break;

      default:
        _val = 0.0;
    }
    return _val;
  }

  static int convertToInt(var val) {
    int _val = 0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case double:
        return val.toInt();

      case String:
        return int.tryParse(val) ?? _val;

      default:
        return val;
    }
  }

  static capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  static capitaliseAll(String? input) {
    if (input != null && input.isNotEmpty) {
      return input.toUpperCase();
    } else {
      return '';
    }
  }

  static showFlushBar(String message, BuildContext context, IconData icon,
      {String title = ''}) {
    return Flushbar(
      onStatusChanged: (FlushbarStatus? status) {
        debugPrint(status.toString());
        switch (status) {

          case FlushbarStatus.SHOWING:
            {
              context.read<AppDataProvider>().updateStatusBarColor(Colors.black);
              // SystemChrome.setSystemUIOverlayStyle(
              //     SystemUiOverlayStyle(statusBarColor: HexColor(black)));
              break;
            }
          case FlushbarStatus.IS_APPEARING:
            {
              context.read<AppDataProvider>().updateStatusBarColor(Colors.black);
              break;
            }
          case FlushbarStatus.IS_HIDING:
            {
              context.read<AppDataProvider>().updateStatusBarColor(Colors.black);
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              context.read<AppDataProvider>().updateStatusBarColor(Colors.white);
              break;
            }
          default:
            SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(statusBarColor: HexColor(black)));
            break;
        }
      },
      messageText: Wrap(
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyle.removedProductTitle,
            ),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: FontStyle.noInternet,
          ),
        ],
      ),
      backgroundColor: HexColor(black),
      flushbarPosition: FlushbarPosition.TOP,
      padding: const EdgeInsets.all(18.0),
      duration: const Duration(seconds: 2),

    )..show(context);
  }

  static showFlushBarWithDuration(String message, BuildContext context,
      IconData icon, Duration duration, bool isCart,
      {String title = ''}) {
    return Flushbar(
      onStatusChanged: (FlushbarStatus? status) {
        switch (status) {
          case FlushbarStatus.SHOWING:
            {
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: HexColor(black)));
              break;
            }
          case FlushbarStatus.IS_APPEARING:
            {
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: HexColor(black)));
              break;
            }
          case FlushbarStatus.IS_HIDING:
            {
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: HexColor(black)));
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
                  .copyWith(
                      statusBarColor: Colors.white,
                      statusBarBrightness: Brightness.dark));
              break;
            }
        }
      },
      messageText: Wrap(
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyle.removedProductTitle,
            ),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: FontStyle.noInternet,
          ),
        ],
      ),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: HexColor(black),
      padding: const EdgeInsets.all(18.0),
      duration: duration,
    )..show(context).then((value) {});
  }

  static double convertValueToDouble(var valFromApi) {
    double value = 0.0;
    if (valFromApi == null) return value;
    switch (valFromApi.runtimeType) {
      case int:
        value = valFromApi.toDouble();
        break;
      case String:
        value = double.tryParse(valFromApi) ?? value;
        break;

      default:
        value = valFromApi;
    }
    return value;
  }

  static Widget textFieldError(String msg, BuildContext context,
      {bool showError = false, bool needPadding = true}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showError
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                needPadding ? SizedBox(height: 10.h) : Container(),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(msg,
                        style: TextStyle(color: Colors.red[700], fontSize: 13)))
              ],
            )
          : const SizedBox(),
    );
  }

  static getBundleOptionIds(List<Options> options) {
    List<String> optionIds = [];
    var i = 0;
    for (var optionId in options) {
      optionIds.add(optionId.id.toString());
      i++;
    }
    return optionIds;
  }

  static getBannerList(ContentData? contentData) {
    List<BannerModel> banners = [];
    List<Content>? content = contentData?.content ?? [];
    for (var i = 0; i < content.length; i++) {
      BannerModel bannerModel = BannerModel(
          content[i].banner ?? "",
          content[i].linkType ?? "",
          content[i].linkId ?? "",
          content[i].banner ?? "");
      banners.add(bannerModel);
    }
    return banners;
  }
}
