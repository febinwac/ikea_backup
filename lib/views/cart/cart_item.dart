import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/common/font_styles.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../models/cart_model.dart';
import '../widgets/add_on_yellow_button.dart';
import '../widgets/quantity_picker_dialog.dart';

class CartItem extends StatelessWidget {
  BuildContext context;
  int? index;
  String? currency;
  CartItems? cartItem;
  Function? removeItem;
  Function()? addOnClick;
  Function? updateQuantity;
  int currentValue = 1;

  CartItem(
      {required this.index,
      required this.currency,
      required this.cartItem,
      required this.removeItem,
      required this.addOnClick,
      required this.updateQuantity,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 92.h,
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 9.w, right: 20.w),
        child: Row(
          children: [
            _buildImage(context),
            SizedBox(
              width: 5.w,
            ),
            _buildRemWidgets(),
            SizedBox(
              width: 5.w,
            ),
            _buildRemoveAndPriceWidget()
          ],
        ));
  }

  _buildImage(BuildContext context) {
    return SizedBox(
      width: 92.w,
      height: 92.h,
      child: CachedNetworkImage(
        fit: BoxFit.contain,
        imageUrl: cartItem?.product?.smallImage?.mobileApp ?? "",
        placeholder: (context, url) => const CommonContainerShimmer(),
        errorWidget: (context, url, error) => const CommonContainerShimmer(),
      ),
    );
  }

  _buildRemWidgets() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameWidget(),
        Row(
          children: [
            _buildQtyWidget(),
            (cartItem?.product?.upsellProducts??[]).isNotEmpty
                ? AddOnYellowButton(
                    addOnClick: addOnClick,
                    changeStyle: false,
                  )
                : Container()
          ],
        ),
      ],
    ));
  }

  _buildNameWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h),
      child: Column(
        children: [
          if (cartItem?.product?.familyName != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    cartItem?.product?.familyName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyle.productCategory,
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  cartItem?.product?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: HexColor('#484848')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildQtyWidget() {
    return GestureDetector(
      child: Row(
        children: [
          Container(
            padding:
                EdgeInsets.only(left: 20.w, right: 17.r, top: 9.h, bottom: 9.h),
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
                  "${cartItem?.quantity ?? 0}",
                  style: FontStyle.black12Bold,
                ),
                SizedBox(
                  height: 18.h,
                  width: 18.w,
                  child: Image.asset(Constants.down_arrow),
                )
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        showQuantityDialog();
      },
    );
  }

  _buildPriceWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Text(
        "$currency ${cartItem?.prices?.rowTotalIncludingTax?.value ?? ""}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: FontStyle.productTitleStyle,
        textAlign: TextAlign.end,
      ),
    );
  }

  _buildRemoveAndPriceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_buildRemoveWidget(), _buildPriceWidget()],
    );
  }

  _buildRemoveWidget() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(5.0.h),
        child: Text(
          Constants.remove,
          style: FontStyle.productCategory,
        ),
      ),
    );
  }

  _buildWishListWidget() {
    return Wrap(children: [
      // index % 2 == 0
      //     ?
      Row(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 5.w),
            height: 18,
            width: 18,
            child: Container(),
          ),
          Text(
            "",
            style: FontStyle.productSubTitleStyle,
          ),
        ],
      )
    ]);
  }

  showQuantityDialog() async {
    return await showQuantityPickerDialog(
        context: context,
        minNumber: 1,
        maxNumber: 100,
        step: 1,
        selectedNumber: currentValue,
        onChanged: (value) => {_handleValueChangedExternally(value)});
  }

  _handleValueChangedExternally(num value) {
    if (value != null) {
      if (value is int) {
        currentValue = value;
        // updateQuantity(currentValue);
      }
    }
  }
}
