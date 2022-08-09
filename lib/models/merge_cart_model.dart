class MergeCartData {
  MergeCarts? mergeCarts;

  MergeCartData({this.mergeCarts});

  MergeCartData.fromJson(Map<String, dynamic> json) {
    mergeCarts = json['mergeCarts'] != null
        ? MergeCarts.fromJson(json['mergeCarts'])
        : null;
  }
}

class MergeCarts {
  String? id;

  MergeCarts({this.id});

  MergeCarts.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
  }
}
