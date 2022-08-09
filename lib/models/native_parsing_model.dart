class NativeParsingModel{
  String? language;
  String? flavourEnvironment;

  NativeParsingModel({this.language, this.flavourEnvironment});

  NativeParsingModel.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    flavourEnvironment = json['flavourEnvironment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['flavourEnvironment'] = this.flavourEnvironment;
    return data;
  }
}