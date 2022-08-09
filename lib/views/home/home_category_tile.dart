import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/helpers.dart';
import 'package:sfm_module/views/main_view/main_screen.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/nav_route.dart';
import '../../models/category_model.dart';
import '../../models/home_model.dart';

class HomeCategoryStrip extends StatelessWidget {
  List<Categories> categories = [];
  List<Widget>? categoryTile = [];
  VoidCallback? updateTabIndex;

  HomeCategoryStrip(
      {Key? key, required this.categories, required this.updateTabIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      categoryTile?.clear();
      categoryTile?.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: HexColor(black),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text(
                'Featured',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: HexColor(white)),
              ),
            ),
          ],
        ),
      );
      for (var i = 0; i < categories.length; i++) {
        categoryTile?.add(Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 12.0.h),
                backgroundColor: HexColor(nearlyGrey),
                primary: HexColor(black),
                textStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: HexColor(black)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                NavRoutes.navToCategoryDetailPage(context,
                    catId: categories[i].categoryId ?? "");
              },
              child: Text(
                categories[i].categoryName ?? '',
              ),
            )
          ],
        ));
      }
      if ((categoryTile ?? []).isNotEmpty) {
        categoryTile?.add(Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 12.0.h),
                backgroundColor: HexColor(nearlyGrey),
                primary: HexColor(black),
                textStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: HexColor(black)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: updateTabIndex,
              child: const Text(
                Constants.viewAll,
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ));
      }
    }
    return Container(
      width: double.maxFinite,
      height: 84,
      alignment: Alignment.center,
      child: categories != null
          ? ListView.separated(
              padding: const EdgeInsets.all(0.0),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return categoryTile![index];
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  width: 9.0,
                );
              },
              itemCount: categoryTile!.length)
          : ListView.separated(
              padding: const EdgeInsets.all(0.0),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (index == 0)
                      const SizedBox(
                        width: 20,
                      ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: BoxDecoration(
                          color: HexColor(nearlyGrey),
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  width: 9.0,
                );
              },
              itemCount: 4),
    );
  }

  Future convertToAllCategories() async {
    List<AllCategories> allCategories = [];
    for (var element in categories) {
      allCategories.add(AllCategories(
        name: element.categoryName,
        id: element.categoryId,
        image: element.categoryImage,
      ));
    }
    return allCategories;
  }
}
