class RegistrationModel {
  RegisteredData? data;
  String? message;
  List<Errors>? errors;

  RegistrationModel({this.errors, this.data, this.message});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? RegisteredData.fromJson(json['data']) : null;
    if (json.containsKey('errors')) {
      if (json['errors'] != null) {
        errors = <Errors>[];
        json['errors'].forEach((v) {
          errors?.add(Errors.fromJson(v));
        });
      }
    } else {
      errors = null;
    }
  }
}

class RegisteredData {
  RegistrationUsingOtp? registrationUsingOtp;

  RegisteredData({this.registrationUsingOtp});

  RegisteredData.fromJson(Map<String, dynamic> json) {
    registrationUsingOtp = json['registrationUsingOtp'] != null
        ? RegistrationUsingOtp.fromJson(json['registrationUsingOtp'])
        : null;
  }
}

class RegistrationUsingOtp {
  String? token;
  Customer? customer;

  RegistrationUsingOtp({this.token, this.customer});

  RegistrationUsingOtp.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }
}

class Customer {
  String? firstname;
  String? mobileNumber;

  Customer({this.firstname, this.mobileNumber});

  Customer.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    if (json.containsKey("mobile_number")) {
      mobileNumber = json['mobile_number'];
    }
  }
}

class Errors {
  String? message;
  Extensions? extensions;
  List<Locations>? locations;
  List<String>? path;

  Errors({this.message, this.extensions, this.locations, this.path});

  Errors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    extensions = json['extensions'] != null
        ? Extensions.fromJson(json['extensions'])
        : null;
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations?.add(Locations.fromJson(v));
      });
    }
    path = json['path'].cast<String>();
  }
}

class Extensions {
  String? category;

  Extensions({this.category});

  Extensions.fromJson(Map<String, dynamic> json) {
    category = json['category'];
  }
}

class Locations {
  int? line;
  int? column;

  Locations({this.line, this.column});

  Locations.fromJson(Map<String, dynamic> json) {
    line = json['line'];
    column = json['column'];
  }
}
