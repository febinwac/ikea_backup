class CountryInfo {
  String? countryCode;
  String? currencyCode;
  String? currencySymbol;
  String? phone;

  CountryInfo({this.countryCode, this.currencyCode, this.currencySymbol});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code']??"";
    currencyCode = json['currency_code']??"";
    currencySymbol = json['currency_symbol']??"";
    phone = json['phone']??"";
  }
}
