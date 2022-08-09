import 'package:sfm_module/models/registration_data_model.dart';

class OtpModel {
  OtpDataModel? data;
  List<Errors>? errors;
  String? message;

  OtpModel({this.data, this.errors, this.message});

  OtpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? OtpDataModel.fromJson(json['data']) : null;
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }
}

class OtpDataModel {
  bool? otpSend;
  bool? isIkeaFamily;

  OtpDataModel({this.otpSend = false, this.isIkeaFamily = false});

  OtpDataModel.fromJson(Map<String, dynamic> json) {
    otpSend = json['otp_send'] ?? false;
    isIkeaFamily = json['is_ikea_family'] ?? false;
  }
}
