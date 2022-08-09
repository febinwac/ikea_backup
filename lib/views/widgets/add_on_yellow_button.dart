import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/font_styles.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';

class AddOnYellowButton extends StatelessWidget {
  Function()? addOnClick;
  bool changeStyle;

  AddOnYellowButton({required this.addOnClick, required this.changeStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addOnClick,
      child: Container(
        margin:
            changeStyle ? EdgeInsets.only(right: 5.w) : EdgeInsets.only(left: 5.w),
        decoration: BoxDecoration(
          color: HexColor(darkYellow),
          borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
        ),
        padding: changeStyle
            ? EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h)
            : EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Constants.addOn,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyle.addOnTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
