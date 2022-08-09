import 'dart:convert';

import 'package:sfm_module/common/helpers.dart';

class Cart {
  List<CartItems>? items;
  List<AppliedCoupons>? appliedCoupons;
  CartPrices? prices;
  int? selectedBillingAddress;
  int? selectedShippingAddress;
  List<ShippingAddresses>? shippingAddresses;
  List<CustomPricesApp>? customPricesApp;
  Slots? selectedSlot;
  int? totalQuantity;

  Cart(
      {this.items,
      this.prices,
      this.selectedSlot,
      this.shippingAddresses,
      this.selectedShippingAddress,
      this.selectedBillingAddress,
      this.appliedCoupons,
      this.customPricesApp,
      this.totalQuantity});

  Cart.fromJson(Map<String, dynamic> json) {
    totalQuantity = json['total_quantity'];

    selectedSlot = json['selected_slot'] != null
        ? Slots.fromJson(json['selected_slot'])
        : null;
    selectedBillingAddress = json['selected_billing_address'];
    selectedShippingAddress = json['selected_shipping_address'];

    if (json['shipping_addresses'] != null) {
      shippingAddresses = <ShippingAddresses>[];
      json['shipping_addresses'].forEach((v) {
        shippingAddresses?.add(ShippingAddresses.fromJson(v));
      });
    } else {
      shippingAddresses = [];
    }
    if (json['items'] != null) {
      items = <CartItems>[];
      json['items'].forEach((v) {
        items?.add(CartItems.fromJson(v));
      });
    } else {
      items = [];
    }
    if (json['applied_coupons'] != null) {
      appliedCoupons = <AppliedCoupons>[];
      json['applied_coupons'].forEach((v) {
        appliedCoupons?.add(AppliedCoupons.fromJson(v));
      });
    } else {
      appliedCoupons = [];
    }
    prices =
        json['prices'] != null ? CartPrices.fromJson(json['prices']) : null;
    if (json['custom_prices_app'] != null) {
      customPricesApp = <CustomPricesApp>[];
      json['custom_prices_app'].forEach((v) {
        customPricesApp?.add(CustomPricesApp.fromJson(v));
      });
    } else {
      customPricesApp = [];
    }
  }
}

class CartItems {
  String? id;
  int? quantity;
  CartProduct? product;
  CartPrices? prices;
  String? totalQuantity;

  CartItems(
      {this.id, this.quantity, this.product, this.prices, this.totalQuantity});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQuantity = json['total_quantity'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? CartProduct.fromJson(json['product']) : null;
    prices =
        json['prices'] != null ? CartPrices.fromJson(json['prices']) : null;
  }
}

class CartProduct {
  int? id;
  String? name;
  String? sku;
  String? familyName;
  SmallImage? smallImage;
  List<UpsellProductsForCart>? upsellProducts;

  CartProduct({
    this.id,
    this.name,
    this.smallImage,
    this.upsellProducts,
  });

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    familyName = json['family_name'];
    upsellProducts = <UpsellProductsForCart>[];
    if (json.containsKey('upsell_products')) {
      if (json['upsell_products'] != null) {
        json['upsell_products'].forEach((v) {
          upsellProducts?.add(UpsellProductsForCart.fromJson(v));
        });
      } else {
        upsellProducts = [];
      }
    } else {
      upsellProducts = [];
    }

    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
  }
}

class AppliedCoupons {
  String? code;

  AppliedCoupons({this.code});

  AppliedCoupons.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }
}

class CartPrices {
  RowTotalIncludingTax? subtotalExcludingTax;
  RowTotalIncludingTax? rowTotalIncludingTax;
  RowTotalIncludingTax? grandTotal;
  AppliedTaxes? appliedTaxes;
  AppliedTaxes? totalDiscountApplied;

  CartPrices(
      {this.subtotalExcludingTax,
      this.appliedTaxes,
      this.rowTotalIncludingTax,
      this.grandTotal});

  CartPrices.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('total_discount_applied')) {
      totalDiscountApplied = json['total_discount_applied'] != null
          ? AppliedTaxes.fromJson(json['total_discount_applied'])
          : null;
    } else {
      totalDiscountApplied = null;
    }

    if (json.containsKey('row_total_including_tax')) {
      rowTotalIncludingTax = json['row_total_including_tax'] != null
          ? RowTotalIncludingTax.fromJson(json['row_total_including_tax'])
          : null;
    } else {
      rowTotalIncludingTax = null;
    }
    if (json.containsKey('subtotal_excluding_tax')) {
      subtotalExcludingTax = json['subtotal_excluding_tax'] != null
          ? RowTotalIncludingTax.fromJson(json['subtotal_excluding_tax'])
          : null;
    } else {
      subtotalExcludingTax = null;
    }
    if (json.containsKey('total_tax_applied')) {
      appliedTaxes = json['total_tax_applied'] != null
          ? AppliedTaxes.fromJson(json['total_tax_applied'])
          : null;
    } else {
      appliedTaxes = null;
    }
    if (json.containsKey('grand_total')) {
      grandTotal = json['grand_total'] != null
          ? RowTotalIncludingTax.fromJson(json['grand_total'])
          : null;
    } else {
      grandTotal = null;
    }
  }
}

class AppliedTaxes {
  RowTotalIncludingTax? amount;
  String? label;

  AppliedTaxes({this.amount, this.label});

  AppliedTaxes.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null
        ? RowTotalIncludingTax.fromJson(json['amount'])
        : null;
    label = json['label'] ?? "";
  }
}

class ShippingAddresses {
  AvailableShippingMethods? selectedShippingMethod;

  ShippingAddresses({this.selectedShippingMethod});

  ShippingAddresses.fromJson(Map<String, dynamic> json) {
    selectedShippingMethod = json['selected_shipping_method'] != null
        ? AvailableShippingMethods.fromJson(json['selected_shipping_method'])
        : null;
  }
}

class CustomPricesApp {
  String? className;
  String? currency;
  String? id;
  String? label;
  String? textLabel;
  double? value;

  CustomPricesApp(
      {this.className,
      this.currency,
      this.id,
      this.label,
      this.textLabel,
      this.value});

  CustomPricesApp.fromJson(Map<String, dynamic> json) {
    className = json['class_name'] ?? "";
    currency = json['currency'] ?? "";
    id = json['id'] ?? "";
    label = json['label'] ?? "";
    textLabel = json['text_label'] ?? "";
    value = Helpers.convertValueToDouble(json['value']);
  }
}

class Slots {
  String? dateLabel;
  List<SlotData>? slotData;

  Slots({this.dateLabel, this.slotData});

  Slots.fromJson(Map<String, dynamic> json) {
    dateLabel = json['date_label'];
    if (json['slot_data'] != null) {
      slotData = <SlotData>[];
      json['slot_data'].forEach((v) {
        slotData?.add(SlotData.fromJson(v));
      });
    } else {
      slotData = [];
    }
  }
}

class SlotData {
  bool? isActive;
  String? label;
  String? value;

  SlotData({this.isActive, this.label, this.value});

  SlotData.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    label = json['label'] ?? "";
    value = json['value'] ?? "";
  }
}

class AvailableShippingMethods {
  Amount? amount;
  bool? available;
  String? carrierCode;
  String? carrierTitle;
  String? methodCode;
  String? methodTitle;

  AvailableShippingMethods(
      {this.amount,
      this.available,
      this.carrierCode,
      this.carrierTitle,
      this.methodCode,
      this.methodTitle});

  AvailableShippingMethods.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    available = json['available'];
    carrierCode = json['carrier_code'];
    carrierTitle = json['carrier_title'];
    methodCode = json['method_code'];
    methodTitle = json['method_title'];
  }
}

class Amount {
  String? currency;
  int? value;

  Amount({this.currency, this.value});

  Amount.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}

class SmallImage {
  String? mobileApp;

  SmallImage({this.mobileApp});

  SmallImage.fromJson(Map<String, dynamic> json) {
    mobileApp = json['mobile_app'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_app'] = mobileApp;
    return data;
  }
}

class UpsellProductsForCart {
  dynamic id;
  String? name;
  String? sku;
  dynamic ikeaFamilyPrice;
  String? familyName;
  PriceRange? priceRange;
  SmallImage? smallImage;
  String? type;
  String? image;
  bool? isAddedToCart = false;
  bool? isChecked = false;
  String? cartItemId = "0";
  int quantity = 1;
  List<BundleProductForCart>? bundleProduct;

  UpsellProductsForCart(
      {this.id,
      this.name,
      this.sku,
      this.ikeaFamilyPrice,
      this.familyName,
      this.priceRange,
      this.smallImage,
      this.image,
      this.type});

  UpsellProductsForCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    if (json.containsKey("image")) {
      image = json['image'];
    }
    ikeaFamilyPrice = json['ikea_family_price'];
    familyName = json['family_name'] ?? "";
    priceRange = json['price_range'] != null
        ? PriceRange.fromJson(json['price_range'])
        : null;
    if (json.containsKey("small_image")) {
      smallImage = json['small_image'] != null
          ? SmallImage.fromJson(json['small_image'])
          : null;
    }

    type = json['__typename'];

    if (json['items'] != null) {
      bundleProduct = <BundleProductForCart>[];
      json['items'].forEach((v) {
        bundleProduct?.add(BundleProductForCart.fromJson(v));
      });
    }
  }

  static Map<String, dynamic> toMapAddOnSimple(UpsellProductsForCart addOns) =>
      {
        'data': {
          'quantity': addOns.quantity,
          'sku': '"${addOns.sku.toString()}"',
        },
      };

  static Map<String, dynamic> toMapAddOnBundle(UpsellProductsForCart addOns) =>
      {
        'bundle_options': {
          'id': addOns.bundleProduct?[0].optionId,
          'quantity': addOns.quantity,
          'value': jsonEncode(Helpers.getBundleOptionIds(
              addOns.bundleProduct?[0].options ?? [])),
        },
        'data': {
          'quantity': addOns.quantity,
          'sku': '"${addOns.sku.toString()}"',
        },
      };

  static String encodeAddOnListSimple(List<UpsellProductsForCart> addOns) =>
      jsonEncode(
        addOns
            .map<Map<String, dynamic>>((addOnList) =>
                UpsellProductsForCart.toMapAddOnSimple(addOnList))
            .toList(),
      );

  static String encodeAddOnListBundle(List<UpsellProductsForCart> addOns) =>
      jsonEncode(
        addOns
            .map<Map<String, dynamic>>((addOnList) =>
                UpsellProductsForCart.toMapAddOnBundle(addOnList))
            .toList(),
      );
}

class PriceRange {
  MaximumPrice? maximumPrice;
  MaximumPrice? minimumPrice;

  PriceRange({this.maximumPrice, this.minimumPrice});

  PriceRange.fromJson(Map<String, dynamic> json) {
    maximumPrice = json['maximum_price'] != null
        ? MaximumPrice.fromJson(json['maximum_price'])
        : null;
    minimumPrice = json['minimum_price'] != null
        ? MaximumPrice.fromJson(json['minimum_price'])
        : null;
  }
}

class MaximumPrice {
  FinalPrice? finalPrice;
  FinalPrice? regularPrice;
  Discount? discount;

  MaximumPrice({this.finalPrice, this.regularPrice, this.discount});

  MaximumPrice.fromJson(Map<String, dynamic> json) {
    finalPrice = json['final_price'] != null
        ? FinalPrice.fromJson(json['final_price'])
        : null;
    regularPrice = json['regular_price'] != null
        ? FinalPrice.fromJson(json['regular_price'])
        : null;
    if (json.containsKey("discount")) {
      discount =
          json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    } else {
      discount = Discount(amountOff: 0, percentOff: 0);
    }
  }
}

class FinalPrice {
  double? value;

  FinalPrice({this.value});

  FinalPrice.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('value')) {
      if (json['value'] != null) {
        value = Helpers.convertValueToDouble(json['value'] ?? "");
      }
    } else {
      value = 0.0;
    }
  }
}

class TirePrice {
  double? ikeaFamilyPrice;

  TirePrice({this.ikeaFamilyPrice});

  TirePrice.fromJson(Map<String, dynamic> json) {
    if (json['ikea_family_price'] != null) {
      ikeaFamilyPrice =
          Helpers.convertValueToDouble(json['ikea_family_price'] ?? "");
    }
  }
}

class RowTotalIncludingTax {
  String? currency;
  double? value;

  RowTotalIncludingTax({this.currency, this.value});

  RowTotalIncludingTax.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertValueToDouble(json['value']);
  }
}

class BundleProductForCart {
  var optionId;
  var parentId;
  var required;
  var position;
  var type;
  var defaultTitle;
  var title;
  var sku;
  List<Options>? options;

  BundleProductForCart(
      {this.optionId,
      this.parentId,
      this.required,
      this.position,
      this.type,
      this.defaultTitle,
      this.title,
      this.sku,
      this.options});

  BundleProductForCart.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'] ?? "";
    parentId = json['parent_id'] ?? "";
    required = json['required'] ?? "";
    position = json['position'] ?? "";
    type = json['type'] ?? "";
    defaultTitle = json['default_title'] ?? "";
    title = json['title'] ?? "";
    sku = json['sku'] ?? "";
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options?.add(Options.fromJson(v));
      });
    } else {
      options = [];
    }
  }
}

class Options {
  var entityId;
  var attributeSetId;
  var typeId;
  var sku;
  var hasOptions;
  var requiredOptions;
  var createdAt;
  var updatedAt;
  var selectionId;
  var optionId;
  var parentProductId;
  var productId;
  var position;
  bool? isDefault;
  var selectionPriceType;
  var selectionPriceValue;
  var selectionQty;
  var selectionCanChangeQty;
  var storeId;
  var price;
  var id;
  var qty;
  var quantity;
  var priceType;
  var canChangeQuantity;

  Options(
      {this.entityId,
      this.attributeSetId,
      this.typeId,
      this.sku,
      this.hasOptions,
      this.requiredOptions,
      this.createdAt,
      this.updatedAt,
      this.selectionId,
      this.optionId,
      this.parentProductId,
      this.productId,
      this.position,
      this.isDefault,
      this.selectionPriceType,
      this.selectionPriceValue,
      this.selectionQty,
      this.selectionCanChangeQty,
      this.storeId,
      this.price,
      this.id,
      this.qty,
      this.quantity,
      this.priceType,
      this.canChangeQuantity});

  Options.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    attributeSetId = json['attribute_set_id'];
    typeId = json['type_id'];
    sku = json['sku'];
    hasOptions = json['has_options'];
    requiredOptions = json['required_options'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selectionId = json['selection_id'];
    optionId = json['option_id'];
    parentProductId = json['parent_product_id'];
    productId = json['product_id'];
    position = json['position'];
    isDefault = json['is_default'];
    selectionPriceType = json['selection_price_type'];
    selectionPriceValue = json['selection_price_value'];
    selectionQty = json['selection_qty'];
    selectionCanChangeQty = json['selection_can_change_qty'];

    if (json['store_id'] != null) {
      storeId = json['store_id'] ?? 0;
    } else {
      storeId = 0;
    }
    price = json['price'] ?? '';
    id = json['id'] ?? '';
    qty = json['qty'] ?? '';
    quantity = json['quantity'] ?? '';
    priceType = json['price_type'] ?? '';
    canChangeQuantity = json['can_change_quantity'] ?? '';
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
    desktop = json['desktop'] ?? '';
    desktop2x = json['desktop_2x'] ?? '';
    laptop = json['laptop'] ?? '';
    laptop2x = json['laptop_2x'] ?? '';
    mobile = json['mobile'] ?? '';
    mobile2x = json['mobile_2x'] ?? '';
    ipad = json['ipad'] ?? '';
    ipad2x = json['ipad_2x'] ?? '';
    placeholder = json['placeholder'] ?? '';
  }
}

class Discount {
  int? amountOff;
  int? percentOff;

  Discount({this.amountOff, this.percentOff});

  Discount.fromJson(Map<String, dynamic> json) {
    amountOff = Helpers.convertToInt(json['amount_off']);
    percentOff = Helpers.convertToInt(json['percent_off']);
  }
}

class CartInfoModel {
  String? content;
  String? title;
  String? icon;

  CartInfoModel({this.content, this.title, this.icon});

  CartInfoModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    title = json['title'];
    icon = json['icon'];
  }
}

class ApplyOrRemoveCouponToCart {
  Cart? cart;

  ApplyOrRemoveCouponToCart({this.cart});

  ApplyOrRemoveCouponToCart.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
  }
}

