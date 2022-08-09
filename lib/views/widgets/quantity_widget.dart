import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/views/widgets/quantity_picker_dialog.dart';
import '../../common/colors.dart';
import '../../common/constants.dart';

class QuantityWidget extends StatelessWidget {
  int quantity;
  Function onQuantitySelection;
  BuildContext context;

  QuantityWidget(
      {required this.quantity,
      required this.onQuantitySelection,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchOutCurve: Curves.easeIn,
        child: GestureDetector(
          child: Container(
            height: Platform.isIOS ? 45.h : 40.h,
            width: 73.w,
            margin: EdgeInsets.only(right: 17.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: HexColor(viewGrey), width: 1.0.w),
              borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ("$quantity"),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: HexColor(black)),
                  ),
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: Image.asset(Constants.down_arrow),
                  )
                ],
              ),
            ),
          ),
          onTap: () => showQuantityDialog(),
        ));
  }

  showQuantityDialog() async {
    return await showQuantityPickerDialog(
        context: context,
        minNumber: 1,
        maxNumber: 100,
        step: 1,
        selectedNumber: quantity,
        onChanged: (value) => {_handleValueChangedExternally(value)});
  }

  _handleValueChangedExternally(num value) async {
    if (value != null) {
      if (value is int) {
        print("Selected Quantity is $value");
      }
    }
  }
}
