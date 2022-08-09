import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class VariantTile extends StatelessWidget {
  int? index;
  String? label;
  bool isSelected;
  EdgeInsetsGeometry? edgeInsetsGeometry;
  VoidCallback? onTap;
  VariantTile({this.index, this.label, this.edgeInsetsGeometry, this.isSelected=false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        margin: edgeInsetsGeometry,
        decoration: BoxDecoration(
            color: isSelected ? HexColor(darkYellow) : HexColor("#F2F2F2"),
            borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
            border: Border.all(
                color: isSelected? HexColor(blueTitleColor):
                    HexColor("#F2F2F2"))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              child: Text(
                label ?? "",
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isSelected
                        ? HexColor(blueTitleColor):
                        HexColor(black)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
