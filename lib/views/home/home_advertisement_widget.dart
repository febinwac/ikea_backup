import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';
import '../../models/home_model.dart';

class AdvertisementList extends StatelessWidget {
  int? index;
  ContentData? contentData;

  AdvertisementList({this.contentData, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h, left: 19.w, bottom: 22.h),
      height: 150.h,
      width: double.maxFinite,
      child: LayoutBuilder(
        builder: (_, constraints) {
          double width = constraints.maxWidth * 0.9;
          if (contentData?.content != null &&
              contentData?.content?.length == 1) {
            width = constraints.maxWidth;
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: contentData?.content?.length ?? 0,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return AdvertisementTile(
                contentData: contentData,
                index: index,
                size: contentData?.content?.length ?? 0,
                images: contentData?.content?[index],
                width: width,
                onTap: (Content images) {
                  String id = images.linkId ?? "";
                  String linkType = images.linkType ?? "";
                  if (linkType == "category") {
                    // Provider.of<HomeProvider>(buildContext, listen: false)
                    //     .getAllcategories(true, StringConstants.homeDataType,
                    //         productId: id,
                    //         fromContext: "banner",
                    //         context: buildContext);
                  }
                },
              );
            },
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            separatorBuilder: (_, __) => SizedBox(
              width: 9.w,
            ),
          );
        },
      ),
    );
  }
}

class AdvertisementTile extends StatelessWidget {
  int? size;
  int? index;
  double? width;
  Content? images;
  ContentData? contentData;
  Function onTap;

  AdvertisementTile(
      {required this.index,
      required this.width,
      required this.size,
      required this.images,
      required this.contentData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(child: _buildAdvImage());
  }

  Widget _buildAdvImage() {
    double paddingRgt = index == size! - 1 ? 19.0 : 0.0;
    return InkWell(
      onTap: onTap(images),
      child: Container(
        width: width,
        height: double.infinity,
        padding: EdgeInsets.only(right: paddingRgt),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: width,
            imageUrl: images?.image ?? "",
            placeholder: (context, url) => Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: HexColor(nearlyGrey),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: HexColor(nearlyGrey),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
