import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/nav_route_constants.dart';
import 'package:sfm_module/providers/cart_provider.dart';
import 'package:sfm_module/providers/home_provider.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';
import 'package:sfm_module/views/account/account_screen.dart';
import 'package:sfm_module/views/cart/cart_screen.dart';
import 'package:sfm_module/views/category/category_screen.dart';
import 'package:sfm_module/views/home/home_screen.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/font_styles.dart';
import '../../common/nav_route_generator.dart';

class MainScreen extends StatefulWidget {
  final int? initial;

  const MainScreen({Key? key, this.initial}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _animationController;

  late final PersistentTabController controller;

  @override
  void initState() {
    final provider = context.read<HomeProvider>();
    controller = PersistentTabController(initialIndex: widget.initial ?? 0);
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      if (_animationController != null) {
        _animationController.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Entered build $context");

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      onItemSelected: (int val) {
        setState(() {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          // homeModel.updateTabIndex(val);
        });
        getInitialDataByIndex();
      },
      decoration: NavBarDecoration(
          border:
              Border(top: BorderSide(color: HexColor("#DEDEDE"), width: 1.0))),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
      stateManagement: false,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          ? 0.0
          : kBottomNavigationBarHeight,
      hideNavigationBarWhenKeyboardShows: true,
      margin: const EdgeInsets.all(0.0),
      padding: const NavBarPadding.only(bottom: 5, left: 10, right: 10, top: 5),
      popActionScreens: PopActionScreensType.all,
      hideNavigationBar: false,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: false,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.simple, // Choose the nav bar style with this property
    );
  }

  List<Widget> _buildScreens() {
    return [HomeScreen(), CategoryScreen(), AccountScreen(), CartScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: controller.index == 0
            ? SizedBox(
                height: 35.h,
                width: 35.w,
                child: Lottie.asset(
                  Constants.lottieHomeIcon,
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController.duration = composition.duration;
                  },
                ),
              )
            : Image.asset(
                Constants.homeIcon,
                height: 23.w,
                width: 23.w,
                color: controller.index == 0
                    ? HexColor('#FD930A')
                    : HexColor('#7F7F7F'),
              ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: mainPageRoute,
          routes: NavRouteGenerator.generateRoutes(),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: controller.index == 1
            ? SizedBox(
                height: 35.h,
                width: 35.w,
                child: Lottie.asset(
                  Constants.lottieSearchTabIcon,
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController.duration = composition.duration;
                  },
                ),
              )
            : Image.asset(
                Constants.searchTabIcon,
                height: 23.w,
                width: 23.w,
                color: controller.index == 1
                    ? HexColor('#FD930A')
                    : HexColor('#7F7F7F'),
              ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: mainPageRoute,
          routes: NavRouteGenerator.generateRoutes(),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: controller.index == 2
            ? SizedBox(
                height: 35.h,
                width: 35.w,
                child: Lottie.asset(
                  Constants.lottieAccountIcon,
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController.duration = composition.duration;
                  },
                ),
              )
            : Image.asset(
                Constants.accountIcon,
                height: 23.w,
                width: 23.w,
                color: controller.index == 2
                    ? HexColor('#FD930A')
                    : HexColor('#7F7F7F'),
              ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: mainPageRoute,
          routes: NavRouteGenerator.generateRoutes(),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Consumer2<HomeProvider, CartProvider>(
          builder: (ctx, homeModel, cartModel, _) {
            return Badge(
              toAnimate: false,
              elevation: 0,
              shape: BadgeShape.circle,
              badgeColor: cartModel.cartCount == 0
                  ? HexColor(white)
                  : HexColor(darkYellow),
              padding: const EdgeInsets.all(0.0),
              borderRadius: BorderRadius.circular(3),
              position: cartModel.cartCount == 0
                  ? BadgePosition.bottomEnd()
                  : controller.index == 3
                      ? BadgePosition.topEnd(top: 6.h, end: -2.w)
                      : BadgePosition.topEnd(top: 6.h, end: -8.w),
              badgeContent: Container(
                height: 18,
                width: 18,
                alignment: Alignment.center,
                child: cartModel.cartCount == 0
                    ? const Text("")
                    : Text("${cartModel.cartCount}",
                        style: FontStyle.productCurrencyStyle),
              ),
              child: controller.index == 3
                  ? SizedBox(
                      height: 35.h,
                      width: 35.w,
                      child: Lottie.asset(
                        Constants.lottieCartIcon,
                        controller: _animationController,
                        onLoaded: (composition) {
                          _animationController.duration = composition.duration;
                        },
                      ),
                    )
                  : Image.asset(
                      Constants.cartIcon,
                      height: 23.w,
                      width: 23.w,
                      color: controller.index == 3
                          ? HexColor('#FD930A')
                          : HexColor('#7F7F7F'),
                    ),
            );
          },
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: mainPageRoute,
          routes: NavRouteGenerator.generateRoutes(),
        ),
      ),
    ];
  }

  void getInitialDataByIndex() {
    switch (controller.index) {
      case 3:
        Future.microtask(() => context.read<CartProvider>()
          ..cartInit()
          ..getCartList(context));
        break;
    }
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? item.activeColorPrimary
                      : item.inactiveColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                  child: Text(
                item.title!,
                style: item.textStyle,
              )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 2.0, color: HexColor('#F8F8F8')))),
        //color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              int index = items.indexOf(item);
              return Flexible(
                child: InkWell(
                  onTap: () {
                    onItemSelected(index);
                  },
                  child: _buildItem(item, selectedIndex == index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
