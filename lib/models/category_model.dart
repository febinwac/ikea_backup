import 'package:sfm_module/models/product_model.dart';

class CategoryData {
  List<AllCategories>? allcategories;
  List<ProductModel>? productList;

  CategoryData({this.allcategories});

  CategoryData.fromJson(Map<String, dynamic> json) {
    if (json['Allcategories'] != null) {
      allcategories = <AllCategories>[];
      json['Allcategories'].forEach((v) {
        allcategories?.add(AllCategories.fromJson(v));
      });
    } else {
      allcategories = [];
    }
  }
}

class CategoryDetailData {
  ProductsList? products;
  List<CategoryList>? categoryList;

  CategoryDetailData({this.products, this.categoryList});

  CategoryDetailData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('products')) {
      products = ProductsList.fromJson(json['products']);
    }
    if (json.containsKey('categoryList')) {
      if (json['categoryList'] != null) {
        categoryList = <CategoryList>[];
        json['categoryList'].forEach((v) {
          categoryList?.add(CategoryList.fromJson(v));
        });
      } else {
        categoryList = [];
      }
    }
  }
}

class ProductsList {
  List<ProductModel>? productList;
  ProductsList({this.productList});

  ProductsList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      productList = <ProductModel>[];
      json['items'].forEach((v) {
        productList?.add(ProductModel.fromJson(v));
      });
    } else {
      productList = [];
    }
  }
}

class CategoryList {
  int? id;
  String? name;
  String? bannerImage;

  CategoryList({this.id, this.name, this.bannerImage});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bannerImage = json['category_banner_mobile'];
  }
}

class AllCategories {
  String? id;
  String? name;
  String? image;

  AllCategories({this.id, this.name, this.image});

  AllCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class CategoryArguments {
  final int index;
  final String productName;
  final String productId;
  final List<AllCategories> allCategories;

  CategoryArguments(
      this.index, this.productName, this.productId, this.allCategories);
}
