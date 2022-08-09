import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/views/home/product_tile.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/colors.dart';
import '../../common/common_error_page.dart';
import '../../common/constants.dart';
import '../../common/nav_route.dart';
import '../../models/product_model.dart';
import '../../providers/product_related_provider.dart';
import '../widgets/empty_app_bar.dart';

class CategoryDetailScreen extends StatefulWidget {
  String catId;

  CategoryDetailScreen({required this.catId});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  @override
  void initState() {
    Future.microtask(() => context
        .read<ProductRelatedProvider>()
        .getProductListing(widget.catId, context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      backgroundColor: Colors.white,
      body: Consumer<ProductRelatedProvider>(
          builder: (context, detailModel, child) {
        if (detailModel.loaderState == LoaderState.loading) {
          return _productListingLoader();
        }
        if (detailModel.loaderState == LoaderState.networkErr ||
            detailModel.loaderState == LoaderState.error) {
          return CommonErrorPage(
            loaderState: detailModel.loaderState,
            onButtonTap: () => {},
          );
        }
        if (detailModel.loaderState == LoaderState.loaded) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                        icon: detailModel.imageBannerToShow.isNotEmpty
                            ? innerBoxIsScrolled
                                ? const Icon(
                                    Icons.arrow_back_ios,
                                    size: 15,
                                    color: Colors.black,
                                  )
                                : Container(
                                    height: 36.h,
                                    width: 36.h,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.arrow_back_sharp,
                                      color: Colors.black,
                                    ))
                            : const Icon(
                                Icons.arrow_back_ios,
                                size: 15,
                                color: Colors.black,
                              ),
                        onPressed: () => Navigator.pop(context)),
                    title: detailModel.imageBannerToShow.isNotEmpty
                        ? const Text("")
                        : Text(
                            detailModel.titleToShow,
                            style: FontStyle.black13Bold,
                            textAlign: TextAlign.center,
                          ),
                    backgroundColor: Colors.white,
                    leadingWidth: 75.w,
                    expandedHeight: detailModel.imageBannerToShow.isNotEmpty
                        ? (214.0.h + kToolbarHeight)
                        : 0.0.h,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: detailModel.imageBannerToShow.isNotEmpty
                        ? FlexibleSpaceBar(
                            centerTitle: true,
                            titlePadding: EdgeInsets.zero,
                            title: innerBoxIsScrolled
                                ? Container(
                                    alignment: Alignment.center,
                                    height: kToolbarHeight,
                                    color: Colors.white,
                                    width: double.maxFinite,
                                    child: Text(
                                      detailModel.titleToShow,
                                      style: FontStyle.black13Bold,
                                      textAlign: TextAlign.center,
                                    ))
                                : Container(
                                    padding: EdgeInsets.only(left: 28.w),
                                    alignment: Alignment.centerLeft,
                                    height: kToolbarHeight,
                                    color: Colors.white,
                                    width: double.maxFinite,
                                    child: Text(
                                      detailModel.titleToShow,
                                      style: FontStyle.black13Bold,
                                      textAlign: TextAlign.center,
                                    )),
                            background: CachedNetworkImage(
                              fit: BoxFit.cover,
                              fadeInDuration:
                                  const Duration(milliseconds: 1000),
                              width: MediaQuery.of(context).size.width,
                              height: double.infinity,
                              imageUrl: detailModel.imageBannerToShow,
                              placeholder: (context, url) =>
                                  const CommonContainerShimmer(),
                              errorWidget: (context, url, error) =>
                                  const CommonContainerShimmer(),
                            ))
                        : const SizedBox(),
                  ),
                ];
              },
              body: detailWidget(detailModel),
            ),
          );
        }

        return const SizedBox();
      }),
    );
  }

  detailWidget(ProductRelatedProvider detailModel) {
    List<ProductModel>? productList = detailModel.productList ?? [];
    if (productList.isNotEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(0.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.48),
        itemCount: (detailModel.productList ?? []).length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: HexColor('#DFDFDF'), width: 0.5)),
            child: ProductTile(
                isHomeTile: true,
                isGrid: true,
                image: detailModel.productList?[index].image ?? "",
                index: index,
                productLength: (detailModel.productList ?? []).length,
                addToCart: () {},
                navigateToAddOn: () {},
                productModel: productList[index],
                showQuantityDialog: () {},
                onTap: () async {
                  Future.microtask(() => context
                          .read<ProductRelatedProvider>()
                          .clearData()
                          .then((value) {
                        NavRoutes.navToProductDetailPage(
                            context, productList[index].sku ?? "");
                      }));
                }),
          );
        },
      );
    }
    return const SizedBox();
  }

  Widget _productListingLoader() {
    return Shimmer.fromColors(
      baseColor: HexColor(nearlyGrey),
      highlightColor: Colors.white,
      direction: ShimmerDirection.ltr,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
              width: double.maxFinite,
              height: 200.h,
              child: const CommonContainerShimmer()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Row(
              children: const [
                CommonCircularShimmer(
                  val: 0.6,
                ),
              ],
            ),
          ),
          GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.55),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#DFDFDF'), width: 0.5)),
                padding: const EdgeInsets.all(20.0),
                child: LayoutBuilder(
                  builder: (_, constraints) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth,
                          child: const CommonContainerShimmer()),
                      const CommonCircularShimmer(
                        val: 0.3,
                      ),
                      const CommonCircularShimmer(
                        val: 0.2,
                      ),
                      const CommonCircularShimmer(
                        val: 0.1,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(nearlyGrey)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}


