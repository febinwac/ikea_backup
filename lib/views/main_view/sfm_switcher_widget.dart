import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../services/app_data.dart';
import '../../common/font_styles.dart';

class SfmSwitcherWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    String shopIkeaAr="تسوق من ايكيا";
    String shopIkeaSubAr="الأثاث واكسسوارات المنزل";
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GestureDetector(
                child: Container(
                  padding: AppData.hostAppLanguage == "en"
                      ? const EdgeInsets.all(8)
                      : const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: HexColor("#F2F2F2"),
                    borderRadius: const BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppData.hostAppLanguage == "en"
                            ? "Shop IKEA"
                            : shopIkeaAr,
                        style: FontStyle.style1,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                          AppData.hostAppLanguage == "en"
                              ? "Furniture, home accessories."
                              : shopIkeaSubAr,
                          style: FontStyle.style2,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                onTap: () {
                },
              )),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: HexColor("#FCDF5A"),
                borderRadius: const BorderRadius.all(Radius.circular(
                    5.0) //                 <--- border radius here
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Shop Food",
                      style: FontStyle.style1,
                      textAlign: TextAlign.center),
                  Text("Swedish food market",
                      style: FontStyle.style2,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
