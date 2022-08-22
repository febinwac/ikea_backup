import 'package:flutter/material.dart';
import 'package:sfm_module/views/category/category_detail_screen.dart';
import 'package:sfm_module/views/checkout/select_address.dart';

import '../views/auth_screen/login.dart';
import '../views/cart/cart_info_screen.dart';
import '../views/main_view/main_screen.dart';
import '../views/product_details/product_detail_screen.dart';
import '../views/splash_screen.dart';
import 'nav_route_constants.dart';

class NavRouteGenerator {
  static Map<String, WidgetBuilder> generateRoutes({dynamic arguments}) {
    return {
      splashScreenRoute: (context) => SplashScreen(),
      mainPageRoute: (context) => const MainScreen(),
      productDetailsRoute: (context) => ProductDetailScreen(
            sku: '',
          ),
      categoryDetailsRoute: (context) => CategoryDetailScreen(catId: ''),
      cartInfoRoute: (context) => CartInfoScreen(),
      loginRoute: (context) => LoginScreen(),
      savedAddressesRoute:(context)=>SelectAddressScreen()
    };
  }
}
