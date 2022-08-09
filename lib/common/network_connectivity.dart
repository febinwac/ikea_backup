import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/constants.dart';

import '../providers/connectivity_provider.dart';
import '../common/font_styles.dart';
import 'colors.dart';
import 'common_loader.dart';

class NetworkConnectivity extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Function? onTap;
  final Color color;

  NetworkConnectivity(
      {required this.child,
      this.inAsyncCall = false,
      this.opacity = 0.3,
      this.onTap,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, snapshot, _) {
      List<Widget> widgetList = [];
      widgetList.add(child);
      if (!snapshot.isConnected || snapshot.enableRefresh) {
        widgetList.add(Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.white,
            alignment: Alignment.center,
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
                          "No internet connection.\nPlease try again",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: HexColor(black)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.h, left: 28.w),
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: HexColor(blueTitleColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: ElevatedButton.icon(
                          label: Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              color: HexColor(blueTitleColor),
                              child: Text(
                                Constants.retry,
                                style: FontStyle.noInternet,
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.wifi_off_rounded,
                            size: 18.w,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            snapshot.updateEnableRefresh();
                            if (onTap != null) {
                              onTap!();
                            }
                          },
                        ),
                      )
                    ]))));
      }
      if (inAsyncCall) {
        final modal = Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: ModalBarrier(dismissible: false, color: color),
            ),
            CommonLinearLoader(),
          ],
        );
        widgetList.add(modal);
      }
      return Stack(
        children: widgetList,
      );
    });
  }
}
