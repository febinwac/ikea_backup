import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../providers/app_provider.dart';
import '../widgets/custom_button_blue.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isButtonEnabled = false;
  bool enablePrefix = false;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2E7D32),
    ));
    final phoneNoField = CustomTextField(
      maxLength: 9,
      textFontSize: Platform.isIOS ? 17.0 : 16.0,
      fontWeight: FontWeight.w400,
      prefix: enablePrefix
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+971',
                    style: TextStyle(
                        color: HexColor(boldBlack),
                        fontSize: Platform.isIOS ? 17.0 : 16.0,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal)),
              ],
            )
          : null,
      fontStyle: FontStyle.normal,
      underlineInputBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: enablePrefix ? HexColor("#0058A3") : HexColor('#929292'),
            width: enablePrefix ? 2 : 1),
      ),
      hintText: Constants.verifyMobileNo,
      onTap: () {
        setState(() {
          enablePrefix = true;
        });
      },
      onChanged: (val) {
        if (val.length == 9) {
          setState(() {
            phoneNumber = val;
            isButtonEnabled = true;
          });
        } else {
          setState(() {
            isButtonEnabled = false;
          });
        }
      },
    );

    Widget loginScreenBtn() {
      return Consumer<AppDataProvider>(builder: (context, data, _) {
        if ((data.message ?? "").isNotEmpty) {}
        return CustomButton(
          width: double.maxFinite,
          height: Platform.isIOS ? 50 : 45,
          textSize: Platform.isIOS ? 15.0 : 14.0,
          elevation: 0,
          loader: data.loaderState == LoaderState.loading
              ? Lottie.asset(Constants.bouncingBallIcon,
                  height: Platform.isIOS ? 50 : 45,
                  width: Platform.isIOS ? 50 : 45,
                  fit: BoxFit.fill)
              : null,
          raisedBtnColour:
              isButtonEnabled ? HexColor("#0058A3") : HexColor("#DEDEDE"),
          buttonText: Constants.submit,
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (isButtonEnabled) {
              data.sendOtp(
                  context: context, value: phoneNumber, isResend: false);
            }
          },
        );
      });
    }

    AppBar _appBar() {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            icon: Image.asset(
              Constants.backIcon,
              height: 25.h,
              width: 25.w,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      );
    }

    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 48.h),
                        Text(
                          Constants.loginText,
                          style: TextStyle(
                              color: HexColor(boldBlack),
                              fontSize: Platform.isIOS ? 22.0 : 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          Constants.enterRegisteredMobileNumber,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HexColor(black),
                              fontSize: Platform.isIOS ? 15.0 : 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 51.h),
                        phoneNoField,
                        SizedBox(height: 29.h),
                        loginScreenBtn(),
                        SizedBox(height: 28.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
