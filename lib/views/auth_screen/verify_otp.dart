// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/common/helpers.dart';
import 'package:sfm_module/models/nationality_living_model.dart';
import 'package:sfm_module/providers/app_provider.dart';
import 'package:sfm_module/views/widgets/custom_check_box.dart';
import 'package:sfm_module/views/widgets/custom_drop_down.dart';
import 'package:sfm_module/views/widgets/custom_radio_button.dart';
import 'package:sfm_module/views/widgets/custom_text_field.dart';

import '../../common/colors.dart';
import '../widgets/custom_button_blue.dart';

class VerifyOTP extends StatefulWidget {
  final String? mobileNumber;
  final bool noUser;

  const VerifyOTP({Key? key, this.mobileNumber, this.noUser = false})
      : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController = TextEditingController();
  int currentSeconds = 0;
  final int timerMaxSeconds = 60;
  final interval = const Duration(seconds: 3);
  bool isButtonEnabled = false;
  String otp = '';
  bool enableResend = false;
  final _formKey = GlobalKey<FormState>();

  ///Join IKEA Family
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? _selectedDate;
  String? formattedToDate;

  ///Validation
  bool dobValidation = false;
  bool addressValidation = false;
  bool nationalityValidation = false;
  bool livingSituationValidation = false;
  bool maleValidation = false;
  bool feMaleValidation = false;
  bool smsValidation = false;
  bool emailValidation = false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      if (mounted) {
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
            enableResend = true;
          }
        });
      }
    });
  }

  final hintStyle = TextStyle(
      color: HexColor(lightGrey), fontSize: 16.0, fontWeight: FontWeight.w400);

  @override
  void initState() {
    startTimeout();
    Future.microtask(() => context.read<AppDataProvider>()
      ..isInvalid = false
      ..clearIkeaFamilySelected()
      ..clear());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.h),
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
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: Constants.verifyOtpText +
                              "\n+971 ${widget.mobileNumber}" +
                              '\t',
                          style: TextStyle(
                              color: HexColor(black),
                              fontSize: Platform.isIOS ? 15.0 : 14.0,
                              height: 1.5,
                              fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Change',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                  },
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 51.h),
                      otpField(),
                      SizedBox(height: 6.h),
                      timer(),
                      SizedBox(height: 8.h),
                      widget.noUser ? registerNow() : Container(),
                      joinIkeaFamilyFields(),
                      SizedBox(height: 25.h),
                      verifyBtn(),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
          icon: Image.asset(
            Constants.backIcon,
            height: 25,
            width: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  ///Ikea Family Fields
  Widget joinIkeaFamilyFields() {
    return Consumer<AppDataProvider>(builder: (context, model, _) {
      return model.otpData != null && !model.otpData!.isIkeaFamily!
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CheckBox(
                    status: model.isIkeaFamilySelected,
                    title: Constants.joinIkeaFamily,
                    isBoldText: true,
                    needLeftPadding: false,
                    onTap: () {
                      if (model.isIkeaFamilySelected) {
                        clearValidation();
                        context.read<AppDataProvider>().clear();
                      }
                      Future.microtask(() => context.read<AppDataProvider>()
                        ..getNationality(context)
                        ..getLivingSituation(context)
                        ..updateIkeaFamilySelected());
                    }),
                !model.joinIkeaFieldsLoading
                    ? model.isIkeaFamilySelected
                        ? enableIkeaFamilyFields(model, context)
                        : Container()
                    : CommonLoader()
              ],
            )
          : Container();
    });
  }

  Widget enableIkeaFamilyFields(AppDataProvider model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
      child: Column(
        children: [
          TextFormField(
            controller: _dobController,
            readOnly: true,
            onTap: () {
              _dateOfBirthSelector(context);
            },
            decoration: InputDecoration(
              hintText: Constants.dOB,
              hintStyle: hintStyle,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor(lightBlack))),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor(primaryColor), width: 2)),
            ),
            validator: (val) {
              setState(() {
                if (val == null || val.isEmpty) {
                  dobValidation = true;
                } else {
                  dobValidation = false;
                }
              });
              return null;
            },
          ),
          dobValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 25.h),
          nationalityDropDown(),
          nationalityValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 20.h),
          livingSituationDropDown(),
          livingSituationValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 20.h),
          TextFormField(
            style: FontStyle.logout,
            controller: addressController,
            decoration: InputDecoration(
              hintText: Constants.address,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor(lightBlack))),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor(primaryColor), width: 2)),
            ),
            onChanged: (val) {
              context.read<AppDataProvider>().getAddress(val.toString() ?? '');
              setState(() {
                if (val.isEmpty || model.address == null) {
                  addressValidation = true;
                } else {
                  addressValidation = false;
                }
              });
            },
            validator: (val) {
              setState(() {
                if (val == null || val.isEmpty || model.address == null) {
                  addressValidation = true;
                } else {
                  addressValidation = false;
                }
              });
              return null;
            },
          ),
          addressValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 26.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(Constants.gender,
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              CustomRadioButton(
                  isSelected: model.isMaleSelected,
                  title: Constants.male,
                  onTap: () {
                    context.read<AppDataProvider>().updateMaleSelected();
                    setState(() {
                      maleValidation = false;
                    });
                  },
                  validator: (val) {
                    setState(() {
                      if (val != true && !model.isMaleSelected) {
                        maleValidation = true;
                      } else {
                        maleValidation = false;
                      }
                    });
                    return null;
                  }),
              SizedBox(width: 18.w),
              CustomRadioButton(
                  isSelected: model.isFemaleSelected,
                  title: Constants.female,
                  onTap: () {
                    context.read<AppDataProvider>().updateFemaleSelected();
                    setState(() {
                      feMaleValidation = false;
                    });
                  },
                  validator: (val) {
                    setState(() {
                      if (val != true && !model.isFemaleSelected) {
                        feMaleValidation = true;
                      } else {
                        feMaleValidation = false;
                      }
                    });
                    return null;
                  }),
            ],
          ),
          maleValidation && feMaleValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 26.h),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(Constants.preferredCommunication,
                  style: TextStyle(fontSize: 18, color: Colors.black))),
          SizedBox(height: 18.h),
          _preferredCommunication(model, context),
          smsValidation && emailValidation
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
        ],
      ),
    );
  }

  void _dateOfBirthSelector(BuildContext context) async {
    final appModel = Provider.of<AppDataProvider>(context, listen: false);
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: HexColor(primaryColor),
                onPrimary: Colors.white,
                onSurface: HexColor(primaryColor),
              ),
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      formattedToDate = DateFormat('dd-MM-yyyy').format(newSelectedDate);
      _dobController
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dobController.text.length,
            affinity: TextAffinity.upstream));
      setState(() => dobValidation = false);
      appModel.getDateOfBirth(formattedToDate ?? '');
    }
  }

  Widget _preferredCommunication(AppDataProvider model, BuildContext context) {
    return Row(
      children: [
        CheckBox(
            status: model.smsPreferred,
            title: Constants.sms,
            isBoldText: false,
            needLeftPadding: true,
            onTap: () {
              context.read<AppDataProvider>().updateSmsPreferred();
              setState(() {
                smsValidation = false;
              });
            },
            validator: (val) {
              setState(() {
                if (val != true ||
                    model.preferredCommunicationChecked.isEmpty) {
                  smsValidation = true;
                } else {
                  smsValidation = false;
                }
              });
              return null;
            }),
        SizedBox(width: 8.w),
        CheckBox(
            status: model.emailPreferred,
            title: Constants.Email,
            isBoldText: false,
            needLeftPadding: true,
            onTap: () {
              context.read<AppDataProvider>().updateEmailPreferred();
              setState(() {
                emailValidation = false;
              });
            },
            validator: (val) {
              setState(() {
                if (val != true ||
                    model.preferredCommunicationChecked.isEmpty) {
                  emailValidation = true;
                } else {
                  emailValidation = false;
                }
              });
              return null;
            }),
      ],
    );
  }

  Widget nationalityDropDown() {
    return Consumer<AppDataProvider>(builder: (context, model, _) {
      if (model.nationalityListings == null ||
          model.nationalityListings!.isEmpty) {
        return Container();
      }
      List<NationalityListings> nationalityList = model.nationalityListings!;
      return CustomDropdown<NationalityListings>(
        value: model.selectedNationalityName != null
            ? model.selectedNationalityName?.label
            : Constants.nationality,
        style: model.selectedNationalityName != null
            ? FontStyle.selectQty
            : FontStyle.lightGrey16,
        validator: (val) {
          setState(() {
            if (val.isEmpty && model.selectedNationalityName == null) {
              nationalityValidation = true;
            } else {
              nationalityValidation = false;
            }
          });
        },
        onChange: (NationalityListings nationality) {
          context.read<AppDataProvider>().onNationalityChanged(nationality);
          setState(() {
            nationalityValidation = false;
          });
        },
        dropdownStyle: DropdownStyle(elevation: 5),
        dropdownButtonStyle: const DropdownButtonStyle(
            elevation: 0.5, padding: EdgeInsets.only(left: 0)),
        items: List.generate(
          nationalityList.length,
          (index) => DropdownItem(
            value: nationalityList[index],
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
              child: Text(
                nationalityList[index].label ?? '',
                style: FontStyle.selectQty,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget livingSituationDropDown() {
    return Consumer<AppDataProvider>(builder: (context, model, _) {
      if (model.livingSituations == null || model.livingSituations!.isEmpty) {
        return Container();
      }
      List<LivingSituations> livingSituationList = model.livingSituations ?? [];
      return CustomDropdown<LivingSituations>(
        value: model.selectedLivingSituationName != null
            ? model.selectedLivingSituationName?.label
            : Constants.livingSituation,
        style: model.selectedLivingSituationName != null
            ? FontStyle.selectQty
            : FontStyle.lightGrey16,
        validator: (val) {
          setState(() {
            if (val.isEmpty && model.selectedLivingSituationName == null) {
              livingSituationValidation = true;
            } else {
              livingSituationValidation = false;
            }
          });
        },
        onChange: (LivingSituations livingSituation) {
          context
              .read<AppDataProvider>()
              .onLivingSituationChanged(livingSituation);
          setState(() {
            livingSituationValidation = false;
          });
        },
        dropdownStyle: DropdownStyle(elevation: 5),
        dropdownButtonStyle: DropdownButtonStyle(
            elevation: 0.5,
            backgroundColor: HexColor('#FAFAFA'),
            primaryColor: HexColor('#C5C5C5'),
            padding: EdgeInsets.only(left: 0.w)),
        items: List.generate(
          livingSituationList.length ?? 0,
          (index) => DropdownItem(
            value: livingSituationList[index],
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0.h, top: 8.h),
              child: Text(
                livingSituationList[index].label ?? '',
                style: FontStyle.selectQty,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget verifyBtn() {
    return Consumer<AppDataProvider>(builder: (context, model, _) {
      return CustomButton(
        width: double.maxFinite,
        height: Platform.isIOS ? 50.h : 45.h,
        textSize: Platform.isIOS ? 15.0 : 14.0,
        raisedBtnColour: HexColor(primaryColor),
        buttonText: Constants.verifyOtpTitle,
        loader: model.loaderState == LoaderState.loading
            ? Lottie.asset(Constants.bouncingBallIcon,
                height: Platform.isIOS ? 50.h : 45.h,
                width: Platform.isIOS ? 50.w : 45.w,
                fit: BoxFit.fill)
            : null,
        onPressed: () {
          FocusScope.of(context).unfocus();
          formValidation(model);
        },
      );
    });
  }

  void formValidation(AppDataProvider model) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (model.isIkeaFamilySelected) {
        if (!dobValidation &&
            model.address != null &&
            model.address!.isNotEmpty &&
            !nationalityValidation &&
            !livingSituationValidation &&
            (model.isMaleSelected || model.isFemaleSelected) &&
            model.preferredCommunicationChecked.isNotEmpty) {
          Provider.of<AppDataProvider>(context, listen: false).verifyOtp(
              context: context,
              value: widget.mobileNumber ?? '',
              otp: otp,
              address: model.address ?? '',
              communicationPreferred: model.preferredCommunicationChecked,
              dateOfBirth: model.selectedDOB ?? '',
              gender: model.isMaleSelected ? 1 : 0,
              livingSituation: model.selectedLivingSituationName != null &&
                      model.selectedLivingSituationName?.value != null
                  ? (model.selectedLivingSituationName?.value ?? '')
                  : '',
              nationality: model.selectedNationalityName != null &&
                      model.selectedNationalityName?.value != null
                  ? (model.selectedNationalityName?.value ?? '')
                  : '',
              isIkeaFamily: model.isIkeaFamilySelected);
        }
      } else {
        Provider.of<AppDataProvider>(context, listen: false).verifyOtp(
            context: context,
            value: widget.mobileNumber ?? '',
            otp: otp,
            isIkeaFamily: false);
      }
    }
  }

  Widget otpField() {
    return CustomTextField(
      onTap: () {},
      maxLength: 4,
      controller: otpController,
      textFontSize: 16.0,
      fontWeight: FontWeight.w400,
      enableBorder: true,
      enableFocusBorder: true,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor(lightBlack))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor(primaryColor), width: 2)),
      validator: (val) {
        if (val == null || val.isEmpty) {
          context.read<AppDataProvider>().isInvalid = false;
          return Constants.otpRequired;
        }
        return null;
      },
      onChanged: (val) {
        if (val.length == 4) {
          FocusScope.of(context).unfocus();
          setState(() {
            otp = val.toString();
            isButtonEnabled = true;
          });
        } else {
          context.read<AppDataProvider>().isInvalid = false;
          setState(() {
            otp = '';
            isButtonEnabled = false;
          });
        }
      },
    );
  }

  Widget timer() {
    return Consumer<AppDataProvider>(builder: (context, data, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          data.isInvalid
              ? Text(Constants.sorryWrongOTP,
                  style: TextStyle(
                      color: HexColor(red),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400))
              : Container(),
          const Spacer(),
          enableResend
              ? GestureDetector(
                  child: Text(Constants.resendOTP,
                      style: TextStyle(
                          color: HexColor(primaryColor),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Provider.of<AppDataProvider>(context, listen: false)
                        .sendOtp(
                            context: context,
                            value: widget.mobileNumber,
                            isResend: true);
                  })
              : Container(),
          Text(timerText,
              style: TextStyle(
                  color: HexColor(boldBlack),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400)),
        ],
      );
    });
  }

  Widget registerNow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(Constants.noUserRegistered,
            style: TextStyle(
                color: HexColor(red),
                fontSize: 11.0,
                fontWeight: FontWeight.w400)),
        GestureDetector(
            onTap: () {
              Provider.of<AppDataProvider>(context, listen: false)
                  .sendRegistrationOtp(
                      context: context,
                      value: widget.mobileNumber,
                      isResend: false);
            },
            child: Text(Constants.registerNow,
                style: TextStyle(
                    color: HexColor(primaryColor),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400))),
      ],
    );
  }

  void clearValidation() {
    setState(() {
      dobValidation = false;
      addressValidation = false;
      nationalityValidation = false;
      livingSituationValidation = false;
      maleValidation = false;
      feMaleValidation = false;
      smsValidation = false;
      emailValidation = false;
      formattedToDate = '';
      _dobController.clear();
      addressController.clear();
    });
  }
}
