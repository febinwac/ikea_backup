import 'package:flutter/material.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/models/category_model.dart';
import 'package:sfm_module/models/product_model.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';

import '../common/helpers.dart';
import '../common/check_exception.dart';

class ProductRelatedProvider with ChangeNotifier, ProviderHelperClass {
  late ProductModel productModel;
  late ProductModel parentProductModel;
  List<MediaGallery>? mediaGallery = [];
  List<ProductModel>? othersBoughtList = [];
  List<AllCategories>? categoriesList = [];
  List<ProductModel>? productList = [];
  List<CategoryList>? categoryListForDetailApi;
  String imageBannerToShow = '';
  String titleToShow = '';
  Map<String, int> selectedVariantOptions = {};

  Future<void> getProductDetails(
      {String? sku,
      required BuildContext context,
      required bool isInitial}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic resp = await serviceConfig.getProductDetails(sku);
      print("getProductDetails $resp");
      updateLoadState(LoaderState.loaded);
      if (resp != null &&
          resp['products'] != null &&
          resp['products']['items'] != null) {
        ProductDetails productDetails =
            ProductDetails.fromJson(resp['products']);
        if (productDetails.items != null &&
            (productDetails.items ?? []).isNotEmpty) {
          productModel = productDetails.items![0];
          mediaGallery = productModel.mediaGallery ?? [];
          if (isInitial) {
            parentProductModel = productModel;
          }
          notifyListeners();
        }
      } else {
        Future.microtask(() {
          Check.checkException(resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getOthersBoughtList(BuildContext context, String cartId) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic resp = await serviceConfig.getOthersBroughtInCart(cartId);
      print("getOthersBroughtInCart $resp");
      updateLoadState(LoaderState.loaded);
      if (resp != null && resp['cart'] != null) {
        OthersBoughtData data = OthersBoughtData.fromJson(resp['cart']);
        othersBoughtList = data.boughtTogetherList ?? [];
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getAllCategories(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic resp = await serviceConfig.getAllCategories();
      print("getAllCategories $resp");
      updateLoadState(LoaderState.loaded);
      if (resp != null && resp['Allcategories'] != null) {
        CategoryData data = CategoryData.fromJson(resp);
        if ((data.allcategories ?? []).isNotEmpty) {
          categoriesList = data.allcategories ?? [];
        }
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getProductListing(String catId, BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic resp = await serviceConfig.getProductListing(catId);
      print("getProductListing $resp");
      updateLoadState(LoaderState.loaded);
      if (resp != null && resp['products'] != null) {
        print("getProductListing ${resp['products']}");
        print("getProductListing ${resp['categoryList']}");
        CategoryDetailData data = CategoryDetailData.fromJson(resp);
        if (data.products != null &&
            (data.products?.productList ?? []).isNotEmpty) {
          productList = data.products?.productList ?? [];
        }
        if ((data.categoryList ?? []).isNotEmpty) {
          categoryListForDetailApi = data.categoryList ?? [];
          imageBannerToShow = categoryListForDetailApi?.first.bannerImage ?? "";
          titleToShow = categoryListForDetailApi?.first.name ?? "";
        }
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    print(state);

    loaderState = state;
    notifyListeners();
  }

  Future<void> clearData() async {
    productModel = ProductModel();
    selectedVariantOptions={};
    mediaGallery = [];
  }

  updateVariantSelected(String key, int value) {
    selectedVariantOptions[key] = value;
    notifyListeners();
  }

  void validateConfigurableProduct(
      List<Variants> variants, BuildContext context, String cartId) {
    ProductModel? product;
    for (Variants? variant in variants) {
      if (variant?.attributes != null && product == null) {
        for (Attributes? element in variant!.attributes!) {
          selectedVariantOptions.forEach((key, value) {
            if ((element?.code ?? '') == key &&
                (element?.valueIndex ?? '') == value) {
              product = variant.product;
            }
          });
        }
      }
    }
    if (product != null) {
      product = product!.copyWith(previousItem: parentProductModel);
      productModel = product!;
      notifyListeners();
    }
  }
}
