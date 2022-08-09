import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constants.dart';
import '../../common/font_styles.dart';

class MainHeaderWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
     color: Colors.white,
     height: 60.h,
     alignment: Alignment.center,
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Container(
           height: 30.h,
           width: 74.w,
           margin: EdgeInsets.symmetric(horizontal: 19.0.w),
           child: Image.asset(Constants.homeHeaderLogo),
         ),
         Container(
           margin: EdgeInsets.symmetric(horizontal: 19.0.w),
           child: InkWell(
             onTap: () {},
             splashColor: Colors.grey,
             child: SizedBox(
               height: 40.h,
               child: Center(
                 child: Row(
                   children: [
                     Image.asset(
                       Constants.markerHeaderIcon,
                       height: 30.h,
                       width: 30.w,
                     ),
                     Text(
                       "Dubai",
                       maxLines: 1,
                       textAlign: TextAlign.right,
                       overflow: TextOverflow.ellipsis,
                       style: FontStyle.recentItemStyle,
                     )
                   ],
                 ),
               ),
             ),
           ),
         ),
       ],
     ),
   );
  }

}