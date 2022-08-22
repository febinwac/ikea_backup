import 'package:flutter/material.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';

import '../common/check_exception.dart';
import '../common/helpers.dart';
import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier with ProviderHelperClass {
  List<Widget> widgetList = [];
  List<Addresses> addressList = [];
  int deliveryAddressIdSelected = 0;
  int billingAddressIdSelected = 0;
  int delMethodIdSelected = 0;
  int slotIdSelected = 0;
  bool isSameBillingAddress = true;

  Future<void> getAddressList(BuildContext context,
      {Function(bool val)? noAddress, bool popLoaderStatus = false}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      dynamic resp = await serviceConfig.getAddressList();
      print("Get Address list : $resp");
      if (resp != null && resp['customer'] != null) {
        Customer customer = Customer.fromJson(resp['customer']);
        if ((customer.addresses ?? []).isNotEmpty) {
          addressList = customer.addresses ?? [];
          updateSelectedAddress(initial: true);
        }
      }
      setAddressData(context: context);
      updateLoadState(LoaderState.loaded);
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateSelectedAddress({bool initial = true}) {
    if (initial) {
      deliveryAddressIdSelected = addressList[0].id ?? 0;
      billingAddressIdSelected = addressList[0].id ?? 0;
      delMethodIdSelected = 0;
      slotIdSelected = 0;
      isSameBillingAddress = true;
    }

    notifyListeners();
  }

  setAddressData({BuildContext? context}) {}

  Future<bool> updateCartWithCityStore(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    bool flag = false;
    if (network) {
      // updateLoadState(LoaderState.loading);
      // dynamic _resp = await serviceConfig.applyCoupon(couponTextController.text);
      // print("applyCoupon $_resp");
      // updateLoadState(LoaderState.loaded);
      // if (_resp != null && _resp['applyCouponToCart'] != null) {
      //
      //   notifyListeners();
      // } else {
      //   Future.microtask(() {
      //     Check.checkException(_resp, context,
      //         onError: (val) {}, onAuthError: (value) {});
      //   });
      // }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return flag;
  }
}
