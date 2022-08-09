import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/models/category_model.dart';

import '../../common/colors.dart';
import '../../common/common_error_page.dart';
import '../../common/constants.dart';
import '../../common/nav_route.dart';
import '../../providers/product_related_provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    Future.microtask(
        () => context.read<ProductRelatedProvider>().getAllCategories(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ProductRelatedProvider>(
            builder: (context, detailModel, child) {
          if (detailModel.loaderState == LoaderState.loading) {
            return _categoryLoader();
          }
          if (detailModel.loaderState == LoaderState.networkErr ||
              detailModel.loaderState == LoaderState.error) {
            return CommonErrorPage(
              loaderState: detailModel.loaderState,
              onButtonTap: () => {},
            );
          }
          return categoryBodyWidget(detailModel);
        }),
      ),
    );
  }

  categoryBodyWidget(ProductRelatedProvider detailModel) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(Constants.browseByCategory,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HexColor(boldBlack))),
            ),
            Expanded(
                child: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildCategoryList(detailModel.categoriesList ?? []),
                ],
              ),
            ])),
          ],
        ));
  }

  AppBar appBar() {
    return AppBar(
      title: Text(Constants.browseByCategory,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor(boldBlack))),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildCategoryList(List<AllCategories> categoriesList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0,
                    childAspectRatio: 3 / 3),
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  double width = MediaQuery.of(context).size.width * .28;
                  return CategoryCard(
                    width: width,
                    index: index,
                    allCategories: categoriesList[index],
                    onTap: () {
                      NavRoutes.navToCategoryDetailPage(context,
                          catId: categoriesList[index].id ?? "");
                    },
                  );
                })),
        SizedBox(
          height: 19.h,
        )
      ],
    );
  }

  Widget _categoryLoader() {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24.0, horizontal: 5),
                  child: Text(Constants.browseByCategory,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HexColor(boldBlack))),
                ),
                Expanded(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0.0),
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 9.0,
                                    mainAxisSpacing: 9.0,
                                    childAspectRatio: 3 / 3),
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return const CommonContainerShimmer();
                            }))),
              ],
            )),
        CommonLinearLoader()
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  int? index;
  double? width;
  AllCategories? allCategories;
  Function()? onTap;

  CategoryCard({this.allCategories, this.index, this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: HexColor(nearlyGrey),
            borderRadius: BorderRadius.circular(5)),
        width: double.infinity,
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Padding(
              padding: EdgeInsets.all(constraints.maxHeight * 0.1),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProductImage(context),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    _buildProductTitle(),
                  ]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    String name = allCategories?.name ?? "";
    return Text(
      name.isNotEmpty ? '$name+\n' : '\n',
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: HexColor(black)),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ClipRRect(
          child: SizedBox.expand(
        child: SizedBox(
          width: width,
          child: CachedNetworkImage(
            imageUrl: allCategories?.image ?? "",
            fit: BoxFit.contain,
            placeholder: (context, url) => const CommonContainerShimmer(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      )),
    );
  }
}
