import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';
import 'package:sfm_module/views/home/home_advertisement_widget.dart';
import 'package:sfm_module/views/home/product_tile.dart';

import '../common/helpers.dart';
import '../common/check_exception.dart';
import '../models/home_model.dart';
import '../views/home/home_category_tile.dart';
import '../views/home/home_main_banners.dart';

class HomeProvider with ChangeNotifier, ProviderHelperClass {
  int carouselIndex = 0;
  List<Widget> widgetList = [];
  late Customcms homeModelData;

  Future<void> getHomeData(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.getHomeData();
      print("getHomeData $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['Customcms'] != null) {
        homeModelData = Customcms.fromJson(_resp['Customcms']);
        setHomeData(context: context);
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
  }

  void setHomeData({BuildContext? context}) {
    List<ContentData>? content = homeModelData.contentData ?? [];
    widgetList.clear();
    for (var i = 0; i < content.length; i++) {
      switch (content[i].blockType) {
        case Constants.slider:
          widgetList.add(HomeTopBanners(contentData: content[i]));
          notifyListeners();
          break;
        case Constants.categories:
          widgetList.add(HomeCategoryStrip(
            updateTabIndex: () {
              // updateTabIndex(1);
            },
            categories: content[i].categories ?? [],
          ));
          notifyListeners();
          break;
        case Constants.advertisements:
          widgetList.add(AdvertisementList(
            index: i,
            contentData: content[i],
          ));
          break;
        case Constants.products:
          widgetList.add(ProductList(
            products: content[i].products ?? [],
            title: content[i].title ?? "",
            isHomeTile: true,
            isGrid: false,
            linkType: content[i].linkType ?? "",
            linkId: content[i].linkId ?? "",
          ));
          break;
        default:
          widgetList.add(const SizedBox());
          notifyListeners();
      }
    }
  }

  void updateCarouselIndex(int val) {
    carouselIndex = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  // @override
  // void updateTabIndex(int index) {
  //   controller.index = index;
  //   notifyListeners();
  // }
}
