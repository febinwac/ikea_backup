// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:sfm_module/common/helpers.dart';
// import 'package:sfm_module/providers/app_provider.dart';
//
// import '../../common/colors.dart';
// import '../../common/constants.dart';
// import '../../common/font_styles.dart';
// import '../../common/preference_utils.dart';
// import '../../models/delete_account.dart';
// import '../widgets/custom_button_blue.dart';
//
// class DeleteAccountConfirmScreen extends StatefulWidget {
//   @override
//   _DeleteAccountConfirmScreenState createState() =>
//       _DeleteAccountConfirmScreenState();
// }
//
// class _DeleteAccountConfirmScreenState
//     extends State<DeleteAccountConfirmScreen> {
//   DeleteAccount? deleteAccount;
//   String? phone;
//
//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       bottomNavigationBar: _buildProceedBtn(),
//       appBar: _appBar(),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 30.0.h),
//         children: [
//           SizedBox(
//             height: 48.h,
//           ),
//           Text(
//             deleteAccount?.title??"",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: Platform.isIOS ? 25 : 23,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           SizedBox(
//             height: 24.h,
//           ),
//           Text(
//             deleteAccount?.subTitle??"",
//             style: TextStyle(
//                 color: HexColor("#404040"),
//                 fontSize: Platform.isIOS ? 15.0 : 14.0,
//                 height: 1.5,
//                 fontWeight: FontWeight.w400),
//           ),
//           SizedBox(
//             height: 19.h,
//           ),
//           (deleteAccount?.contentList??[]).isNotEmpty
//               ? ListView.separated(
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext context, int index) {
//                     ContentList? item=deleteAccount?.contentList?[index];
//                     if (item==null) {
//                       return const SizedBox();
//                     }
//
//                     return infoItem(item, index,
//                         (deleteAccount?.contentList??[]).length);
//                   },
//                   itemCount: (deleteAccount?.contentList??[]).length,
//                   separatorBuilder: (BuildContext context, int index) {
//                     return SizedBox(
//                       height: 32.h,
//                     );
//                   },
//                 )
//               : Container(),
//         ],
//       ),
//       backgroundColor: HexColor(white),
//     ));
//   }
//
//   AppBar _appBar() {
//     return AppBar(
//       centerTitle: true,
//       elevation: 1,
//       backgroundColor: Colors.white,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 5.0),
//         child: IconButton(
//             icon: Image.asset(
//               Constants.backIcon,
//               height: 25,
//               width: 25,
//             ),
//             onPressed: () => Navigator.pop(context)),
//       ),
//       title: Text(
//         Constants.deleteMyAccount,
//         style: FontStyle.title,
//         textAlign: TextAlign.center,
//       ),
//       shadowColor: HexColor('#DFDFDF'),
//     );
//   }
//
//   headerWidget() {
//     return Container(
//         margin: EdgeInsets.only(top: 40.h, left: 20.w, bottom: 28.h),
//         child: Row(
//           children: [
//             GestureDetector(
//               child: Container(
//                 height: 30,
//                 width: 25,
//                 child: Image.asset(Constants.backIcon),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             Expanded(
//                 child: Container(
//               alignment: Alignment.center,
//               child: Text(
//                 Constants.help,
//                 style: FontStyle.title,
//                 textAlign: TextAlign.center,
//               ),
//             ))
//           ],
//         ));
//   }
//
//   Widget infoItem(ContentList item, index, int length) {
//     return Container(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             height: 5,
//             width: 5,
//             child: Image.asset(Constants.bulletPoint),
//           ),
//           SizedBox(
//             width: 13.0.w,
//           ),
//           Expanded(
//               child: Text(
//             item.content??"",
//             style: TextStyle(
//                 color: HexColor("#404040"),
//                 fontSize: Platform.isIOS ? 15.0 : 14.0,
//                 fontWeight: FontWeight.w400),
//           ))
//         ],
//       ),
//     );
//   }
//
//   void getData() async {
//     await rootBundle
//         .loadString(Constants.deleteAccountPoints)
//         .then((value) {
//       setState(() async{
//         var data = json.decode(value);
//         deleteAccount = DeleteAccount.fromJson(data["data"]);
//         phone =await PreferenceUtils().getPhone();
//       });
//     });
//   }
//
//   _buildProceedBtn() {
//     return Consumer<AppDataProvider>(builder: (context, model, _) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
//         child: CustomButton(
//           loader: model.loaderState==LoaderState.loading
//               ? Lottie.asset(Constants.bouncingBallIcon,
//                   height: Platform.isIOS ? 50 : 45,
//                   width: Platform.isIOS ? 50 : 45,
//                   fit: BoxFit.fill)
//               : null,
//           buttonText: Constants.confirmAndProceed,
//           onPressed: () {
//             model.getDeleteAccountOtp(
//                 phone: phone,
//                 isResend: false,
//                 onSuccess: () {
//
//                 },
//                 onFailure: (String message) {
//                   Helpers.showFlushBar(
//                       message, context, Icons.sms_failed_outlined);
//                 });
//           },
//           width: double.maxFinite,
//           raisedBtnColour: HexColor(primaryColor),
//           height: 55.0,
//         ),
//       );
//     });
//   }
// }
