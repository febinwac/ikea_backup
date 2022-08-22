import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/common/helpers.dart';
import 'package:sfm_module/common/nav_route.dart';
import 'package:sfm_module/providers/cart_provider.dart';
import 'package:sfm_module/providers/home_provider.dart';
import 'package:sfm_module/services/app_data.dart';

import '../../common/colors.dart';
import '../../common/common_error_page.dart';
import '../../common/common_loader.dart';
import '../../common/constants.dart';
import '../../common/nav_route_constants.dart';
import '../../models/cart_model.dart';
import '../widgets/custom_button_blue.dart';
import '../widgets/divider_view.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _animationPosition;
  CartProvider? cartProvider;
  FocusNode? mFocusNode;

  @override
  void initState() {
    cartProvider = context.read<CartProvider>();
    mFocusNode = FocusNode();
    _slideAnimation();
    super.initState();
  }

  void _slideAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _animationPosition = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (_animationController != null) {
          _animationController!.dispose();
        }
        cartProvider?.couponTextController.dispose();
      }
    });

    super.dispose();
  }

  // @override
  // void didUpdateWidget(oldWidget) {
  //   _slideAnimation();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<CartProvider>(builder: (context, model, _) {
            return Scaffold(
                appBar: appBar(),
                bottomNavigationBar: proceedBtn(),
                backgroundColor: Colors.white,
                body: buildMainWidget(model));
          });
        });
  }

  /// main widget
  buildMainWidget(model) {
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      (model.cartItems ?? []).isNotEmpty
          ? Expanded(
              child: Stack(
                children: [
                  // model.cartLoader?CircularLoader():
                  Column(
                    children: [
                      _buildLocationWidget(),
                      Expanded(
                          child: ListView(
                        children: [
                          _buildCartItems(model),
                          _buildAmountWidget(model)
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            )
          : Expanded(child: _buildEmptyWidget())
    ]);
  }

  _buildCartItems(CartProvider model) {
    List<CartItems>? cartItems = model.cartItems ?? [];

    return cartItems.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.only(top: 35.h, bottom: 45.h),
            scrollDirection: Axis.vertical,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return CartItem(
                index: index,
                currency: AppData.currencySymbol,
                cartItem: cartItems[index],
                updateQuantity: (int quantity) {},
                removeItem: () {},
                addOnClick: () {},
                context: context,
              );
            },
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(
              height: 74.h,
            ),
          )
        : const SizedBox();
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1,
      shadowColor: HexColor('#DFDFDF'),
      backgroundColor: Colors.white,
      title: Text(
        Constants.cart,
        style: FontStyle.title,
        textAlign: TextAlign.center,
      ),
      actions: [
        IconButton(
            icon: Image.asset(
              Constants.info,
              height: 20.h,
              width: 20.w,
            ),
            onPressed: () =>
                NavRoutes.navToCartInfoPage(context, withNav: false)),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }

  _buildEmptyWidget() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 39.h, 0, 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  Constants.bagEmpty,
                  style: TextStyle(
                      fontSize: Platform.isIOS ? 25 : 24,
                      fontWeight: FontWeight.bold,
                      color: HexColor(black)),
                ),
              ),
              AppData.accessToken.isNotEmpty
                  ? _easyPicks()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 22.h,
                          ),
                          Text(
                            Constants.notLoginText,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: Platform.isIOS ? 15 : 14,
                                fontWeight: FontWeight.normal,
                                color: HexColor(subTitleColor)),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              AppData.navFrom = loginRoute;
                              NavRoutes.navToLoginPage(context);
                            },
                            child: Text(
                              Constants.login,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: Platform.isIOS ? 14 : 13,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.normal,
                                  color: HexColor(subTitleColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  _buildLocationWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(28.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: HexColor('#DFDFDF'), width: 1.0.w))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildAddressName(), _buildEditLocation()],
      ),
    );
  }

  _buildAddressName() {
    return Expanded(
      child: Text(
        "Location name",
        style: FontStyle.recentItemStyle,
        textAlign: TextAlign.start,
      ),
    );
  }

  _buildEditLocation() {
    return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            Constants.edit,
            style: FontStyle.edit,
          ),
        ));
  }

  Widget _easyPicks() {
    return Column(
      children: [
        SizedBox(
          height: 22.h,
        ),
      ],
    );
  }

  proceedBtn() {
    return Consumer2<CartProvider, HomeProvider>(
        builder: (context, cartModel, homeModel, _) {
      if (cartModel.loaderState == LoaderState.loaded &&
          ((cartModel.cartItems ?? []).isEmpty) &&
          AppData.accessToken.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
          child: CustomButton(
            buttonText: Constants.cartEmptyBtn,
            onPressed: () {
              // homeModel.updateTabIndex(0);
              Future.microtask(() {
                NavRoutes.navRemoveUntilMainPage(context);
              });
            },
            width: double.maxFinite,
            raisedBtnColour: HexColor(primaryColor),
            height: 55.0,
          ),
        );
      }
      if (cartModel.loaderState == LoaderState.loading) return const SizedBox();
      return ((cartModel.cart?.items ?? []).isNotEmpty)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0.h),
              child: SlideTransition(
                position: _animationPosition!,
                child: Row(
                  children: [
                    SizedBox(
                      width: 19.w,
                    ),
                    Expanded(
                      child: CustomButton(
                        raisedBtnColour: HexColor(primaryColor),
                        width: MediaQuery.of(context).size.width,
                        buttonText: Constants.proceedToCheckOut,
                        height: Platform.isIOS ? 60.0.h : 55.0.h,
                        onPressed: () {
                          NavRoutes.navToSelectAddressScreen(context,withNav: false);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 19.w,
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }

  _buildAmountWidget(CartProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_buildApplyTitle(),
        AppData.accessToken.isNotEmpty ? _buildCouponWidget() : Container(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        DividerView(
          edgeInsetsGeometry:
              EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
        ),

        Container(
          padding: EdgeInsets.only(left: 20.w, right: 5.w, bottom: 8.h),
          child: Text(
            Constants.priceDetails,
            style: FontStyle.title,
            textAlign: TextAlign.start,
          ),
        ),

        (model.customPricesApp ?? []).isNotEmpty
            ? Row(
                children: [
                  Expanded(
                      child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: (model.customPricesApp ?? []).length,
                    itemBuilder: (context, index) {
                      return _buildDynamicPriceWidget(
                          (model.customPricesApp ?? [])[index]);
                    },
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    separatorBuilder: (_, __) => SizedBox(
                      height: 8.h,
                    ),
                  ))
                ],
              )
            : Container(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.017,
        ),
        DividerView(
          edgeInsetsGeometry: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget _buildProductCurrency(int type) {
    return Text(
      AppData.currencySymbol ?? "",
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: type == 2
          ? FontStyle.green14Bold
          : type == 0
              ? FontStyle.orderTitle
              : FontStyle.productCurrencyStyle,
    );
  }

  Widget _buildProductAmount(int type, double value) {
    return Text(
      "$value",
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: type == 0
          ? FontStyle.productSearchTitleStyle
          : type == 2
              ? FontStyle.green14Bold
              : FontStyle.priceBold,
    );
  }

  _buildDiscountApplicableTag() {
    return Container(
      padding: EdgeInsets.all(17.h),
      child: Text(
        Constants.discountTag,
        style: FontStyle.placesItemSub,
        textAlign: TextAlign.start,
      ),
    );
  }

  _buildDynamicPriceWidget(CustomPricesApp customPricesApp) {
    switch (customPricesApp.className) {
      case "price_final":
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            DividerView(
              edgeInsetsGeometry: EdgeInsets.only(left: 20.w, right: 20.w),
            ),
            SizedBox(
              height: 10.h,
            ),
            _buildTotalInclTax(
                customPricesApp.label ?? "", customPricesApp.value ?? 0.0),
          ],
        );
        break;
      case "discount":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 5.w,
              ),
              child: Text(
                Constants.couponApplied,
                style: FontStyle.green14Normal,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(2.w, 12.h, 20.w, 0),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 1.5,
                runSpacing: 2.0,
                verticalDirection: VerticalDirection.down,
                children: [
                  _buildProductCurrency(2),
                  SizedBox(
                    width: 1.w,
                  ),
                  _buildProductAmount(2, customPricesApp.value ?? 0.0),
                ],
              ),
            )
          ],
        );
        break;
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 5.r,
              ),
              child: Text(
                customPricesApp.label ?? "",
                style: FontStyle.totPrice,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(2.w, 12.h, 20.w, 0),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 1.5,
                runSpacing: 2.0,
                verticalDirection: VerticalDirection.down,
                children: [
                  _buildProductCurrency(0),
                  SizedBox(
                    width: 1.w,
                  ),
                  _buildProductAmount(1, customPricesApp.value ?? 0.0),
                ],
              ),
            )
          ],
        );
    }
  }

  _buildTotalInclTax(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 5.w,
          ),
          child: Text(
            label,
            style: FontStyle.categoryTile,
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(2.w, 12.h, 20.w, 0),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 1.5,
            runSpacing: 2.0,
            verticalDirection: VerticalDirection.down,
            children: [
              _buildProductCurrency(0),
              SizedBox(
                width: 1.w,
              ),
              _buildProductAmount(0, val),
            ],
          ),
        )
      ],
    );
  }

  _buildCouponWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.0, color: HexColor("#E5E5E5")))),
      child: Row(
        children: [_buildApplyCouponText(), _buildApplyButton()],
      ),
    );
  }

  _buildApplyCouponText() {
    bool isDiscountApplied = cartProvider?.isDiscountApplied ?? false;
    print("isDiscountApplied : $isDiscountApplied");
    return Expanded(
      child: Form(
        child: TextFormField(
          controller: cartProvider?.couponTextController,
          focusNode: mFocusNode,
          onTap: () {},
          onChanged: (val) {
            cartProvider?.updateCouponCode(val);
          },
          decoration: InputDecoration(
            hintText: Constants.applyCode,
            hintStyle: FontStyle.black13Normal,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          readOnly: isDiscountApplied,
        ),
      ),
    );
  }

  _buildApplyButton() {
    return Consumer<CartProvider>(builder: (context, model, _) {
      bool isDiscountApplied = model.isDiscountApplied ?? false;
      print("Code in _buildApplyButton ${model.couponCode}");
      return isDiscountApplied
          ? Wrap(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 18,
                  width: 18,
                  child: Icon(
                    Icons.close,
                    size: 15,
                    color: HexColor(red),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartProvider?.removeCoupon(context);
                  },
                  child: Text(
                    Constants.remove,
                    textAlign: TextAlign.center,
                    style: FontStyle.applyCouponRed,
                  ),
                )
              ],
            )
          : Wrap(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(right: 5.w),
                  height: 22,
                  width: 22,
                  child: Image.asset(model.couponCode.isEmpty
                      ? Constants.greyTick
                      : Constants.blueTick),
                ),
                GestureDetector(
                  onTap: () {
                    cartProvider?.applyCoupon(context);
                  },
                  child: Text(
                    Constants.apply,
                    textAlign: TextAlign.center,
                    style: model.couponCode.isEmpty
                        ? FontStyle.applyCoupon
                        : FontStyle.applyCouponBlue,
                  ),
                )
              ],
            );
    });
  }
}
