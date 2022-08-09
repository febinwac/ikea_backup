import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/common/preference_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../models/cart_model.dart';

class CartInfoScreen extends StatefulWidget {
  @override
  _CartInfoScreenState createState() => _CartInfoScreenState();
}

class _CartInfoScreenState extends State<CartInfoScreen> {
  List<CartInfoModel> items = [];
  String phone = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: _appBar(),
      body: items.isNotEmpty
          ? ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 35.h),
              itemBuilder: (BuildContext context, int index) {
                return infoItem(items[index], index, items.length);
              },
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 32.h,
                );
              },
            )
          : Container(),
      backgroundColor: HexColor(white),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.only(left: 5.0.w),
        child: IconButton(
            icon: Image.asset(
              Constants.close,
              height: 25,
              width: 25,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      title: Text(
        Constants.help,
        style: FontStyle.title,
        textAlign: TextAlign.center,
      ),
      shadowColor: HexColor('#DFDFDF'),
    );
  }

  headerWidget() {
    return Container(
        margin: EdgeInsets.only(top: 40.h, left: 20.w, bottom: 28.h),
        child: Row(
          children: [
            GestureDetector(
              child: SizedBox(
                height: 30.h,
                width: 25.w,
                child: Image.asset(Constants.backIcon),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text(
                Constants.help,
                style: FontStyle.title,
                textAlign: TextAlign.center,
              ),
            ))
          ],
        ));
  }

  Widget infoItem(CartInfoModel? item, index, int length) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.h,
            width: 25.w,
            child: Image.asset(item?.icon ?? ""),
          ),
          SizedBox(
            width: 13.0.w,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item?.title ?? "",
                style: FontStyle.categoryTile,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                index == index - 1
                    ? "${item?.content ?? ""} $phone"
                    : item?.content ?? "",
                style: TextStyle(
                    fontSize: 13,
                    height: 1.8,
                    fontWeight: FontWeight.normal,
                    color: HexColor('#424242')),
              ),
              index == length - 1
                  ? Row(
                      children: [
                        GestureDetector(
                          child: Text(
                            Constants.callUs,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                color: HexColor(boldBlack)),
                          ),
                          onTap: () async {
                            await launch('tel:$phone');
                          },
                        )
                      ],
                    )
                  : Container()
            ],
          ))
        ],
      ),
    );
  }

  void getData() async {
    await rootBundle.loadString(Constants.cartInfo).then((value) {
      setState(() {
        final parsed = jsonDecode(value).cast<Map<String, dynamic>>();

        items = parsed
            .map<CartInfoModel>((json) => CartInfoModel.fromJson(json))
            .toList();
      });
    });
    phone =await PreferenceUtils().getPhone();
  }
}
