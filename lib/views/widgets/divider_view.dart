import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/colors.dart';

class DividerView extends StatelessWidget {
  final EdgeInsetsGeometry? edgeInsetsGeometry;
// double right;
// double left;
   const DividerView({Key? key, this.edgeInsetsGeometry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.0,
      child: Container(
        margin:
            edgeInsetsGeometry ?? EdgeInsets.only(right: 8.0.w, left: 8.0.w),
        color: HexColor(dividerColor),
      ),
    );
  }
}
