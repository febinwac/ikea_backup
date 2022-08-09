import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/nav_route_constants.dart';
import 'common/multi_provider_list.dart';
import 'common/font_styles.dart';
import 'common/nav_route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(IkeaApp());
}

class IkeaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: MaterialApp(
          title: 'IKEA',
          debugShowCheckedModeBanner: false,
          initialRoute: splashScreenRoute,
          routes: NavRouteGenerator.generateRoutes(),
          theme: ThemeData(
            fontFamily: FontStyle.themeFont,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          )),
    );
  }
}
