import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/colors.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/common/nav_route.dart';
import 'package:sfm_module/providers/app_provider.dart';
import 'package:sfm_module/services/app_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants.dart';
import '../widgets/account_expansion_tile.dart';
import '../widgets/custom_button_blue.dart';
import '../widgets/divider_view.dart';
import '../widgets/empty_app_bar.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Access Token ${AppData.accessToken}");
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            appBar: EmptyAppBar(),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(20.h),
              child: AppData.accessToken.isEmpty
                  ? guestWidget()
                  : loggedInWidget(),
            ),
          );
        });
  }

  loggedInWidget() {
    final height = MediaQuery.of(context).size.height;
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 18.0.w, vertical: height * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  child: Text("Hi, ${AppData.name ?? ""}",
                      style: FontStyle.userrText)),
              InkWell(
                onTap: () => showLogoutDialog(context),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(Constants.logout, style: FontStyle.accountTile),
                ),
              )
            ],
          ),
        ),
        _buildUserRegion(),
        const DividerView(
          edgeInsetsGeometry: EdgeInsets.all(0),
        ),
        AccountExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 28.0),
          title: Text(Constants.myAccount, style: FontStyle.accountTile),
          children: <Widget>[_buildAccountChildren()],
        ),
        CustomListTile(
          onTap: () {
            launchUrl(Uri.parse('${AppData.restApiUrl}privacy-policy.html'));
          },
          title: Constants.policies,
        ),
        CustomListTile(
          onTap: () {
            launchUrl(
                Uri.parse('${AppData.restApiUrl}terms-and-conditions.html'));
          },
          title: Constants.termsAndCondition,
        )
      ],
    );
  }

  guestWidget() {
    return ListView(
      children: [
        Text(
          Constants.profileWelcome,
          style: TextStyle(
            color: HexColor(black),
            fontSize: Platform.isIOS ? 25 : 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        ikeaProfileContent(),
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomButton(
              raisedBtnColour: HexColor("#0058A3"),
              width: 160.w,
              height: Platform.isIOS ? 50.h : 45.h,
              buttonText: Constants.signInTitle,
              onPressed: () {
                NavRoutes.navToLoginPage(context);
              },
            ),
          ],
        ),
        SizedBox(height: 18.h),
        CustomListTile(
          onTap: () {
            launchUrl(Uri.parse('${AppData.restApiUrl}privacy-policy.html'));
          },
          title: Constants.policies,
        ),
        CustomListTile(
          onTap: () {
            launchUrl(
                Uri.parse('${AppData.restApiUrl}terms-and-conditions.html'));
          },
          title: Constants.termsAndCondition,
        )
      ],
    );
  }

  Widget ikeaProfileContent() {
    return AppData.countryCode != null && AppData.countryCode == "AE"
        ? RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                text: Constants.profileContent,
                style: TextStyle(
                  color: HexColor(black),
                  fontSize: Platform.isIOS ? 14 : 13,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: Constants.ikeaFamilyAccountScreen,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(
                            'https://family.ikea.ae/join-us/profile'));
                      },
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: HexColor(black),
                      height: 1.5,
                      fontSize: Platform.isIOS ? 14 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: " card.",
                    style: TextStyle(
                      color: HexColor(black),
                      height: 1.5,
                      fontSize: Platform.isIOS ? 14 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          )
        : Container();
  }

  Widget _buildUserRegion() {
    return CustomListTile(
      icon: Image.asset(
        'assets/icons/marker.png',
        height: 35,
        width: 25,
      ),
      title: "Ras al khaima",
    );
    // return selectedRegion != null
    //     ? CustomListTile(
    //         icon: Image.asset(
    //           'assets/icons/marker.png',
    //           height: 35,
    //           width: 25,
    //         ),
    //         title: selectedRegion != null ? selectedRegion : "",
    //       )
    //     : Container();
  }

  Widget _buildAccountChildren() {
    return Column(
      children: [
        const DividerView(),
        Consumer<AppDataProvider>(
          builder: (context, data, child) {
            return Container(
              height: 80,
              child: Center(
                child: ListTile(
                  onTap: () {},
                  leading: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(Constants.editAccount,
                          style: FontStyle.accountTile)),
                ),
              ),
            );
          },
        ),
        DividerView(),
        Container(
          height: 80,
          child: Center(
            child: ListTile(
              onTap: () {},
              leading: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(Constants.myOrder, style: FontStyle.accountTile)),
            ),
          ),
        ),
        DividerView(),
        Container(
          height: 80,
          child: Center(
            child: ListTile(
              onTap: () {},
              leading: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(Constants.savedAddress,
                      style: FontStyle.accountTile)),
            ),
          ),
        ),
        DividerView(),
        Container(
          height: 80,
          child: Center(
            child: ListTile(
              onTap: () {},
              leading: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(Constants.savedAddress,
                      style: FontStyle.accountTile)),
            ),
          ),
        )
      ],
    );
  }

  showLogoutDialog(BuildContext c) {
    showDialog(
        context: c,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r)),
            child: SizedBox(
              height: 160.h,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0.w, bottom: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 17.h),
                    Text(Constants.logOut, style: FontStyle.logout),
                    SizedBox(height: 19.h),
                    Text(Constants.doYouWantToLogout,
                        style: FontStyle.productSubTitleStyle),
                    SizedBox(height: 18.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(
                            Constants.cancel,
                            style: FontStyle.recentItemStyle,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                            context
                                .read<AppDataProvider>()
                                .revokeCustomerToken(context: context)
                                .then((value) async {
                              if (value) {
                                await context
                                    .read<AppDataProvider>()
                                    .logOut(context);
                                Future.microtask(() => context
                                    .read<AppDataProvider>()
                                    .createEmptyCart(context));
                                Future.microtask(() => context
                                    .read<AppDataProvider>()
                                    .getCountryInfo(context));
                              }
                            });
                          },
                          child: Text(Constants.logOut,
                              style: FontStyle.placesItemSub),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CustomListTile extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final Widget? icon;

  const CustomListTile({Key? key, this.onTap, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DividerView(
          edgeInsetsGeometry: EdgeInsets.all(0),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: icon != null
                ? EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 28.0.h)
                : EdgeInsets.symmetric(horizontal: 28.0.w, vertical: 28.0.h),
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    padding: EdgeInsets.only(right: 19.0.w),
                    child: Image.asset(
                      Constants.markerHeaderIcon,
                      height: 30.h,
                      width: 30.w,
                    ),
                  ),
                if (icon == null)
                  SizedBox(
                    height: 35.h,
                  ),
                Expanded(
                  child: Text(
                    title ?? '',
                    style: FontStyle.accountTile,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onTap != null
                    ? SizedBox(
                        height: 30.h,
                        width: 25.w,
                        child: Image.asset('assets/icons/right_arrow.png'),
                      )
                    : SizedBox(
                        height: 30.h,
                        width: 25.w,
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
