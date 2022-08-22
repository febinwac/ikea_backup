import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sfm_module/providers/address_provider.dart';
import 'package:sfm_module/providers/cart_provider.dart';
import 'package:sfm_module/providers/product_related_provider.dart';

import '../providers/app_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/home_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => AppDataProvider()),
    ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => ProductRelatedProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
  ];
}
