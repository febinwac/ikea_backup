// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfm_module/common/check_exception.dart';
import 'package:sfm_module/common/constants.dart';
import 'package:sfm_module/common/nav_route.dart';
import 'package:sfm_module/providers/provider_helper_class.dart';
import 'package:sfm_module/services/app_data.dart';
import '../common/helpers.dart';
import '../common/preference_utils.dart';
import '../models/country_info_model.dart';
import '../models/customer_cart_model.dart';
import '../models/merge_cart_model.dart';
import '../models/nationality_living_model.dart';
import '../models/otp_model.dart';
import '../models/registration_data_model.dart';
import '../models/revoke_data_model.dart';
import '../services/graphQL_client.dart';
import 'cart_provider.dart';

class AppDataProvider with ChangeNotifier, ProviderHelperClass {
  OtpDataModel? otpData;
  bool joinIkeaFieldsLoading = false;
  String? firstname;
  String? message = "";
  bool isIkeaFamilySelected = false;
  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  bool smsPreferred = false;
  bool emailPreferred = false;
  bool isLoggedIn = false;

  ///join IKEA Family....
  List<String> preferredCommunicationChecked = [];
  List<NationalityListings>? nationalityListings;
  List<LivingSituations>? livingSituations;
  NationalityListings? selectedNationalityName;
  LivingSituations? selectedLivingSituationName;
  String? selectedDOB;
  String? address;
  String sms = "sms";
  String email = "email";

  ///verify OTP
  bool isInvalid = false;

  Color statusBarColor = Colors.white;

  Future<String> fetchCartId(BuildContext context) async {
    String cartId = "";
    cartId = await PreferenceUtils().getCartId();
    if (cartId.isEmpty) {
      final val = await Helpers.isInternetAvailable();
      if (val) {
        try {
          dynamic _resp = await serviceConfig.createEmptyCart();
          if (_resp != null && _resp['createEmptyCart'] != null) {
            cartId = _resp['createEmptyCart'];
            AppData.cartId = cartId;
            await PreferenceUtils.setStringToSF(PreferenceUtils.cartId, cartId);
          } else {
            Future.microtask(() {
              Check.checkException(
                _resp,
                context,
                onError: (value) {
                  if (value != null && value) {
                    cartId = "";
                  }
                },
                onAuthError: (value) {},
              );
            });
          }
        } catch (_) {
          cartId = "";
        }
      } else {
        updateLoadState(LoaderState.networkErr);
        cartId = "";
      }
    }
    return cartId;
  }

  Future<void> getCountryInfo(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.getCountryInfo();
      print("getCountryInfo $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['getCountryInfo'] != null) {
        CountryInfo data = CountryInfo.fromJson(_resp['getCountryInfo']);
        AppData.currencySymbol = data.currencySymbol ?? "";
        AppData.phone = data.phone ?? "";
        AppData.currencyCode = data.currencyCode ?? "";
        AppData.countryCode = data.countryCode ?? "";
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<String> createEmptyCart(BuildContext context) async {
    String cartId = "";
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.createEmptyCart();
      print("createEmptyCart $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['createEmptyCart'] != null) {
        cartId = _resp['createEmptyCart'];
        AppData.cartId = cartId;
        await PreferenceUtils.setStringToSF(PreferenceUtils.cartId, cartId);
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return cartId;
  }

  Future<bool> checkTokenExpiredOrNot(BuildContext context) async {
    bool expired = false;
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.checkTokenExpiredOrNot();
      print("checkTokenExpiredOrNot $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['isTokenExpired'] != null) {
        expired = _resp['isTokenExpired'];
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: () {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return expired;
  }

  Future<String> refreshCurrentToken(
      BuildContext context, String email, String tokenId) async {
    String newToken = "";
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp =
          await serviceConfig.refreshToken(email: email, tokenId: tokenId);
      print("checkTokenExpiredOrNot $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['customerRefreshToken'] != null) {
        newToken = _resp['customerRefreshToken'];
        AppData.accessToken = newToken;
        PreferenceUtils.setStringToSF(PreferenceUtils.prefAuthToken, newToken);
        notifyListeners();
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: (val) {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    return newToken;
  }

  /// Single sign on calls
  Future<void> registrationUsingOtp({
    required BuildContext context,
    String? value,
    String? otp,
    String? firstName,
    String? lastName,
    String? emailId,
  }) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        dynamic _resp = await serviceConfig.registrationUsingOtp(
            value: value,
            otp: otp,
            firstName: firstName,
            lastName: lastName,
            email: emailId,
            address: address ?? '',
            communicationPreferred: preferredCommunicationChecked,
            dateOfBirth: selectedDOB ?? '',
            gender: isMaleSelected ? 1 : 0,
            ikeaFamily: isIkeaFamilySelected,
            livingSituation: selectedLivingSituationName?.label ?? "",
            nationality: selectedNationalityName?.label ?? "");
        print("registrationUsingOtp $_resp");
        updateLoadState(LoaderState.loaded);
        if (_resp != null && _resp['registrationUsingOtp'] != null) {
          setUserData(RegisteredData.fromJson(_resp), context);
        } else {
          Future.microtask(() {
            Check.checkException(_resp, context,
                onError: () {}, onAuthError: (value) {});
          });
        }
      } catch (e) {
        print(e);
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> sendOtp(
      {required BuildContext context,
      String? value,
      required bool isResend}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        dynamic _resp =
            await serviceConfig.sendOtp(value: value, isResend: isResend);
        print("sendOtp $_resp");
        updateLoadState(LoaderState.loaded);
        if (_resp != null && _resp['sendLoginOtpV2'] != null) {
          otpData = OtpDataModel.fromJson(_resp['sendLoginOtpV2']);
          bool isOtpSend = otpData?.otpSend ?? false;
          if (isOtpSend) {
            if (!isResend) {
              NavRoutes.navToVerifyOTPPage(context, value ?? '');
            } else {
              Future.microtask(() {
                Helpers.showFlushBar(Constants.resendOtpSuccess, context,
                    Icons.sms_failed_outlined);
              });
            }
          }
          notifyListeners();
        } else {
          Future.microtask(() {
            Check.checkException(_resp, context,
                onError: (value) {},
                onAuthError: (value) {}, noCustomer: (val) {
              if (val != null && val) {
                sendRegistrationOtp(
                    context: context, value: value, isResend: false);
              }
            });
          });
        }
      } catch (e, stackTrace) {
        print(stackTrace);
        print(e);
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  ///Verify OTP
  Future<void> verifyOtp(
      {required BuildContext context,
      String value = '',
      String otp = '',
      String dateOfBirth = '',
      int gender = 0,
      bool isIkeaFamily = false,
      String address = '',
      String nationality = '',
      String livingSituation = '',
      List<String>? communicationPreferred}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        dynamic resp = await serviceConfig.verifyOtp(
            value: value,
            otp: otp,
            nationality: nationality,
            livingSituation: livingSituation,
            ikeaFamily: isIkeaFamily,
            gender: gender,
            dateOfBirth: dateOfBirth,
            communicationPreferred: communicationPreferred != null &&
                    communicationPreferred.isNotEmpty
                ? communicationPreferred
                : [],
            address: address);
        log("VERIFY OTP RESPONSE : $resp");

        if (resp != null) {
          if (resp['loginUsingOtp'] != null) {
            isInvalid = false;
            RegistrationUsingOtp registrationUsingOtp =
                RegistrationUsingOtp.fromJson(resp['loginUsingOtp']);
            print(
                "Verify using otp ${registrationUsingOtp.customer?.firstname ?? ""}");
            saveCustomerDetails(registrationUsingOtp.customer);
            setPreferenceKey(context, registrationUsingOtp);
            updateLoadState(LoaderState.loaded);
          } else {
            isInvalid = true;
            Future.microtask(() {
              Check.checkException(resp, context,
                  onError: (value) {}, onAuthError: (value) {});
            });
            updateLoadState(LoaderState.loaded);
          }
        }
      } catch (e) {
        Future.microtask(() {
          Helpers.showFlushBar(
              Constants.somethingWrong, context, Icons.sms_failed_outlined);
        });
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> sendRegistrationOtp(
      {required BuildContext context,
      String? value,
      required bool isResend}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic resp = await serviceConfig.sendRegistrationOtp(
          value: value, isResend: isResend);

      if (resp["status"] == "error") {
        Future.microtask(() {
          Check.checkException(resp, context,
              onError: () {}, onAuthError: (value) {});
        });
        updateLoadState(LoaderState.loaded);
      } else {
        updateLoadState(LoaderState.loaded);
        if (resp['sendRegistrationOtp'] == true) {
          NavRoutes.navToRegistrationPage(context, value ?? '');
        }
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  ///***** SSO Join IKEA Family Functions......
  Future<void> getNationality(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateIkeaFieldsLoading(true);
        dynamic resp = await serviceConfig.getNationality();
        if (resp['status'] == "error") {
          updateIkeaFieldsLoading(false);
          Future.microtask(() {
            Check.checkException(resp, context,
                onError: () {}, onAuthError: (value) {});
          });
        } else {
          NationalityModel nationalityModel = NationalityModel.fromJson(resp);
          if (nationalityModel.nationalityListings != null &&
              nationalityModel.nationalityListings!.isNotEmpty) {
            nationalityListings = nationalityModel.nationalityListings;
          }
          updateIkeaFieldsLoading(false);
        }
      } catch (err) {
        updateIkeaFieldsLoading(false);
      }
    } else {
      updateIkeaFieldsLoading(false);
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getLivingSituation(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateIkeaFieldsLoading(true);
        notifyListeners();
        dynamic resp = await serviceConfig.getLivingLocation();
        if (resp['status'] == "error") {
          updateIkeaFieldsLoading(false);
          Future.microtask(() {
            Check.checkException(resp, context,
                onError: () {}, onAuthError: (value) {});
          });
        } else {
          LivingSituationModel livingSituationModel =
              LivingSituationModel.fromJson(resp);
          if (livingSituationModel.livingSituations != null &&
              livingSituationModel.livingSituations!.isNotEmpty) {
            livingSituations = livingSituationModel.livingSituations;
          }
          updateIkeaFieldsLoading(false);
        }
      } catch (e) {
        updateIkeaFieldsLoading(false);
      }
    } else {
      updateIkeaFieldsLoading(false);
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getCustomerCartId({required BuildContext context}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        dynamic _resp = await serviceConfig.getCustomerCartId();
        print("customerCart $_resp");
        updateLoadState(LoaderState.loaded);
        if (_resp != null && _resp['customerCart'] != null) {
          CustomerCartData customerCartData = CustomerCartData.fromJson(_resp);
          print(
              "Customer cart id  = ${customerCartData.customerCart?.id ?? ""}");
          String customerCartId = customerCartData.customerCart?.id ?? "";
          Future.microtask(() {
            switchCartStore(customerCartId, context);
          });
          notifyListeners();
        } else {
          Future.microtask(() {
            Check.checkException(_resp, context,
                onError: () {}, onAuthError: (value) {});
          });
        }
      } catch (stackTrace, e) {
        print(stackTrace);
        print(e);
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void switchCartStore(String destinationCartId, BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.switchCartStore(destinationCartId);
      print("switchCartStore : $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['switchCartStore'] != null) {
        Future.microtask(() {
          mergeCartId(destinationCartId: destinationCartId, context: context);
        });
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: (val) {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  mergeCartId(
      {required String destinationCartId,
      required BuildContext context}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      dynamic _resp = await serviceConfig.mergeCarts(
          sourceCartId: AppData.cartId, destinationCartId: destinationCartId);

      print("mergeCarts : $_resp");
      updateLoadState(LoaderState.loaded);
      if (_resp != null && _resp['mergeCarts'] != null) {
        MergeCartData mergeCartData = MergeCartData.fromJson(_resp);
        await PreferenceUtils.setStringToSF(
            PreferenceUtils.cartId, mergeCartData.mergeCarts?.id ?? "");
        AppData.cartId = mergeCartData.mergeCarts?.id ?? "";
        updateLoggedInState(true);
        Future.microtask(() {
          NavRoutes.navRemoveBottomNavMainPage(context);
        });
      } else {
        Future.microtask(() {
          Check.checkException(_resp, context,
              onError: (val) {}, onAuthError: (value) {});
        });
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void setUserData(RegisteredData registeredData, BuildContext context) async {
    await PreferenceUtils.setStringToSF(PreferenceUtils.prefAuthToken,
        registeredData.registrationUsingOtp?.token ?? "");
    await PreferenceUtils.setStringToSF(PreferenceUtils.prefUsername,
        registeredData.registrationUsingOtp?.customer?.firstname ?? "");
    AppData.accessToken = registeredData.registrationUsingOtp?.token ?? "";
    AppData.name =
        registeredData.registrationUsingOtp?.customer?.firstname ?? "";
    setPreferenceKey(context, registeredData.registrationUsingOtp);
  }

  Future<bool> revokeCustomerToken({required BuildContext context}) async {
    bool flag = false;
    final network = await Helpers.isInternetAvailable();
    if (network) {
      updateLoadState(LoaderState.loading);
      try {
        final _resp = await serviceConfig.revokeCustomerToken();
        updateLoadState(LoaderState.loaded);
        print("revokeCustomerToken $_resp");
        if (_resp['revokeCustomerToken'] != null &&
            _resp['revokeCustomerToken']['result'] == true) {
          flag = true;
        } else {
          Future.microtask(() {
            Check.checkException(_resp, context, onError: (value) {
              if (value != null && value) {
                flag = true;
              }
            }, onAuthError: (value) {
              if (value) {
                flag = true;
              } else {
                flag = true;
              }
            });
          });
        }
      } catch (e) {
        print(e);
        flag = false;
      }
    } else {
      flag = false;
    }
    debugPrint("Logged out");
    return flag;
  }

  Future<void> getDeleteAccountOtp(
      {required BuildContext context,
      required String phone,
      required bool isResend,
      required Function onSuccess,
      required Function onFailure}) async {
    bool isSuccess = false;
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getDeleteAccountOtp(
            phone: phone, isResend: isResend);
        print("getDeleteAccountOtp $_resp");
        updateLoadState(LoaderState.loaded);
        if (_resp != null && _resp["deleteAccountOtp"] != null) {
          isSuccess = _resp["deleteAccountOtp"];
          if (isSuccess) {
            onSuccess();
          } else {
            onFailure(_resp["message"] ?? Constants.somethingWrong);
          }
        } else {
          onFailure(_resp["message"] ?? Constants.somethingWrong);
        }
      } catch (e) {
        onFailure(Constants.somethingWrong);
      }
    } else {
      onFailure(Constants.noInternet);
    }
  }

  setPreferenceKey(
      BuildContext context, RegistrationUsingOtp? registrationUsingOtp) async {
    if (registrationUsingOtp != null &&
        registrationUsingOtp.token != null &&
        registrationUsingOtp.token!.isNotEmpty) {
      AppData.accessToken = registrationUsingOtp.token ?? '';
      await PreferenceUtils.setStringToSF(
          PreferenceUtils.prefAuthToken, registrationUsingOtp.token ?? '');
      GraphQLClientConfiguration.instance.config().then((value) {
        if (value) {
          getCustomerCartId(context: context);
        }
      });

      notifyListeners();
    }
  }

  void saveCustomerDetails(Customer? customer) async {
    if (customer != null) {
      await PreferenceUtils.setStringToSF(
          PreferenceUtils.prefUsername, customer.firstname ?? '');
      AppData.name = customer.firstname ?? '';
      await PreferenceUtils.setStringToSF(
          PreferenceUtils.customerPhone, customer.mobileNumber ?? '');
    }
    notifyListeners();
  }

  void onNationalityChanged(NationalityListings nationalitySelected) {
    selectedNationalityName = nationalitySelected;
    notifyListeners();
  }

  void onLivingSituationChanged(LivingSituations livingSituationSelected) {
    selectedLivingSituationName = livingSituationSelected;
    notifyListeners();
  }

  void updateIkeaFamilySelected() {
    isIkeaFamilySelected = !isIkeaFamilySelected;
    notifyListeners();
  }

  void updateMaleSelected() {
    isMaleSelected = !isMaleSelected;
    if (isMaleSelected == true) {
      isFemaleSelected = false;
    } else {
      isMaleSelected = true;
    }
    notifyListeners();
  }

  void updateFemaleSelected() {
    isFemaleSelected = !isFemaleSelected;
    if (isFemaleSelected == true) {
      isMaleSelected = false;
    } else {
      isFemaleSelected = true;
    }
    notifyListeners();
  }

  void updateSmsPreferred() {
    smsPreferred = !smsPreferred;
    if (smsPreferred == true) {
      preferredCommunicationChecked.add(sms);
    } else {
      preferredCommunicationChecked.remove(sms);
    }
    notifyListeners();
  }

  void updateEmailPreferred() {
    emailPreferred = !emailPreferred;
    if (emailPreferred == true) {
      preferredCommunicationChecked.add(email);
    } else {
      preferredCommunicationChecked.remove(email);
    }
    notifyListeners();
  }

  void getAddress(String getAddress) {
    address = getAddress;
    notifyListeners();
  }

  void getDateOfBirth(String getSelectedDOB) {
    selectedDOB = getSelectedDOB;
    notifyListeners();
  }

  void updateIkeaFieldsLoading(val) {
    joinIkeaFieldsLoading = val;
    notifyListeners();
  }

  void clearIkeaFamilySelected() {
    isIkeaFamilySelected = false;
    notifyListeners();
  }

  void clear() {
    address = '';
    selectedDOB = '';
    preferredCommunicationChecked = [];
    preferredCommunicationChecked.clear();
    selectedNationalityName = null;
    selectedLivingSituationName = null;
    isMaleSelected = false;
    isFemaleSelected = false;
    smsPreferred = false;
    emailPreferred = false;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    updateLoadState(LoaderState.loading);
    AppData().clearInfo();
    await PreferenceUtils.remove(PreferenceUtils.prefAuthToken);
    await PreferenceUtils.remove(PreferenceUtils.prefIsLoggedin);
    await PreferenceUtils.remove(PreferenceUtils.prefUsername);
    await PreferenceUtils.remove(PreferenceUtils.recentLocation);
    await PreferenceUtils.remove(PreferenceUtils.customerCartId);
    await PreferenceUtils.remove(PreferenceUtils.customerPhone);
    await PreferenceUtils.remove(PreferenceUtils.cartId);
    await PreferenceUtils.remove(PreferenceUtils.phone);
    await PreferenceUtils.remove(PreferenceUtils.currency);
    await PreferenceUtils.remove(PreferenceUtils.addToCartQuantity);
    await PreferenceUtils.remove(PreferenceUtils.addToCartProduct);
    context.read<CartProvider>().updateCartCount(0);
    context.read<AppDataProvider>().updateLoggedInState(false);
    GraphQLClientConfiguration.instance.config(context: context).then((value) {
      if (value) {
        Future.microtask(
            () => context.read<AppDataProvider>().createEmptyCart(context));
        Future.microtask(
            () => context.read<AppDataProvider>().getCountryInfo(context));
      }
    });
    updateLoadState(LoaderState.loaded);
    notifyListeners();
  }

  updateStatusBarColor(Color color) {
    statusBarColor = color;
    notifyListeners();
  }

  void updateLoggedInState(bool val) {
    debugPrint("logged state $val");
    isLoggedIn = val;
    notifyListeners();
  }
}
