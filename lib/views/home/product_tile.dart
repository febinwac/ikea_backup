import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/common/nav_route.dart';
import 'package:sfm_module/models/product_model.dart';
import 'package:sfm_module/providers/product_related_provider.dart';
import 'package:sfm_module/services/app_data.dart';
import 'package:sfm_module/views/home/view_all_tile.dart';
import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/font_styles.dart';
import '../../models/home_model.dart';

class ProductList extends StatelessWidget {
  String? title;
  String? linkType;
  String? linkId;
  List<ProductModel> products;
  bool isHomeTile;
  bool isGrid;

  // int? dataIndex;
  // int? length;
  // ContentData? contentData;
  //
  ProductList({
    this.title,
    this.linkType,
    this.linkId,
    required this.products,
    required this.isHomeTile,
    required this.isGrid,
    // this.length,
    // this.contentData
  });

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ViewAllTile(
            title: title ?? "",
            linkId: linkId,
            linkType: linkType,
            products: products),
        SizedBox(
          height: 410.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductTile(
                  isHomeTile: isHomeTile,
                  isGrid: isGrid,
                  image: products[index].image ?? "",
                  index: index,
                  productLength: products.length,
                  addToCart: () {},
                  navigateToAddOn: () {},
                  productModel: products[index],
                  showQuantityDialog: () {},
                  onTap: () async {
                    Future.microtask(() =>
                        context
                            .read<ProductRelatedProvider>()
                            .clearData()
                            .then((value) {
                          NavRoutes.navToProductDetailPage(
                              context, products[index].sku ?? "");
                        }));
                  });

/*              return Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? 12.w : 0,
                    right: (product?.length ?? 0) - 1 == index ? 12.w : 0),
                width: 20.w,
                color: Colors.yellow,
                height: 20,
              );*/
            },
          ),
        ),
      ],
    )
        : const SizedBox();
  }
}

class ProductTile extends StatelessWidget {
  String image;
  int index;
  Function() addToCart;
  Function() onTap;
  Function() navigateToAddOn;
  Function() showQuantityDialog;
  int productLength;
  ProductModel productModel;
  bool isHomeTile;
  bool isGrid;
  bool isAddToCartLoading;

  ProductTile({
    required this.image,
    required this.index,
    required this.productLength,
    required this.addToCart,
    required this.navigateToAddOn,
    required this.productModel,
    required this.showQuantityDialog,
    required this.onTap,
    this.isHomeTile = false,
    this.isGrid = false,
    this.isAddToCartLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(
                top: isGrid ? 0.0 : 10.h,
                bottom: isGrid ? 0.0 : 10.h,
                left: index == 0 ? 5.h : 0,
                right: index == productLength - 1 ? 5.h : 0),
            decoration: isHomeTile
                ? const BoxDecoration(color: Colors.white)
                : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            width: (MediaQuery
                .of(context)
                .size
                .width - 48) * 0.55,
            height: double.infinity,
            child: Stack(
              children: [
                isHomeTile
                    ? (productModel.tirePrice?.ikeaFamilyPrice ?? 0.0) > 0.0
                    ? Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.h),
                        height: 23.h,
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: HexColor("#057BC1"),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.r),
                                topLeft: Radius.circular(4.r)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0,
                                    3), // changes position of shadow
                              ),
                            ]),
                        child: const Text(
                          Constants.ikeaFamPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.h),
                        height: 2,
                        color: HexColor("#FFE63C"),
                      )
                    ],
                  ),
                )
                    : const SizedBox()
                    : const SizedBox(),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: (120.w),
                          height: (120.h),
                          child: _buildProductImage()),
                      _productOffer(),
                      isGrid ? _showIsIkeaFamily() : const SizedBox(),
                      _buildProductTitle(),
                      _buildSubProductTitle(),
                      _buildProductAmount(),
                      const Spacer(),
                      SizedBox(
                        height: 40.h,
                        child: productModel.isAddedToCart
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            (productModel.addOnProducts ?? []).isNotEmpty
                                ? _buildAddOnWidget()
                                : const SizedBox(),
                            _buildQuantityWidget(),
                          ],
                        )
                            : Row(
                          children: [
                            const Spacer(),
                            _buildAddToCart(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildProductImage() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 18, bottom: 28),
      child: CachedNetworkImage(
        imageUrl: isGrid
            ? productModel.smallImage?.mobileApp ?? ''
            : productModel.image ?? "",
        fit: BoxFit.contain,
        errorWidget: (context, url, error) => const CommonContainerShimmer(),
        placeholder: (context, url) => const CommonContainerShimmer(),
      ),
    );
  }

  _productOffer() {
    int offPercentage;
    if (isGrid) {
      offPercentage =
          productModel.priceRange?.minimumPrice?.discount?.percentOff ?? 0;
    } else {
      offPercentage = productModel.discountPercentage ?? 0;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (productModel.tag ?? "").isNotEmpty
            ? Container(
            color: HexColor(orange),
            margin: const EdgeInsets.only(right: 5.0, bottom: 3.0),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: Text(
              "${productModel.tag}",
              style: FontStyle.white11Bold,
            ))
            : const SizedBox(),
        offPercentage != 0
            ? Container(
            color: HexColor(darkRed),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            margin: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              "$offPercentage%",
              style: FontStyle.white11Bold,
            ))
            : Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            margin: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              "",
              style: FontStyle.white11Bold,
            )),
      ],
    );
  }

  Widget _buildProductTitle() {
    return Row(
      children: [
        Flexible(
          child: Text(
            "${productModel.familyName ?? ""}\n",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: HexColor(black)),
          ),
        ),
      ],
    );
  }

  Widget _buildSubProductTitle() {
    return Row(
      children: [
        Flexible(
          child: Text(
            ("${productModel.productName ?? ""}\n\n"),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: Platform.isIOS ? 13 : 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: HexColor('#484848')),
          ),
        ),
      ],
    );
  }

  Widget _buildProductAmount() {
    if (isGrid) {
      return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: [
            productModel.ikeaFamilyPrice != null &&
                (productModel.ikeaFamilyPrice ?? 0.0) > 0.0
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountWithCurrency(
                    productModel.ikeaFamilyPrice ?? 0.0),
                ikeaRegularPrice()
              ],
            )
                : (productModel.priceRange?.minimumPrice?.regularPrice?.value ??
                0.0) ==
                (productModel
                    .priceRange?.minimumPrice?.finalPrice?.value ??
                    0.0)
                ? _buildAmountWithCurrency(productModel
                .priceRange?.minimumPrice?.finalPrice?.value ??
                0.0)
                : const SizedBox(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: [
            productModel.tirePrice?.ikeaFamilyPrice != null &&
                (productModel.tirePrice?.ikeaFamilyPrice ?? 0.0) > 0.0
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountWithCurrency(
                    productModel.tirePrice?.ikeaFamilyPrice ?? 0.0),
                ikeaRegularPrice()
              ],
            )
                : (productModel.priceRange?.maximumPrice?.regularPrice?.value ??
                0.0) ==
                (productModel
                    .priceRange?.maximumPrice?.finalPrice?.value ??
                    0.0)
                ? _buildAmountWithCurrency(productModel
                .priceRange?.maximumPrice?.finalPrice?.value ??
                0.0)
                : const SizedBox(),
          ],
        ),
      );
    }
  }

  Widget _buildProductCurrency() {
    return Text(
      AppData.currencySymbol ?? "",
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isHomeTile
          ? (productModel.tirePrice?.ikeaFamilyPrice ?? 0.0) > 0.0
          ? FontStyle.priceBoldBlue
          : FontStyle.priceBold
          : FontStyle.priceBold,
    );
  }

  Widget _buildAddToCart() {
    return GestureDetector(
      onTap: addToCart,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: HexColor(blueTitleColor),
        ),
        width: 40.0,
        height: 40.0,
        child: productModel.isAddToCartLoading
            ? Center(
          child: Lottie.asset(Constants.bouncingBallIcon,
              height: 40, width: 40, fit: BoxFit.fill),
        )
            : Padding(
          padding: EdgeInsets.all(8.h),
          child: Image.asset(Constants.cartBagIcon),
        ),
      ),
    );
  }

  Widget _buildWishListIcon() {
    return Positioned(
      child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 25,
              width: 35,
              margin: EdgeInsets.only(right: 7.w, top: 10.h),
              child: Image.asset(Constants.heartOutline),
            ),
          )),
    );
  }

  _showIsIkeaFamily() {
    return
      Row(
        children: [
          Flexible(
            child: Text(
              (productModel.ikeaFamilyPrice ?? 0) > 0? Constants.ikeaFamily:"",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: HexColor(blueTitleColor),
              ),
            ),
          ),
        ],
      );
  }

  _buildAddOnWidget() {
    return GestureDetector(
      onTap: navigateToAddOn,
      child: Container(
        padding: EdgeInsets.all(5.h),
        alignment: Alignment.center,
        child: Text(
          Constants.addOn,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: Platform.isIOS ? 13 : 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              color: HexColor('#484848')),
        ),
      ),
    );
  }

  _buildQuantityWidget() {
    return GestureDetector(
      onTap: showQuantityDialog,
      child: Container(
        padding:
        EdgeInsets.only(left: 20.w, right: 17.w, top: 8.h, bottom: 8.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: HexColor(viewGrey), width: 1.0.w),
          borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              productModel.quantity.toString(),
              style: FontStyle.productSubTitleStyle,
            ),
            SizedBox(
              height: 18.h,
              width: 18.h,
              child: Image.asset(Constants.down_arrow),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmountWithCurrency(double value) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 1.5,
      runSpacing: 2.0,
      verticalDirection: VerticalDirection.down,
      textDirection: TextDirection.ltr,
      children: [
        _buildProductCurrency(),
        const SizedBox(
          width: 1,
        ),
        Text(
          ("$value"),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isHomeTile
              ? (productModel.tirePrice?.ikeaFamilyPrice ?? 0.0) > 0.0
              ? FontStyle.blue26Bold
              : FontStyle.black26Bold
              : FontStyle.black26Bold,
        ),
      ],
    );
  }

  Widget ikeaRegularPrice() {
    var defaultPrice = 0;
    return Row(children: [
      Text(Constants.regularPrice, style: FontStyle.lightBlack12),
      Text(
        isGrid
            ? " ${AppData.currencySymbol ?? ""} ${productModel.priceRange !=
            null ? productModel.priceRange?.minimumPrice != null ? productModel
            .priceRange?.minimumPrice?.regularPrice != null ? productModel
            .priceRange?.minimumPrice?.regularPrice?.value != null
            ? productModel.priceRange?.minimumPrice?.regularPrice?.value
            .toString()
            : defaultPrice : defaultPrice : defaultPrice : defaultPrice}"
            : " ${AppData.currencySymbol ?? ""} ${productModel.priceRange !=
            null ? productModel.priceRange?.maximumPrice != null ? productModel
            .priceRange?.maximumPrice?.regularPrice != null ? productModel
            .priceRange?.maximumPrice?.regularPrice?.value != null
            ? productModel.priceRange?.maximumPrice?.regularPrice?.value
            .toString()
            : defaultPrice : defaultPrice : defaultPrice : defaultPrice}",
        style: FontStyle.lightBlack12,
      )
    ]);
  }
}
