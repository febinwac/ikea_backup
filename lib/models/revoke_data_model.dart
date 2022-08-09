class RevokeCustomerData {
  RevokeCustomerToken? revokeCustomerToken;
  String? errorMessage;

  RevokeCustomerData({this.revokeCustomerToken, this.errorMessage});

  RevokeCustomerData.fromJson(Map<String, dynamic> json) {
    revokeCustomerToken = json['revokeCustomerToken'] != null
        ? RevokeCustomerToken.fromJson(json['revokeCustomerToken'])
        : null;
  }
}

class RevokeCustomerToken {
  bool? result;

  RevokeCustomerToken({this.result});

  RevokeCustomerToken.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }
}
