import 'dart:convert';

class AddressModel {
  CustomerData? data;

  AddressModel({this.data});

  AddressModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CustomerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CustomerData {
  Customer? customer;

  CustomerData({this.customer});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  List<Addresses>? addresses;
  String? email;
  String? firstname;
  bool? isIkeaFamilyCustomer;
  String? lastname;
  String? mobileNumber;
  String? dateOfBirth;
  int? gender;
  String? phoneCountryCode;

  Customer(
      {this.addresses,
      this.email,
      this.firstname,
      this.isIkeaFamilyCustomer,
      this.lastname,
      this.mobileNumber,
      this.dateOfBirth,
      this.gender,
      this.phoneCountryCode});

  Customer.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
    email = json['email'];
    firstname = json['firstname'];
    isIkeaFamilyCustomer = json['is_ikea_family_customer'];
    lastname = json['lastname'];
    mobileNumber = json['mobile_number'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    phoneCountryCode = json['phone_country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    data['email'] = email;
    data['firstname'] = firstname;
    data['is_ikea_family_customer'] = isIkeaFamilyCustomer;
    data['lastname'] = lastname;
    data['mobile_number'] = mobileNumber;
    data['gender'] = gender;
    data['phone_country_code'] = phoneCountryCode;
    return data;
  }
}

class Addresses {
  String? addressType;
  String? city;
  String? countryCode;
  bool? defaultShipping;
  String? workdays;
  String? telephone;
  List<String>? street;
  Region? region;
  String? lng;
  String? lat;
  String? lastname;
  int? id;
  String? firstname;
  WorkDays? workDaysData;

  Addresses(
      {this.addressType,
      this.city,
      this.countryCode,
      this.defaultShipping,
      this.workdays,
      this.telephone,
      this.street,
      this.region,
      this.lng,
      this.lat,
      this.lastname,
      this.id,
      this.firstname});

  Addresses.fromJson(Map<String, dynamic> json) {
    addressType = json['addresstype'];
    city = json['city'];
    countryCode = json['country_code'];
    defaultShipping = json['default_shipping'];
    workdays = json['workdays'];
    if (workdays != null) {
      if (jsonDecode(workdays ?? "") != null) {
        workDaysData = WorkDays();
        workDaysData = WorkDays.fromJson(jsonDecode(workdays ?? ""));
      }
    }
    telephone = json['telephone'];
    street = json['street'].cast<String>();
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    lng = json['lng'];
    lat = json['lat'];
    lastname = json['lastname'];
    id = json['id'];
    firstname = json['firstname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addresstype'] = addressType;
    data['city'] = city;
    data['country_code'] = countryCode;
    data['default_shipping'] = defaultShipping;
    data['workdays'] = workdays;
    data['telephone'] = telephone;
    data['street'] = street;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    data['lng'] = lng;
    data['lat'] = lat;
    data['lastname'] = lastname;
    data['id'] = id;
    data['firstname'] = firstname;
    return data;
  }
}

class WorkDays {
  bool? openOnSaturday;
  bool? openOnFriday;

  WorkDays({this.openOnSaturday, this.openOnFriday});

  WorkDays.fromJson(Map<String, dynamic> json) {
    openOnFriday = json['open_on_friday'];
    openOnSaturday = json['open_on_saturday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_on_saturday'] = openOnSaturday;
    data['open_on_friday'] = openOnFriday;
    return data;
  }
}

class Region {
  String? region;
  String? regionCode;

  Region({this.region, this.regionCode});

  Region.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    regionCode = json['region_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region'] = region;
    data['region_code'] = regionCode;
    return data;
  }
}

class AddressArguments {
  bool isEdit;
  String addressType;
  String city;
  String countryCode;
  bool defaultShipping;
  String workdays;
  String telephone;
  List<String> street;
  Region region;
  String lng;
  String lat;
  String lastname;
  int id;
  String firstname;
  WorkDays workDays;

  AddressArguments(
      this.isEdit,
      this.addressType,
      this.city,
      this.countryCode,
      this.defaultShipping,
      this.workdays,
      this.telephone,
      this.street,
      this.region,
      this.lng,
      this.lat,
      this.lastname,
      this.id,
      this.workDays,
      this.firstname);
}
