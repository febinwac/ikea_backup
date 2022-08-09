import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colors.dart';
import 'constants.dart';

class CommonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Lottie.asset(Constants.pullRingEnter, height: 60, width: 60),
      ),
    );
  }
}
class CircularLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        child: Lottie.asset(Constants.pullRingEnter, height: 60, width: 60),
      ),
    );
  }
}

class CommonLinearLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [Lottie.asset('assets/animations/bottom_bar_strip_loader.json',
      animate: true,
      width: double.maxFinite,
      repeat: true),],
    );
  }
}

class CommonContainerShimmer extends StatelessWidget {
  final double radius;

  const CommonContainerShimmer({Key? key, this.radius = 5.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: HexColor(
              nearlyGrey
          )
      ),
    );
  }
}

class CommonCircularShimmer extends StatelessWidget {
final double val;
final double height;

  const CommonCircularShimmer({Key? key, this.val = 1, this.height = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width* val,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: HexColor(
              nearlyGrey
          )
      ),
    );
  }
}


