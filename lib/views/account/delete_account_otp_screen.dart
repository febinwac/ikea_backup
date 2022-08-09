// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ikea/provider/login_provider/sent_otp_provider.dart';
// import 'package:ikea/provider/login_provider/verifyOtp_provider.dart';
// import 'package:ikea/provider/revoke_customer_provider.dart';
// import 'package:ikea/provider/signup_provider/registration_provider.dart';
// import 'package:ikea/utilities/colors.dart' as colors;
// import 'package:ikea/utilities/font_styles.dart';
// import 'package:ikea/utilities/string_constants.dart';
// import 'package:ikea/utils/colors.dart';
// import 'package:ikea/utils/common/custom_text_field.dart';
// import 'package:ikea/utils/common/raised_button.dart';
// import 'package:ikea/utils/constants.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../../utilities/common_methods.dart';
// import '../../main_page.dart';
//
// class DeleteAccountOtpScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   DeleteAccountOtpScreen({@required this.mobileNumber});
//
//   @override
//   _DeleteAccountOtpScreenState createState() => _DeleteAccountOtpScreenState();
// }
//
// class _DeleteAccountOtpScreenState extends State<DeleteAccountOtpScreen> {
//   TextEditingController otpController = TextEditingController();
//   int currentSeconds = 0;
//   final int timerMaxSeconds = 60;
//   final interval = const Duration(seconds: 3);
//   bool isButtonEnabled = false;
//   String otp = '';
//   bool enableResend = false;
//   final _formKey = GlobalKey<FormState>();
//
//   String get timerText =>
//       '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
//       '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
//
//   startTimeout([int milliseconds]) {
//     var duration = interval;
//     Timer.periodic(duration, (timer) {
//       if (mounted) {
//         setState(() {
//           // print(timer.tick);
//           currentSeconds = timer.tick;
//           if (timer.tick >= timerMaxSeconds) {
//             timer.cancel();
//             enableResend = true;
//           }
//         });
//       }
//     });
//   }
//
//   final hintStyle = const TextStyle(
//       color: lightGrey, fontSize: 16.0, fontWeight: FontWeight.w400);
//
//   @override
//   void initState() {
//     startTimeout();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget otpField() {
//       return CustomTextField(
//         maxLength: 4,
//         controller: otpController,
//         textFontSize: 16.0,
//         fontWeight: FontWeight.w400,
//         enableBorder: true,
//         enableFocusBorder: true,
//         enabledBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: lightBlack)),
//         focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: buttonColour, width: 2)),
//         validator: (val) {
//           if (val == null || val.isEmpty) {
//             return 'Otp is required';
//           }
//           return null;
//         },
//         onChanged: (val) {
//           if (val.length == 4) {
//             FocusScope.of(context).unfocus();
//             setState(() {
//               otp = val.toString();
//               isButtonEnabled = true;
//             });
//           } else {
//             setState(() {
//               otp = '';
//               isButtonEnabled = false;
//             });
//           }
//         },
//       );
//     }
//
//     final timer =
//         Consumer<RevokeCustomerProvider>(builder: (context, model, _) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Spacer(),
//           GestureDetector(
//               child: Row(children: [
//                 enableResend
//                     ? GestureDetector(
//                     child: Text("Resend OTP - ",
//                         style: TextStyle(
//                             color: buttonColour,
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.w400)),
//                     onTap: () {
//                       Provider.of<LoginProvider>(context, listen: false).sendOtp(
//                           context: context,
//                           value: widget.mobileNumber,
//                           isResend: true);
//                     })
//                     : Container(),
//                 Text(timerText,
//                     style: TextStyle(
//                         color: boldBlack,
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.w400)),
//               ],),
//               onTap: () {
//                 if (!model.isFetching) {
//                   FocusScope.of(context).unfocus();
//                   if (_formKey.currentState.validate()) {
//                     _formKey.currentState.save();
//                     model.verifyDeleteAccountOtp(
//                         phone: widget.mobileNumber,
//                         otp: otp,
//                         onSuccess: () async{
//                           await model.revokeCustomerToken(context: context);
//                         },
//                         onFailure: (String message) {
//                           CommonMethods().showFlushBar(
//                               message, context, Icons.sms_failed_outlined);
//                         });
//                   }
//                 } else {
//                   CommonMethods().showFlushBar(
//                       StringConstants.wait, context, Icons.sms_failed_outlined);
//                 }
//               })
//         ],
//       );
//     });
//
//     AppBar _appBar() {
//       return AppBar(
//           centerTitle: true,
//           elevation: 1,
//           title: Text(
//             StringConstants.verification,
//             style: FontStyle.title,
//             textAlign: TextAlign.center,
//           ),
//           leading: IconButton(
//               icon: Image.asset(
//                 StringConstants.backIcon,
//                 height: 25,
//                 width: 25,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//           shadowColor: colors.HexColor('#DFDFDF'),
//           backgroundColor: Colors.white,
//           brightness: Brightness.light);
//     }
//
//     return Scaffold(
//       appBar: _appBar(),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 48),
//                       Text(
//                         StringConstants.enterOtp,
//                         style: TextStyle(
//                             color: boldBlack,
//                             fontSize: Platform.isIOS ? 22.0 : 20.0,
//                             fontWeight: FontWeight.w700),
//                       ),
//                       SizedBox(height: 24),
//                       RichText(
//                         textAlign: TextAlign.start,
//                         text: TextSpan(
//                           text: Constants.verifyOtpText +
//                               "\n+971 ${widget.mobileNumber}" +
//                               '\t',
//                           style: TextStyle(
//                               color: black,
//                               fontSize: Platform.isIOS ? 15.0 : 14.0,
//                               height: 1.5,
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                       SizedBox(height: 51),
//                       otpField(),
//                       SizedBox(height: 6),
//                       timer,
//                       SizedBox(height: 33),
//                       verifyBtn(),
//                       SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget verifyBtn() {
//     return Consumer<RevokeCustomerProvider>(builder: (context, model, _) {
//       return CustomButton(
//         width: double.maxFinite,
//         height: Platform.isIOS ? 50 : 45,
//         textSize: Platform.isIOS ? 15.0 : 14.0,
//         raisedBtnColour: buttonColour,
//         buttonText: StringConstants.deleteMyAccount,
//         loader: model.isFetching
//             ? Lottie.asset(StringConstants.bouncingBallIcon,
//                 height: Platform.isIOS ? 50 : 45,
//                 width: Platform.isIOS ? 50 : 45,
//                 fit: BoxFit.fill)
//             : null,
//         onPressed: () {
//           FocusScope.of(context).unfocus();
//           if (_formKey.currentState.validate()) {
//             _formKey.currentState.save();
//             model.verifyDeleteAccountOtp(
//                 phone: widget.mobileNumber,
//                 otp: otp,
//                 onSuccess: () async{
//                   await model.revokeCustomerToken(context: context);
//                 },
//                 onFailure: (String message) {
//                   CommonMethods().showFlushBar(
//                       message, context, Icons.sms_failed_outlined);
//                 });
//           }
//         },
//       );
//     });
//   }
// }
