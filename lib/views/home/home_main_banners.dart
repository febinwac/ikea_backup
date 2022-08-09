import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/extensions.dart';
import 'package:sfm_module/common/helpers.dart';

import '../../common/colors.dart';
import '../../common/nav_route.dart';
import '../../models/home_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/product_related_provider.dart';

class HomeTopBanners extends StatelessWidget {
  ContentData? contentData;

  HomeTopBanners({@required this.contentData});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    List<BannerModel> banners = Helpers.getBannerList(contentData);

    final List<Widget> imageSliders = banners
        .map((item) => InkWell(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: item.url,
                width: double.maxFinite,
                height: double.maxFinite,
              ),
              onTap: () async {
                String id = item.linkId;
                String linkType = item.linkType;
                if (linkType.isNotEmpty) {
                  if (linkType.toSmall() == "category") {
                    NavRoutes.navToCategoryDetailPage(context, catId: id);
                  } else {
                    NavRoutes.navToProductDetailPage(context,id);
                    Future.microtask(() => context
                        .read<ProductRelatedProvider>()
                        .clearData()
                        .then((value) {
                      NavRoutes.navToProductDetailPage(
                          context, id);
                    }));
                  }
                }
              },
            ))
        .toList();
    if (banners.isNotEmpty) {
      return Consumer<HomeProvider>(builder: (context, model, _) {
        return Container(
            width: double.maxFinite,
            color: HexColor(nearlyGrey),
            child: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                      aspectRatio: 1,
                      initialPage: 0,
                      viewportFraction: 1,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        model.updateCarouselIndex(index);
                      },
                      enableInfiniteScroll: false),
                  items: imageSliders,
                ),
                Positioned(
                  bottom: 0,
                  right: 17,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageSliders.asMap().entries.map((entry) {
                      return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: 6.0.w,
                            height: 6.0.h,
                            margin: EdgeInsets.symmetric(
                                vertical: 12.0.h, horizontal: 2.0.w),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                    model.carouselIndex == entry.key
                                        ? 1.0
                                        : 0.6)),
                          ));
                    }).toList(),
                  ),
                )
              ],
            ));
      });
    }
    return Container();
  }
}
