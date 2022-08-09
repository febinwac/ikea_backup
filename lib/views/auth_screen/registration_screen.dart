import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/colors.dart';
import 'package:sfm_module/common/common_loader.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/common/font_styles.dart';
import 'package:sfm_module/common/helpers.dart';
import 'package:sfm_module/models/nationality_living_model.dart';
import 'package:sfm_module/providers/app_provider.dart';
import 'package:sfm_module/views/widgets/custom_button_blue.dart';
import 'package:sfm_module/views/widgets/custom_check_box.dart';
import 'package:sfm_module/views/widgets/custom_drop_down.dart';
import 'package:sfm_module/views/widgets/custom_radio_button.dart';

class RegistrationScreen extends StatefulWidget {
  final String? mobileNumber;

  const RegistrationScreen({Key? key, this.mobileNumber}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int currentSeconds = 0;
  final int timerMaxSeconds = 60;
  final interval = const Duration(seconds: 3);
  final controller = TextEditingController();
  bool isValidForm = false;
  bool autoValidate = false;
  FocusNode focusOtp = FocusNode();
  FocusNode focusFirstName = FocusNode();
  FocusNode focusLastName = FocusNode();
  FocusNode focusEmail = FocusNode();

  String? mobileNumber;
  String? otp;
  String? firstName;
  String? lastName;
  String email = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Join IKEA Family
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? _selectedDate;
  String? formattedToDate;

  ///Validation
  bool DOB = false;
  bool address = false;
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
          if (timer.tick >= timerMaxSeconds) timer.cancel();
        });
      }
    });
  }

  final enableBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: HexColor(lightBlack)));

  final focusBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: HexColor(primaryColor), width: 2));

  @override
  void initState() {
    controller.text = "+971${widget.mobileNumber}";
    startTimeout();
    context.read<AppDataProvider>()
      ..clearIkeaFamilySelected()
      ..clear();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusOtp.dispose();
    focusFirstName.dispose();
    focusLastName.dispose();
    focusEmail.dispose();
    super.dispose();
  }

  void formValidation(AppDataProvider model) {
    if (_formKey.currentState!.validate()) {
      if (model.isIkeaFamilySelected) {
        if (!DOB &&
            model.address != null &&
            model.address!.isNotEmpty &&
            !nationalityValidation &&
            !livingSituationValidation &&
            (model.isMaleSelected || model.isFemaleSelected) &&
            model.preferredCommunicationChecked.isNotEmpty) {
          Provider.of<AppDataProvider>(context, listen: false)
              .registrationUsingOtp(
                  context: context,
                  value: widget.mobileNumber,
                  otp: otp,
                  firstName: firstName,
                  lastName: lastName,
                  emailId: email.isEmpty ? "" : email);
        }
      } else {
        Provider.of<AppDataProvider>(context, listen: false)
            .registrationUsingOtp(
                context: context,
                value: widget.mobileNumber,
                otp: otp,
                firstName: firstName,
                lastName: lastName,
                emailId: email.isEmpty ? "" : email);
      }
    } else {
      setState(() {
        isValidForm = false;
        autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(white),
        appBar: _appBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 48.h),
                        Text(
                          Constants.signUpTitle,
                          style: TextStyle(
                            color: HexColor(boldBlack),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text("OTP sent to Mobile Number",
                                  style: TextStyle(
                                    color: HexColor(boldBlack),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            Text(timerText,
                                style: TextStyle(
                                    color: HexColor(boldBlack),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                        SizedBox(height: 25.h),
                        userForm(),
                        SizedBox(height: 20.h),
                        joinIkeaFamilyFields(),
                        SizedBox(height: 29.h),
                        otpButton(),
                        SizedBox(height: 29.h)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget userForm() {
    return Column(
      children: <Widget>[
        _textField(
            textInputType: TextInputType.number,
            controller: controller,
            validator: (val) {
              if (val.isEmpty) {
                return Constants.enterValidNo;
              }
              return null;
            },
            onTap: () {},
            hintText: Constants.mobileNo,
            labelText: Constants.mobileNo),
        SizedBox(height: 20.h),
        _textField(
          textInputType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return Constants.enterOTP;
            }
            return null;
          },
          onChange: (val) {
            if (val.length == 4) {
              setState(() {
                otp = val.toString();
              });
            } else {}
          },
          hintText: Constants.enterOtp,
          labelText: Constants.enterOtp,
        ),
        SizedBox(height: 20.h),
        _textField(
          textInputType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return Constants.enterFirstName;
            }
            return null;
          },
          onChange: (val) {
            setState(() {
              firstName = val.toString();
            });
          },
          hintText: Constants.first_Name,
          labelText: Constants.firstName,
        ),
        SizedBox(height: 20.h),
        _textField(
          textInputType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return Constants.enterLastName;
            }
            return null;
          },
          onChange: (val) {
            setState(() {
              lastName = val.toString();
            });
          },
          hintText: Constants.last_Name,
          labelText: Constants.lName,
        ),
        SizedBox(height: 20.h),
        _textField(
          textInputType: TextInputType.emailAddress,
          validator: (email) {
            if (email.isNotEmpty) {
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email);
              if (!emailValid) {
                return Constants.enterValidEmail;
              }
            }
            return null;
          },
          onChange: (val) {
            setState(() {
              email = val.toString();
            });
          },
          labelText: Constants.emailID,
          hintText: Constants.emailID,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
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
        shadowColor: HexColor('#DFDFDF'),
        backgroundColor: Colors.white,
        brightness: Brightness.light);
  }

  Widget _textField(
      {TextInputType? textInputType,
      Function? validator,
      Function? onChange,
      Function? onTap,
      String? hintText,
      TextEditingController? controller,
      String? labelText}) {
    return TextFormField(
        keyboardType: textInputType,
        controller: controller,
        focusNode: _assignFocus(hintText ?? ''),
        validator: (val) => validator!(val),
        onChanged: (val) => onChange!(val),
        onSaved: hintText == "Email ID"
            ? (value) {
                setState(() {
                  value!.isEmpty ? "" : email.toString();
                });
              }
            : null,
        style: FontStyle.logout,
        readOnly: hintText == "Mobile Number" ? true : false,
        maxLength: hintText == 'Enter OTP' ? 4 : null,
        inputFormatters: textInputFormatter(hintText ?? ''),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabledBorder: enableBorder,
            focusedBorder: focusBorder,
            labelText: hintText,
            hintText: hintText,
            counterText: '',
            suffix: onTap != null
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: HexColor(primaryColor),
                          fontWeight: FontWeight.w400),
                    ),
                  )
                : null,
            labelStyle: _assignFocus(hintText ?? '') != null
                ? _assignFocus(hintText ?? '').hasFocus
                    ? FontStyle.logout
                    : FontStyle.lightGrey16
                : FontStyle.logout,
            hintStyle: FontStyle.lightGrey16,
            contentPadding: const EdgeInsets.only(bottom: 0)));
  }

  Widget otpButton() {
    return Consumer<AppDataProvider>(builder: (context, data, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: CustomButton(
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
          raisedBtnColour: HexColor(primaryColor),
          buttonText: Constants.signUpTitle,
          onPressed: () {
            FocusScope.of(context).unfocus();
            formValidation(data);
          },
        ),
      );
    });
  }

  _assignFocus(String text) {
    switch (text) {
      case "Enter OTP":
        return focusOtp;
      case "First Name*":
        return focusFirstName;
      case "Last Name*":
        return focusLastName;
      case "Email ID":
        return focusEmail;
    }
  }

  List<TextInputFormatter>? textInputFormatter(String text) {
    List<TextInputFormatter>? val;
    switch (text) {
      case "Enter OTP":
        val = [
          LengthLimitingTextInputFormatter(4),
          FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
        ];
        break;
      case "First Name*":
        val = [FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true)];
        break;
      case "Last Name*":
        val = [FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true)];
        break;
    }
    return val;
  }

  Widget joinIkeaFamilyFields() {
    return Consumer<AppDataProvider>(builder: (context, model, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      );
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
              hintStyle: FontStyle.lightGrey16,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor(lightBlack))),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor(primaryColor), width: 2)),
            ),
            validator: (val) {
              setState(() {
                if (val == null || val.isEmpty) {
                  DOB = true;
                } else {
                  DOB = false;
                }
              });
              return null;
            },
          ),
          DOB
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
                  address = true;
                } else {
                  address = false;
                }
              });
            },
            validator: (val) {
              setState(() {
                if (val == null || val.isEmpty || model.address == null) {
                  address = true;
                } else {
                  address = false;
                }
              });
              return null;
            },
          ),
          address
              ? Helpers.textFieldError(Constants.errorText, context,
                  showError: true)
              : Container(),
          SizedBox(height: 26),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(Constants.gender,
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
          SizedBox(height: 16),
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
          Align(
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

  _dateOfBirthSelector(BuildContext context) async {
    final appProviderModel =
        Provider.of<AppDataProvider>(context, listen: false);
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
      setState(() {
        DOB = false;
      });
      appProviderModel.getDateOfBirth(formattedToDate ?? '');
    }
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
            ? (model.selectedNationalityName?.label ?? '')
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
        dropdownStyle: const DropdownStyle(elevation: 5),
        dropdownButtonStyle: DropdownButtonStyle(
            elevation: 0.5, padding: EdgeInsets.only(left: 0.w)),
        items: List.generate(
          nationalityList.length ?? 0,
          (index) => DropdownItem(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
              child: Text(
                nationalityList[index].label ?? '',
                style: FontStyle.selectQty,
              ),
            ),
            value: nationalityList[index],
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
      List<LivingSituations> livingSituationList = model.livingSituations!;
      return CustomDropdown<LivingSituations>(
        value: model.selectedLivingSituationName != null
            ? (model.selectedLivingSituationName?.label ?? '')
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
        dropdownStyle: const DropdownStyle(elevation: 5),
        dropdownButtonStyle: DropdownButtonStyle(
            elevation: 0.5,
            backgroundColor: HexColor('#FAFAFA'),
            primaryColor: HexColor('#C5C5C5'),
            padding: EdgeInsets.only(left: 0.w)),
        items: List.generate(
          livingSituationList.length,
          (index) => DropdownItem(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
              child: Text(
                livingSituationList[index].label ?? '',
                style: FontStyle.selectQty,
              ),
            ),
            value: livingSituationList[index],
          ),
        ),
      );
    });
  }

  void clearValidation() {
    setState(() {
      DOB = false;
      address = false;
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
