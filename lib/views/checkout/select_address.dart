import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/providers/address_provider.dart';
import 'package:sfm_module/views/widgets/divider_view.dart';

import '../../common/colors.dart';
import '../../common/common_error_page.dart';
import '../../common/common_loader.dart';
import '../../common/constants.dart';
import '../../providers/cart_provider.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  AddressProvider? addressProvider;

  @override
  void initState() {
    addressProvider = context.read<AddressProvider>();
    Future.microtask(() => addressProvider?..getAddressList(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AddressProvider>(builder: (context, model, _) {
        if (model.loaderState == LoaderState.loading) {
          return CommonLinearLoader();
        }
        if (model.loaderState == LoaderState.networkErr ||
            model.loaderState == LoaderState.error) {
          return CommonErrorPage(
            loaderState: model.loaderState,
            onButtonTap: () => {},
          );
        }
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20.0.w,right: 20.0.w),
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: HexColor(lightGrey))),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15.0.w,top: 20.0.h,right: 15.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25.0.h,
                        width: 45.0.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: HexColor(blueTitleColor))
                        ),
                        child: Text(Constants.home,style: FontStyle.black11Normal,),
                      ),
                      SizedBox(height: 15.0.h,),
                      Text('Sreejith M G',style: FontStyle.black15Bold,),
                      SizedBox(height: 15.0.h,),
                      Text('1, dubai, Dubai, Dubai',style: FontStyle.black13Normal,),
                      SizedBox(height: 15.0.h,),
                      Text('717171717',style: FontStyle.black13Normal,),
                      SizedBox(height: 15.0.h,),
                      DividerView(edgeInsetsGeometry: EdgeInsets.only(left: 0.w,right: 0.w),),
                      SizedBox(height: 15.0.h,),

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0.w,right: 10.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          Image.asset('assets/icons/delete_icon.png',height: 20.0.h,width: 20.0.w,),
                          SizedBox(width: 5.0.w,),
                          Text(Constants.remove,style: FontStyle.black13Normal,),
                        ],
                      ),
                      Wrap(
                        children: [
                          Image.asset('assets/icons/edit_icon.png',height: 20.0.h,width: 20.0.w,),
                          SizedBox(width: 5.0.w,),
                          Text(Constants.edit,style: FontStyle.black13Normal,),
                        ],
                      )


                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
      appBar: _appBar(),

    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.only(left: 5.0.w),
        child: IconButton(
            icon: Image.asset(
              Constants.backIcon,
              height: 25,
              width: 25,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      title: Text(
        Constants.saveAddress,
        style: FontStyle.title,
        textAlign: TextAlign.center,
      ),
      shadowColor: HexColor('#DFDFDF'),
    );
  }
}
