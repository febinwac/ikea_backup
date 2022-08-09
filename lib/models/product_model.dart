import 'package:sfm_module/common/helpers.dart';

import 'cart_model.dart';

class ProductModel {
  int? id;
  String? sku;
  String? productName;
  String? url;
  String? tag;
  bool? haveAddon;
  String? regularPrice;
  String? discount;
  PriceRange? priceRange;
  TirePrice? tirePrice;
  int? discountPercentage;
  String? image;
  Images? images;
  String? familyName;
  Images? imagesOther;
  String? type;
  List<UpsellProductsForCart>? addOnProducts;
  bool? isWishList = false;
  bool isAddToCartLoading = false;
  int? quantity = 0;
  bool isAddedToCart = false;
  String? cartItemId = "0";
  bool? isChecked = false;
  Thumbnail? smallImage;
  double? ikeaFamilyPrice;
  String? stockStatus;
  ShortDescription? descriptionForDetails;
  List<MediaGallery>? mediaGallery;
  List<ProductModel>? relatedProducts;
  String? sTypename;
  String? shortDescription;
  List<ConfigurableOptions>? configurableOptions;
  List<Variants>? variants;
  String? parentSku;
  ProductModel(
      {this.id,
      this.sku,
      this.productName,
      this.url,
      this.tag,
      this.haveAddon,
      this.regularPrice,
      this.discount,
      this.priceRange,
      this.discountPercentage,
      this.tirePrice,
      this.image,
      this.images,
      this.imagesOther,
      this.familyName,
      this.type,
      this.isWishList,
      this.ikeaFamilyPrice,
      this.addOnProducts,
      this.configurableOptions,
      this.variants,
      this.mediaGallery,
      this.shortDescription = "",
      this.descriptionForDetails ,
      this.parentSku = "",
      this.quantity});

  ProductModel.fromJson(Map<String, dynamic> json) {
    parentSku="";
    id = Helpers.convertToInt(json['id']);
    sku = json['sku'] ?? "";
    if (json.containsKey("product_name")) {
      productName = json['product_name'] ?? "";
    } else {
      productName = json['name'] ?? "";
    }
    if (json.containsKey("ikea_family_price")) {
      ikeaFamilyPrice = Helpers.convertValueToDouble(json['ikea_family_price']);
    } else {
      ikeaFamilyPrice = 0;
    }

    url = json['url'] ?? "";
    if (json.containsKey("discount_percentage")) {
      discountPercentage = Helpers.convertToInt(json['discount_percentage']);
    } else {
      discountPercentage = 0;
    }
    tag = json['tag'] ?? "";
    haveAddon = json['have_addon'];
    familyName = Helpers.capitaliseAll(json['family_name'] ?? "");
    regularPrice = json['regular_price'] ?? "";
    discount = json['discount'] ?? "";
    priceRange = json['price_range'] != null
        ? PriceRange.fromJson(json['price_range'])
        : null;
    if (json.containsKey('short_description')) {
      if (json['short_description'].runtimeType == String) {
        shortDescription = json['short_description'];
      } else {
        descriptionForDetails = json['short_description'] != null
            ? ShortDescription.fromJson(json['short_description'])
            : null;
      }
    }
    if (json.containsKey('media_gallery')) {
      if (json['media_gallery'] != null) {
        mediaGallery = <MediaGallery>[];
        json['media_gallery'].forEach((v) {
          mediaGallery!.add(MediaGallery.fromJson(v));
        });
      }
    }

    tirePrice = json['tire_price'] != null
        ? TirePrice.fromJson(json['tire_price'])
        : null;

    if (json['image'].runtimeType == String) {
      image = json['image'] ?? "";
    } else {
      images = json['image'] != null ? Images.fromJson(json['image']) : null;
    }

    if (json.containsKey('images') && json['images'].runtimeType != String) {
      images = json['images'] != null ? Images.fromJson(json['images']) : null;
    }
    if (json.containsKey('small_image')) {
      smallImage = json['small_image'] != null
          ? Thumbnail.fromJson(json['small_image'])
          : null;
    }

    imagesOther = json['images_other'] != null
        ? Images.fromJson(json['images_other'])
        : null;
    type = json['type'] ?? "";
    addOnProducts = <UpsellProductsForCart>[];
    if (json.containsKey('upsell_pdts')) {
      if (json['upsell_pdts'] != null) {
        json['upsell_pdts'].forEach((v) {
          addOnProducts?.add(UpsellProductsForCart.fromJson(v));
        });
      } else {
        addOnProducts = [];
      }
    } else {
      addOnProducts = [];
    }
    if (json.containsKey('configurable_options')) {
      if (json['configurable_options'] != null) {
        configurableOptions = <ConfigurableOptions>[];
        json['configurable_options'].forEach((v) {
          configurableOptions?.add(ConfigurableOptions.fromJson(v));
        });
      }else{
        configurableOptions=[];
      }
    }
    if (json.containsKey('variants')) {
      if (json['variants'] != null) {
        variants = <Variants>[];
        json['variants'].forEach((v) {
          variants?.add(Variants.fromJson(v));
        });
      }
      else{
        variants=[];
      }
    }
  }
  ProductModel copyWith({ProductModel? previousItem}) {
    return ProductModel(
        id: id,
        productName: productName,
        sku: sku,
        parentSku: previousItem?.sku ?? parentSku,
        url: url,
        priceRange: priceRange,
        ikeaFamilyPrice: ikeaFamilyPrice,
        descriptionForDetails: descriptionForDetails,
        mediaGallery: mediaGallery,
        type: previousItem?.sTypename ?? "",
        familyName: familyName,
        configurableOptions: previousItem?.configurableOptions ?? configurableOptions,
        variants: previousItem?.variants ?? variants,
        addOnProducts: previousItem?.addOnProducts??addOnProducts);
  }
}

class Images {
  String? desktop;
  String? desktop2x;
  String? laptop;
  String? laptop2x;
  String? mobile;
  String? mobile2x;
  String? ipad;
  String? ipad2x;
  String? placeholder;

  Images(
      {this.desktop,
      this.desktop2x,
      this.laptop,
      this.laptop2x,
      this.mobile,
      this.mobile2x,
      this.ipad,
      this.ipad2x,
      this.placeholder});

  Images.fromJson(Map<String, dynamic> json) {
    desktop = json['desktop'] ?? "";
    desktop2x = json['desktop_2x'] ?? "";
    laptop = json['laptop'] ?? "";
    laptop2x = json['laptop_2x'] ?? "";
    mobile = json['mobile'] ?? "";
    mobile2x = json['mobile_2x'] ?? "";
    ipad = json['ipad'] ?? "";
    ipad2x = json['ipad_2x'] ?? "";
    placeholder = json['placeholder'] ?? "";
  }
}

class Thumbnail {
  String? mobileApp;

  Thumbnail({this.mobileApp});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    mobileApp = json['mobile_app'] ?? "";
  }
}

class ShortDescription {
  String? html;

  ShortDescription({this.html});

  ShortDescription.fromJson(Map<String, dynamic> json) {
    html = json['html'] ?? "";
  }
}

class MediaGallery {
  String? jpgUrl;

  MediaGallery({this.jpgUrl});

  MediaGallery.fromJson(Map<String, dynamic> json) {
    jpgUrl = json['jpg_url'] ?? "";
  }
}

class ProductDetails {
  List<ProductModel>? items;

  ProductDetails({this.items});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ProductModel>[];
      json['items'].forEach((v) {
        items!.add(ProductModel.fromJson(v));
      });
    }
  }
}

class OthersBoughtData {
  List<ProductModel>? boughtTogetherList;

  OthersBoughtData({this.boughtTogetherList});

  OthersBoughtData.fromJson(Map<String, dynamic> json) {
    if (json['bought_together'] != null) {
      boughtTogetherList = <ProductModel>[];
      json['bought_together'].forEach((v) {
        boughtTogetherList!.add(ProductModel.fromJson(v));
      });
    }
  }
}
class ConfigurableOptions {
  int? id;
  String? attributeCode;
  String? label;
  List<ConfigurableOptionValues>? values;

  ConfigurableOptions({this.id, this.attributeCode, this.label, this.values});

  ConfigurableOptions.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    attributeCode = json['attribute_code']??"";
    label = json['label']??"";
    if (json['values'] != null) {
      values = <ConfigurableOptionValues>[];
      json['values'].forEach((v) {
        values?.add(ConfigurableOptionValues.fromJson(v));
      });
    }else{
      values=[];
    }
  }


}

class ConfigurableOptionValues {
  String? defaultLabel;
  String? label;
  String? storeLabel;
  bool? useDefaultValue;
  int? valueIndex;

  ConfigurableOptionValues(
      {this.defaultLabel,
        this.label,
        this.storeLabel,
        this.useDefaultValue,
        this.valueIndex});

  ConfigurableOptionValues.fromJson(Map<String, dynamic> json) {
    defaultLabel = json['default_label']??"";
    label = json['label']??"";
    storeLabel = json['store_label']??"";
    useDefaultValue = json['use_default_value']??"";
    valueIndex = json['value_index']??"";
  }
}

class Variants {
  List<Attributes>? attributes;
  ProductModel? product;

  Variants({this.attributes, this.product});

  Variants.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes?.add(Attributes.fromJson(v));
      });
    }else{
      attributes=[];
    }
    product =
    json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

}

class Attributes {
  String? code;
  int? valueIndex;

  Attributes({this.code, this.valueIndex});

  Attributes.fromJson(Map<String, dynamic> json) {
    code = json['code']??"";
    valueIndex = json['value_index']??0;
  }
}
