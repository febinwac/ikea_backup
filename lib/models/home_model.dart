import 'dart:convert';

import 'package:sfm_module/models/product_model.dart';

class HomeModel {
  Data? data;

  HomeModel({this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Customcms? customcms;

  Data({this.customcms});

  Data.fromJson(Map<String, dynamic> json) {
    customcms = json['Customcms'] != null
        ? Customcms.fromJson(json['Customcms'])
        : null;
  }
}

class Customcms {
  List<ContentData>? contentData;

  String? content;
  String? contentType;
  String? metaDescription;
  String? metaKeywords;
  String? metaTitle;
  String? title;

  Customcms(
      {this.content,
      this.contentType,
      this.metaDescription,
      this.metaKeywords,
      this.metaTitle,
      this.title});

  Customcms.fromJson(Map<String, dynamic> json) {
    content = json['content'] ?? "";
    if (jsonDecode(content ?? "") != null) {
      contentData = <ContentData>[];
      jsonDecode(content ?? "").forEach((v) {
        contentData?.add(ContentData.fromJson(v));
      });
    } else {
      contentData = [];
    }

    contentType = json['content_type'] ?? "";
    metaDescription = json['meta_description'] ?? "";
    metaKeywords = json['meta_keywords'] ?? "";
    metaTitle = json['meta_title'] ?? "";
    title = json['title'] ?? "";
  }
}

class ContentData {
  String? blockTitle;
  String? blockType;
  String? position;
  List<Categories>? categories;
  List<Content>? content;
  int? blockId;
  String? title;
  String? linkType;
  String? linkId;
  int? productCount;
  List<ProductModel>? products;
  List<Images>? images;
  String? blockDescription;

  ContentData(
      {this.blockTitle,
      this.blockType,
      this.position,
      this.content,
      this.blockId,
      this.title,
      this.linkType,
      this.linkId,
      this.categories,
      this.productCount,
      this.images,
      this.products,
      this.blockDescription});

  ContentData.fromJson(Map<String, dynamic> json) {
    blockTitle = json['block_title'];
    blockType = json['block_type'];
    position = json['position'];

    if (json.containsKey('content')) {
      if (json['content'] != null) {
        content = <Content>[];
        json['content'].forEach((v) {
          content?.add(Content.fromJson(v));
        });
      }
    } else {
      content = [];
    }

    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    } else {
      categories = [];
    }

    if (json.containsKey('title')) {
      title = json['title'] ?? "";
    } else {
      title = "";
    }
    if (json.containsKey('link_type')) {
      linkType = json['link_type'];
    } else {
      linkType = "";
    }

    if (json.containsKey('link_id')) {
      linkId = json['link_id'];
    } else {
      linkId = "";
    }

    if (json.containsKey('product_count')) {
      if (json['product_count'] != null) {
        productCount = json['product_count'];
      } else {
        productCount = 0;
      }
    } else {
      productCount = 0;
    }

    if (json.containsKey('products')) {
      if (json['products'] != null) {
        products = <ProductModel>[];
        json['products'].forEach((v) {
          products?.add(ProductModel.fromJson(v));
        });
      }
    } else {
      products = [];
    }
    if (json.containsKey('images')) {
      if (json['images'] != null) {
        images = <Images>[];
        json['images'].forEach((v) {
          images?.add(Images.fromJson(v));
        });
      }
    } else {
      images = [];
    }

    if (json.containsKey('block_description')) {
      blockDescription = json['block_description'] ?? "";
    } else {
      blockDescription = "";
    }
    if (json['block_id'] != null) {
      blockId = json['block_id'];
    } else {
      blockId = 0;
    }
  }
}

class Categories {
  String? categoryId;
  String? categoryName;
  String? categoryImage;
  String? offer;
  String? tag;
  String? url;
  String? startingPrice;

  Categories(
      {this.categoryId,
      this.categoryName,
      this.categoryImage,
      this.offer,
      this.tag,
      this.url,
      this.startingPrice});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'] ?? "";
    categoryName = json['category_name'] ?? "";
    categoryImage = json['category_image'] ?? "";
    offer = json['offer'] ?? "";
    tag = json['tag'] ?? "";
    url = json['url'] ?? "";
    startingPrice = json['starting_price'] ?? "";
  }
}

class Content {
  String? banner;
  String? tabBanner;
  String? linkType;
  String? linkId;
  String? image;

  Content(
      {this.banner, this.tabBanner, this.linkType, this.linkId, this.image});

  Content.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] ?? "";
    tabBanner = json['tab_banner'] ?? "";
    linkType = json['link_type'] ?? "";
    linkId = json['link_id'] ?? "";
    image = json['image'] ?? "";
  }
}
class BannerModel {
  String _url;
  String _linkType;
  String _linkId;
  String _content;

  BannerModel(this._url, this._linkType, this._linkId, this._content);

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get linkId => _linkId;

  set linkId(String value) {
    _linkId = value;
  }

  String get linkType => _linkType;

  set linkType(String value) {
    _linkType = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}
