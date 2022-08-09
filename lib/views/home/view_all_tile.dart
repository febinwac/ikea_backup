import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/models/product_model.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/nav_route.dart';
import '../../models/home_model.dart';

class ViewAllTile extends StatelessWidget {
  String? title;
  String? linkType;
  String? linkId;
  List<ProductModel>? products;

  ViewAllTile(
      {@required this.title,
      @required this.linkType,
      @required this.linkId,
      this.products});

  String homeLogo = 'assets/images/home_logo.png';
  String searchTabIcon = 'assets/icons/search.png';
  String markerIcon = 'assets/icons/marker.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin:
          EdgeInsets.only(left: 28.w, top: 14.h, bottom: 14.h, right: 14.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  color: HexColor(boldBlack),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 15.0.w,
          ),
          InkWell(
            splashColor: HexColor(viewAllGrey),
            onTap: () {
              NavRoutes.navToCategoryDetailPage(context, catId: linkId ?? "");
            },
            child: Container(
              padding: EdgeInsets.all(5.w),
              child: products?.length == 1
                  ? Container()
                  : Text(
                      Constants.viewAll,
                      style: TextStyle(
                          fontSize: 14,
                          color: HexColor('#8C8C8C'),
                          fontWeight: FontWeight.normal),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
