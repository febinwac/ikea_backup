
class DeleteAccountPointsModel {
  DeleteAccount? data;

  DeleteAccountPointsModel({this.data});

  DeleteAccountPointsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DeleteAccount.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeleteAccount {
  String? title;
  String? subTitle;
  List<ContentList>? contentList;

  DeleteAccount({this.title, this.subTitle, this.contentList});

  DeleteAccount.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['sub_title'];
    if (json['content_list'] != null) {
      contentList = <ContentList>[];
      json['content_list'].forEach((v) {
        contentList!.add(ContentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['sub_title'] = subTitle;
    if (contentList != null) {
      data['content_list'] = contentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContentList {
  String? content;

  ContentList({this.content});

  ContentList.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}
