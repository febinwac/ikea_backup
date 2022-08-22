import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/providers/cart_provider.dart';

import '../../common/common_error_page.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../providers/home_provider.dart';
import '../main_view/main_header_widget.dart';
import '../main_view/sfm_switcher_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() => context.read<HomeProvider>().getHomeData(context));
    Future.microtask(() => context.read<CartProvider>().getCartList(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            appBar: appBar(),
            backgroundColor: Colors.white,
            body: Consumer<HomeProvider>(builder: (context, model, _) {
              if (model.loaderState == LoaderState.loading) {
                return CommonLinearLoader();
              }
              if (model.loaderState == LoaderState.networkErr ||
                  model.loaderState == LoaderState.error) {
                return CommonErrorPage(
                  loaderState: model.loaderState,
                  onButtonTap: () => {},
                );
              }
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: model.widgetList),
              );
            }),
          );
        });
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      systemOverlayStyle: Platform.isIOS
          ? SystemUiOverlayStyle.dark
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark),
      toolbarHeight: 120.h,
      // Set this height
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        double _height = constraints.maxHeight;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: _height * 0.25),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.0.w, 2.0.h, 12.0.w, _height * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainHeaderWidget(),
                SfmSwitcherWidget(),
                SizedBox(
                  height: _height * 0.03,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
