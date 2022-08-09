import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';
import 'package:sfm_module/services/app_data.dart';

import '../common/check_exception.dart';
import '../common/helpers.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier, ProviderHelperClass {
  int cartCount = 0;
  Cart? cart;
  List<CartItems>? cartItems;
  List<CustomPricesApp>? customPricesApp;
  String couponCode = "";
  bool isGuest = true;
  bool? isDiscountApplied = false;
  bool? isValueUpdated = false;
  bool cartLoader = false;
  List<AppliedCoupons>? appliedCoupons = [];
  final TextEditingController couponTextController = TextEditingController();

  Future<int> getCartList(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      if (AppData.accessToken.isNotEmpty) {
        isGuest = false;
      }
      dynamic _resp = await serviceConfig.getCartList(isGuest);
      print("getCartList $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && isGuest
          ? _resp['cart'] != null
          : _resp['customerCart'] != null) {
        if (isGuest) {
          cart = Cart.fromJson(_resp['cart']);
        } else {
          cart = Cart.fromJson(_resp['customerCart']);
        }
        cartCount = cart?.totalQuantity ?? 0;
        cartItems = cart?.items ?? [];
        customPricesApp = cart?.customPricesApp ?? [];
        if ((cart?.appliedCoupons ?? []).isNotEmpty) {
          appliedCoupons = cart?.appliedCoupons;
          couponTextController.text = appliedCoupons!.first.code ?? "";
          updateDiscountApplied(true);
          updateCouponCode(appliedCoupons!.first.code ?? "");
        } else {
          updateDiscountApplied(false);
          updateCouponCode("");
        }
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return cartCount;
  }

  Future<bool> applyCoupon(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    bool flag = false;
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.applyCoupon(couponTextController.text);
      print("applyCoupon $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['applyCouponToCart'] != null) {
        ApplyOrRemoveCouponToCart? applyOrRemoveCouponToCart =
            ApplyOrRemoveCouponToCart.fromJson(_resp['applyCouponToCart']);
        flag = true;
        customPricesApp = applyOrRemoveCouponToCart.cart?.customPricesApp ?? [];
        updateDiscountApplied(true);
        updateCouponCode(appliedCoupons!.first.code ?? "");
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: (val) {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return flag;
  }

  Future<bool> removeCoupon(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    bool flag = false;
    if (network) {
      updateCartLoader(true);
      dynamic _resp = await serviceConfig.removeCoupon();
      print("removeCoupon $_resp");
      updateCartLoader(false);
      if (_resp != null && _resp['removeCouponFromCart'] != null) {
        ApplyOrRemoveCouponToCart? applyOrRemoveCouponToCart =
            ApplyOrRemoveCouponToCart.fromJson(_resp['removeCouponFromCart']);
        flag = true;
        customPricesApp = applyOrRemoveCouponToCart.cart?.customPricesApp ?? [];
        updateDiscountApplied(false);
        updateCouponCode("");
        couponTextController.clear();
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: (val) {}, onAuthError: (value) {});
        });
      }
    } else {
      updateCartLoader(false);
    }
    return flag;
  }

  void cartInit() {
    loaderState = LoaderState.loaded;
    couponTextController.text = "";
    cartItems = [];
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  updateCartCount(int quantity) {
    cartCount = quantity;
    notifyListeners();
  }

  updateCouponCode(String value) {
    couponCode = value;
    notifyListeners();
  }

  updateDiscountApplied(bool value) {
    isDiscountApplied = value;
    notifyListeners();
  }

  updateCartLoader(bool value) {
    cartLoader = value;
    notifyListeners();
  }
}
