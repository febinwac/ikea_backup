class NationalityModel {
  List<NationalityListings>? nationalityListings;

  NationalityModel({this.nationalityListings});

  NationalityModel.fromJson(Map<String, dynamic> json) {
    if (json['NationalityListings'] != null) {
      nationalityListings = <NationalityListings>[];
      json['NationalityListings'].forEach((v) {
        nationalityListings!.add(NationalityListings.fromJson(v));
      });
    }
  }
}

class NationalityListings {
  String? label;
  String? value;

  NationalityListings({this.label, this.value});

  NationalityListings.fromJson(Map<String, dynamic> json) {
    label = json['label'] ?? "";
    value = json['value'] ?? "";
  }
}

class LivingSituationModel {
  List<LivingSituations>? livingSituations;

  LivingSituationModel({this.livingSituations});

  LivingSituationModel.fromJson(Map<String, dynamic> json) {
    if (json['LivingSituations'] != null) {
      livingSituations = <LivingSituations>[];
      json['LivingSituations'].forEach((v) {
        livingSituations!.add(LivingSituations.fromJson(v));
      });
    }
  }
}

class LivingSituations {
  String? label;
  String? value;

  LivingSituations({this.label, this.value});

  LivingSituations.fromJson(Map<String, dynamic> json) {
    label = json['label'] ?? "";
    value = json['value'] ?? "";
  }
}
