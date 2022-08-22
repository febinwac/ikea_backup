import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sfm_module/common/nav_route_constants.dart';
import 'package:sfm_module/views/auth_screen/login.dart';
import 'package:sfm_module/views/auth_screen/registration_screen.dart';
import 'package:sfm_module/views/auth_screen/verify_otp.dart';
import 'package:sfm_module/views/cart/cart_info_screen.dart';
import 'package:sfm_module/views/category/category_detail_screen.dart';
import 'package:sfm_module/views/checkout/select_address.dart';
import 'package:sfm_module/views/main_view/main_screen.dart';

import '../views/product_details/product_detail_screen.dart';

class NavRoutes {
  static void navRemoveUntilMainPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(mainPageRoute, (route) => false);
  }

  static Future<void> navRemoveBottomNavMainPage(BuildContext context,
      {int? page}) {
    return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => MainScreen(
                  initial: page ?? 0,
                )),
        (route) => false);
  }

  static Future<dynamic> navToProductDetailPage(
      BuildContext context, String sku,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: ProductDetailScreen(sku: sku),
      settings: const RouteSettings(name: productDetailsRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static Future<dynamic> navToCategoryDetailPage(BuildContext context,
      {bool withNav = true, required String catId}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: CategoryDetailScreen(catId: catId),
      settings: const RouteSettings(name: categoryDetailsRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static Future<dynamic> navToCartInfoPage(BuildContext context,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: CartInfoScreen(),
      settings: const RouteSettings(name: cartInfoRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static Future<dynamic> navToLoginPage(BuildContext context,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: LoginScreen(),
      settings: const RouteSettings(name: loginRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static Future<dynamic> navToVerifyOTPPage(BuildContext context, String mobileNumber,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: VerifyOTP(mobileNumber: mobileNumber),
      settings: const RouteSettings(name: verifyOtpRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  static Future<dynamic> navToRegistrationPage(BuildContext context, String mobileNumber,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: RegistrationScreen(mobileNumber: mobileNumber),
      settings: const RouteSettings(name: verifyOtpRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }


  static Future<dynamic> navToSelectAddressScreen(BuildContext context,
      {bool withNav = true}) {
    return pushNewScreenWithRouteSettings(
      context,
      screen: SelectAddressScreen(),
      settings: const RouteSettings(name: selectAddressRoute),
      withNavBar: withNav, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
