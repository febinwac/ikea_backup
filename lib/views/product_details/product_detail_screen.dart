import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/models/product_model.dart';
import 'package:sfm_module/services/app_data.dart';
import 'package:sfm_module/views/product_details/variant_tile.dart';

import '../../common/colors.dart';
import '../../common/common_error_page.dart';
import '../../common/common_loader.dart';
import '../../common/constants.dart';
import '../../common/linear_page_indicator.dart';
import '../../providers/product_related_provider.dart';
import '../main_view/sfm_switcher_widget.dart';
import '../widgets/divider_view.dart';
import '../widgets/expansion_tile.dart';
import '../widgets/quantity_widget.dart';
import '../widgets/custom_button_blue.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends StatefulWidget {
  String sku;

  ProductDetailScreen({required this.sku});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey expansionTileKey = GlobalKey();

  @override
  void initState() {
    Future.microtask(() => context.read<ProductRelatedProvider>()
      ..getProductDetails(sku: widget.sku, context: context,isInitial: true)
      ..getOthersBoughtList(context, AppData.cartId));
    super.initState();
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
          icon: Image.asset(
            Constants.backIcon,
            height: 25,
            width: 25,
          ),
          onPressed: () => Navigator.pop(context)),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Consumer<ProductRelatedProvider>(
          builder: (context, detailModel, child) {
        if (detailModel.loaderState == LoaderState.loading) {
          return _productDetailsLoader();
        }
        if (detailModel.loaderState == LoaderState.networkErr ||
            detailModel.loaderState == LoaderState.error) {
          return CommonErrorPage(
            loaderState: detailModel.loaderState,
            onButtonTap: () => {},
          );
        }
        return detailsBodyWidget(detailModel);
      }),
    );
  }

  detailsBodyWidget(ProductRelatedProvider detailModel) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: SfmSwitcherWidget(),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(20.0.w),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              LinearProgressImageIndicator(
                  mediaGallery: detailModel.productModel.mediaGallery),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(detailModel.productModel.familyName ?? "",
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            color: HexColor(boldBlack))),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(detailModel.productModel.productName ?? "",
                        style: FontStyle.boldBlack12),
                  ),
                ],
              ),
              SizedBox(height: 11.h),
              DetailsAmount(
                productModel: detailModel.productModel,
              ),
              (detailModel.productModel.configurableOptions ?? []).isNotEmpty &&
                      (detailModel.productModel.variants ?? []).isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 11.h),
                        const DividerView(
                          edgeInsetsGeometry: EdgeInsets.all(0),
                        ),
                        variantWidget(
                            detailModel.productModel.configurableOptions ?? [],
                            detailModel.productModel.variants ?? [],
                            detailModel)
                      ],
                    )
                  : const SizedBox(),
              SizedBox(height: 11.h),
              const DividerView(
                edgeInsetsGeometry: EdgeInsets.all(0),
              ),
              showDescription(detailModel.productModel),
            ],
          )),
          Container(
            height: Platform.isIOS ? 55.h : 50.h,
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
            margin: EdgeInsets.only(bottom: 15.0.h),
            child: Row(
              children: [
                (detailModel.productModel.quantity ?? 0) > 1
                    ? QuantityWidget(
                        context: context,
                        quantity: 0,
                        onQuantitySelection: () {})
                    : const SizedBox(),
                Expanded(
                  child: CustomButton(
                      raisedBtnColour: HexColor(primaryColor),
                      width: MediaQuery.of(context).size.width,
                      buttonText: Constants.addToBag,
                      textSize: Platform.isIOS ? 15 : 14,
                      height: Platform.isIOS ? 55 : 50,
                      onPressed: () async {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showDescription(ProductModel? productModel) {
    String htmlContent = productModel?.descriptionForDetails?.html ?? "";
    return htmlContent.isNotEmpty
        ? Column(
            children: [
              DetailsExpansionTile(
                  title: Constants.description,
                  expansionTileKey: expansionTileKey,
                  onExpansionChanged: (value) {
                    if (value) {
                      _scrollToSelectedContent(
                          expansionTileKey: expansionTileKey);
                    }
                  },
                  expand: true,
                  children: <Widget>[
                    SizedBox(
                      height: 16.0.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: HtmlWidget(
                        htmlContent,
                        textStyle: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            fontWeight: FontWeight.normal,
                            color: HexColor(subTitleColor)),
                      ),
                    ),
                  ]),
              const DividerView(
                edgeInsetsGeometry: EdgeInsets.all(0),
              ),
            ],
          )
        : Container();
  }

  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  Widget othersBrought() {
    return Consumer<ProductRelatedProvider>(builder: (context, data, child) {
      if ((data.othersBoughtList ?? []).isNotEmpty &&
          (data.othersBoughtList ?? []).length == 1 &&
          widget.sku == data.othersBoughtList?.first.sku) {
        return const SizedBox();
      } else {
        return _othersBoughtProductWidget(data.othersBoughtList ?? []);
      }
    });
  }

  Widget _othersBoughtProductWidget(List<ProductModel> productItems) {
    return const SizedBox();
  }

  Widget _productDetailsLoader() {
    final _size = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: HexColor(nearlyGrey),
      highlightColor: Colors.white,
      direction: ShimmerDirection.ltr,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              LinearProgressImageIndicator(
                mediaGallery: [],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: _size * 0.3),
                          child: const CommonCircularShimmer(),
                        ),
                        const SizedBox(height: 11),
                        Padding(
                          padding: EdgeInsets.only(right: _size * 0.6),
                          child: const CommonCircularShimmer(),
                        ),
                        const SizedBox(height: 30),
                        const DividerView(
                          edgeInsetsGeometry: EdgeInsets.all(0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: _size * 0.6, top: 25, bottom: 25),
                          child: const CommonCircularShimmer(),
                        ),
                        const DividerView(
                          edgeInsetsGeometry: EdgeInsets.all(0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: _size * 0.6, top: 25, bottom: 25),
                          child: const CommonCircularShimmer(),
                        ),
                        const DividerView(
                          edgeInsetsGeometry: EdgeInsets.all(0),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          CommonLinearLoader()
        ],
      ),
    );
  }
}

variantWidget(List<ConfigurableOptions>? configurableOptions,
    List<Variants>? variants, ProductRelatedProvider detailModel) {
  if (configurableOptions == null || configurableOptions.isEmpty) {
    return const SizedBox();
  } else {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (cxt, index) {
          ConfigurableOptions configurableOption = configurableOptions[index];
          if (configurableOption == null) {
            return const SizedBox();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    configurableOption.label ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: HexColor(boldBlack)),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: configurableOption.values?.length ?? 0,
                    itemBuilder: (cxt, index) {
                      ConfigurableOptionValues? value =
                          configurableOption.values?[index];
                      int length = configurableOption.values?.length ?? 0;
                      bool isSelected = detailModel.selectedVariantOptions[
                              configurableOption.attributeCode ?? ''] ==
                          (value?.valueIndex ?? -1);
                      if (value == null) {
                        return const SizedBox();
                      }
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: VariantTile(
                          onTap: () {
                            detailModel.updateVariantSelected(
                                configurableOption.attributeCode ?? '',
                                value.valueIndex ?? -1);
                            detailModel.validateConfigurableProduct(
                                variants ?? [], cxt, AppData.cartId);
                          },
                          isSelected: isSelected,
                          edgeInsetsGeometry: index == 0
                              ? EdgeInsets.zero
                              : index == length - 1
                                  ? EdgeInsets.zero
                                  : EdgeInsets.only(left: 8.w),
                          index: index,
                          label: value.label,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(
                      width: 10.w,
                    ),
                  ),
                ),
              ],
            );
          }
        },
        separatorBuilder: (_, __) => const DividerView(
              edgeInsetsGeometry: EdgeInsets.all(0),
            ),
        itemCount: configurableOptions.length);
  }
}

class DetailsAmount extends StatelessWidget {
  ProductModel? productModel;

  DetailsAmount({
    this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return productModel != null ? checkIkeaFamily() : const SizedBox();
  }

  Widget _buildProductAmount() {
    var defaultPrice = 0;
    return Text(
      "${productModel?.priceRange?.minimumPrice?.finalPrice?.value ?? 0}",
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: FontStyle.productDetailsAmtStyle,
    );
  }

  Widget _buildProductCurrency() {
    return Text(
      AppData.currencySymbol ?? "",
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: FontStyle.title,
    );
  }

  Widget _buildAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
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
            _buildProductAmount(),
          ],
        ),
      ],
    );
  }

  checkIkeaFamily() {
    if ((productModel?.ikeaFamilyPrice ?? 0) > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIkeaProductAmount(productModel?.ikeaFamilyPrice.toString()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constants.ikeaFamily,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontStyle.ikeaFamilyStyle,
              ),
              ikeaRegularPrice()
            ],
          )
        ],
      );
    } else if (productModel?.priceRange?.minimumPrice?.regularPrice != null &&
        productModel?.priceRange?.minimumPrice?.finalPrice != null) {
      if (productModel?.priceRange?.minimumPrice?.regularPrice!.value ==
          productModel?.priceRange?.minimumPrice?.finalPrice?.value) {
        return _buildAmountWidget();
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAmountWidget(),
            const SizedBox(width: 10),
            Text(
                "${AppData.currencySymbol} ${productModel?.priceRange?.minimumPrice?.regularPrice?.value ?? 0}",
                style: FontStyle.strikeText)
          ],
        );
      }
    }
    return const SizedBox();
  }

  Widget ikeaRegularPrice() {
    var defaultPrice = 0;
    return Row(children: [
      Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(Constants.regularPrice,
              style: FontStyle.productRegularPrice)),
      Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            "${AppData.currencySymbol} ${productModel?.priceRange != null ? productModel?.priceRange!.minimumPrice != null ? productModel?.priceRange!.minimumPrice!.regularPrice != null ? productModel?.priceRange!.minimumPrice!.regularPrice!.value != null ? productModel?.priceRange!.minimumPrice!.regularPrice!.value.toString() : defaultPrice : defaultPrice : defaultPrice : defaultPrice}",
            style: FontStyle.productRegularPrice,
          ))
    ]);
  }

  Widget _buildIkeaProductAmount(var ikeaFamilyPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 12, 8, 0),
          child: Wrap(
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
                ikeaFamilyPrice,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontStyle.categoryProductAmtStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
