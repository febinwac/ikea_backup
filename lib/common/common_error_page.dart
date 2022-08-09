import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import '../common/font_styles.dart';
import 'constants.dart';

class CommonErrorPage extends StatelessWidget {
  final String? errorTitle;
  final String? buttonText;
  final Function()? onButtonTap;
  final LoaderState? loaderState;

  const CommonErrorPage(
      {Key? key, this.errorTitle,this.loaderState, this.buttonText, this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.white,
        alignment: Alignment.center,
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 39, 0, 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          errorTitle ?? Constants.somethingWrong,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: HexColor(black)),
                        ),
                      ),
                      InkWell(
                        onTap: onButtonTap,
                        splashColor: HexColor(greyColor),
                        child: Container(
                          margin: EdgeInsets.only(top: 30.h, left: 28.w),
                          height: 50.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: HexColor(blueTitleColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Container(
                              color: HexColor(blueTitleColor),
                              child: Text(
                                Constants.retry,
                                style: FontStyle.noInternet,
                              ),
                            ),
                          ],)

                        ),
                      )
                    ])),
          );
        }));
  }
}
