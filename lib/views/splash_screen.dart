import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/helpers.dart';
import 'package:sfm_module/common/preference_utils.dart';
import 'package:sfm_module/providers/cart_provider.dart';
import '../common/colors.dart';
import '../common/constants.dart';
import '../common/extensions.dart';
import '../common/nav_route.dart';
import '../models/native_parsing_model.dart';
import '../providers/app_provider.dart';
import '../services/app_data.dart';
import '../services/graphQL_client.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool autoPlay = true;
  String? authToken;
  String? cartCount;
  String? cartId;
  static const platform = MethodChannel('com.ikea.kompis/nativeToFlutter');
  String hostLanguage = "";
  ValueNotifier<bool> internetNotifier = ValueNotifier(true);

  @override
  void initState() {
    try {
      // Future.delayed(const Duration(seconds: 1)).then((value) async =>
      //     platform.setMethodCallHandler(nativeMethodCallHandler));
      testFromStandAloneApp();
    } catch (e) {
      print('Native call error!    $e');
    }

    super.initState();
  }

  Future<void> testFromStandAloneApp() async {
    AppData.baseUrl = ''.getBaseUrl();
    AppData.restApiUrl = ''.getRestApiBaseUrl();
    AppData.hostAppLanguage = "en";
    await PreferenceUtils.setStringToSF(
        PreferenceUtils.baseUrl, AppData.baseUrl);
    await PreferenceUtils.setStringToSF(
        PreferenceUtils.restApiUrl, AppData.restApiUrl);
    fetchInitialData();
  }

  /// Call from native button "Shop IKEA"
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "nativeToFlutter":
        String jsonStringReceived = methodCall.arguments;
        NativeParsingModel model =
            NativeParsingModel.fromJson(jsonDecode(jsonStringReceived));
        final flavourEnv = model.flavourEnvironment ?? "";

        /// Set url and language of button based on variants
        AppData.baseUrl = flavourEnv.getBaseUrl();
        AppData.restApiUrl = flavourEnv.getRestApiBaseUrl();
        AppData.hostAppLanguage = model.language ?? "en";
        await PreferenceUtils.setStringToSF(
            PreferenceUtils.baseUrl, AppData.baseUrl);
        await PreferenceUtils.setStringToSF(
            PreferenceUtils.restApiUrl, AppData.restApiUrl);
        fetchInitialData();

        return "Data returned in methodChannel";
      default:
        return "Default returned in methodChannel";
    }
  }

  _buildCarousalWidget() {
    final _size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          options: CarouselOptions(
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              aspectRatio: 16 / 9,
              height: double.maxFinite,
              initialPage: 0,
              viewportFraction: 1,
              autoPlay: autoPlay,
              onPageChanged: (val, _) {
                if (val == 1) {
                  setState(() {
                    autoPlay = false;
                  });
                }
              },
              autoPlayInterval: const Duration(milliseconds: 1500),
              enableInfiniteScroll: true),
          items: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Constants.splashImage1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Constants.splashImage2),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Lottie.asset(Constants.bouncingBallIcon,
                    height: _size.width * 0.4, width: _size.width * 0.4),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            body: Stack(
              children: [
                _buildCarousalWidget(),
                _buildInternetCheckWidget(),
              ],
            ),
          );
        });
  }

  void fetchInitialData() async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      internetNotifier.value = false;
      AppData.accessToken = await PreferenceUtils().getAccessToken();
      AppData.storeCode = await PreferenceUtils().getStoreCode();
      AppData.region = await PreferenceUtils().getRegion();
      AppData.email = await PreferenceUtils().getEmail();
      AppData.refreshToken = await PreferenceUtils().getRefreshToken();
      AppData.cartId = await PreferenceUtils().getCartId();

      GraphQLClientConfiguration.instance
          .config(
              context: context,
              token: AppData.accessToken,
              store: AppData.storeCode,
              region: AppData.region)
          .then((bool value) async {
        if (value) {
          await Future.delayed(const Duration(seconds: 2));
          Future.microtask(
              () => context.read<AppDataProvider>().getCountryInfo(context));
          Future.microtask(() => context
                  .read<AppDataProvider>()
                  .fetchCartId(context)
                  .then((cartId) {
                Future.microtask(() => context.read<CartProvider>()
                  ..cartInit()
                  ..getCartList(context)
                      .then((cartCount) {
                    if (AppData.accessToken.trim() == "Bearer" ||
                        AppData.accessToken.isEmpty) {
                      NavRoutes.navRemoveUntilMainPage(context);
                    } else {
                      Future.microtask(() => context
                              .read<AppDataProvider>()
                              .checkTokenExpiredOrNot(context)
                              .then((expired) {
                            if (expired) {
                              Future.microtask(() => context
                                      .read<AppDataProvider>()
                                      .refreshCurrentToken(context,
                                          AppData.email, AppData.refreshToken)
                                      .then((newToken) {
                                    if (newToken.isNotEmpty) {
                                      NavRoutes.navRemoveUntilMainPage(context);
                                    }
                                  }));
                            } else {
                              NavRoutes.navRemoveUntilMainPage(context);
                            }
                          }));
                    }
                  }));
              }));
        }
      });
    } else {
      internetNotifier.value = true;
    }
  }

  _buildInternetCheckWidget() {
    return ValueListenableBuilder(
      valueListenable: internetNotifier,
      builder: (BuildContext context, bool value, Widget? child) {
        return value
            ? Positioned(
                bottom: 0,
                right: 10,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        Constants.noInternet,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: HexColor(white)),
                      ),
                      TextButton(
                          onPressed: () {
                            fetchInitialData();
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ))
            : const SizedBox();
      },
    );
  }
}
