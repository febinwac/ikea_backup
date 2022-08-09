import 'dart:convert';
import 'package:sfm_module/services/app_data.dart';

import '../common/constants.dart';
import '../services/graphQL_client.dart';

class ServiceConfig {
  Future<dynamic> getCountryInfo() async {
    String query = '''
  query{
  getCountryInfo {
    country_code
    currency_code
    currency_symbol
    phone
  }

}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> createEmptyCart() async {
    String query = '''
  mutation{
  createEmptyCart
  }

    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> checkTokenExpiredOrNot() async {
    String query = '''

  mutation{
  isTokenExpired
  }
    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getTokenId({String? email, String? tokenId}) async {
    String query = '''
    query{
    customer{
    refresh_token_id
    email
    }
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> refreshToken({String? email, String? tokenId}) async {
    String query = '''
  query{
    customerRefreshToken(email:"$email",refresh_token_id:"$tokenId")
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getHomeData() async {
    String query = '''
  query{
  Customcms(type: ${Constants.homeDataType}){
    content
    content_type
    meta_description
    meta_keywords
    meta_title
    title
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCartList(
    bool isGuest,
  ) async {
    String query = "";
    isGuest == true
        ? query = '''
query {
  cart(cart_id: "${AppData.cartId}") {
    items {
      __typename
      ... on ConfigurableCartItem {
        configurable_options {
          id
          option_label
          value_id
          value_label
        }
      }
      id
      quantity
      quote_thumbnail_url
      product {
        id
        sku
        name
        family_name
        small_image {
          mobile_app
        }
        upsell_products {
          id
          name
          sku
          ikea_family_price
          family_name
          price_range {
            maximum_price {
              final_price {
                value
              }
              regular_price {
                value
              }
              discount {
                amount_off
                percent_off
              }
            }
          }
          small_image {
            mobile_app
          }
          ... on BundleProduct {
            dynamic_sku
            dynamic_price
            items {
              option_id
              title
              sku
              options {
                id
              }
            }
          }
          __typename
        }
      }
      prices {
        row_total_including_tax {
          currency
          value
        }
      }
    }
    selected_slot {
      label
      value
      is_active
    }
    selected_billing_address
    selected_shipping_address
    shipping_addresses {
      selected_shipping_method {
        carrier_code
        carrier_title
        method_code
        method_title
        amount {
          currency
          value
        }
      }
    }
    applied_coupons {
      code
    }
    suggested_products {
      id
      name
      family_name
      sku
      stock_status
      image {
        mobile_app
      }
      small_image {
        mobile_app
      }
      ikea_family_price
      price_range {
        minimum_price {
          final_price {
            currency
            value
          }
          regular_price {
            value
          }
          discount {
            amount_off
            percent_off
          }
        }
      }
      ... on BundleProduct {
        dynamic_sku
        dynamic_price
        items {
          option_id
          title
          sku
          options {
            id
          }
        }
      }
    }
    total_quantity
    custom_prices_app {
      class_name
      currency
      id
      label
      text_label
      value
    }
    prices {
      total_tax_applied {
        amount {
          currency
          value
        }
        label
      }
      subtotal_excluding_tax {
        currency
        value
      }
      discounts {
        amount {
          currency
          value
        }
        label
      }
      applied_taxes {
        amount {
          currency
          value
        }
        label
      }
      total_discount_applied {
        amount {
          currency
          value
        }
        label
      }
      grand_total {
        currency
        value
      }
    }
  }
}
    '''
        : query = '''
   query{
 
  customerCart{
   selected_slot {
      label
      value
      is_active
    }
    selected_billing_address
    selected_shipping_address
    shipping_addresses {
      selected_shipping_method {
        carrier_code
        carrier_title
        method_code
        method_title
        amount {
          currency
          value
        }
      }
    }    
    applied_coupons {
      code
    }
    items {
      id
      quantity
      quote_thumbnail_url
            __typename

      product {
        id
        name
        sku
        family_name        
        small_image {
          mobile_app
        }
        upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
      }
      prices {
        row_total_including_tax {
          currency
          value
        }
      }      
    }
        suggested_products {
  __typename
     id
     tag
    new_to_date
    new_from_date
     name
     family_name
     sku
     stock_status
     image{
      mobile_app
    }
    small_image{
     mobile_app
   }
     ikea_family_price
     price_range {
       minimum_price {
         final_price {
           currency
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
  ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
}
    total_quantity
    custom_prices_app {
     class_name
     currency
     id
     label
     text_label
     value
   }
    prices {
            total_tax_applied {
          amount {
            currency
            value
          }
          label
        }
      subtotal_excluding_tax {
        currency
        value
      }
      discounts {
        amount {
          currency
          value
        }
        label
      }
      applied_taxes {
        amount {
          currency
          value
        }
        label
      }
         total_discount_applied {
        amount {
          currency
          value
        }
        label
      }
      grand_total {
        currency
        value
      }
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getOthersBroughtInCart(String cartId) async {
    String query = '''
   query{
    cart(cart_id:"$cartId"){
      bought_together {
      id
      name
      sku
    	family_name
   	 stock_status
      __typename
      tag
      thumbnail 
       {
        mobile_app
 				}
      small_image{
      mobile_app
      }
     upsell_products {
      id
      name
      sku
       ikea_family_price
       family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
          ... on BundleProduct {
      dynamic_sku
      dynamic_price
      items {
        option_id
        title
        sku
        options {
          id
        }
      }
    }
     ikea_family_price
     price_range {
       minimum_price {
         final_price {
           currency
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }  
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getAllCategories({String? limit}) async {
    String query = '''
   query{
     Allcategories(show_main_categories_only: true,platform: MOBILE_APP, ${limit != null ? 'limit = $limit' : ''}) {
     id
     name
     image
 }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getProductListing(String? catId,
      {String? sortValue, String? sortDirection}) async {
    String query = '''
{
 products(filter:{
   category_id:{eq:"$catId"}
 },sort: { price : ASC }) {
   aggregations(current_cat_id:10, filter:{
   category_id:{eq:"10"}
 }) 
  {
     attribute_code
     count
     label
     options {
       count
       label
       value
     }
   }
    items {
    __typename
     id
     tag
    new_to_date
    new_from_date
     name
     family_name
     sku
     stock_status
     image{
      mobile_app
    }
    small_image{
     mobile_app
   }
     ikea_family_price
     price_range {
       minimum_price {
         final_price {
           currency
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }    
     ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
    
        upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
 }
   sort_fields {
     default
     default_direction
     options {
       label
       value
       sort_direction
     }
   }
 
}
  categoryList(filters:{
   ids:{eq:"$catId"}
 }) {
   id
   name
   category_banner_mobile
 }
 Allcategories(show_main_categories_only:true,platform:MOBILE_APP) {
   id
   name
  image
 }
}
   ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> sendOtp({String? value, bool? isResend}) async {
    String query = '''
  mutation {
   sendLoginOtpV2(value: "+971$value", is_resend: $isResend) {
    otp_send
    is_ikea_family
   }
 }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> verifyOtp(
      {String? value,
      String? otp,
      String? dateOfBirth,
      int gender = 0,
      String? address,
      String? nationality,
      required List<String> communicationPreferred,
      String? livingSituation,
      bool? ikeaFamily}) async {
    String query = '''
   mutation {
     loginUsingOtp(
     value: "+971$value"
     otp: "$otp"
     platform: "mobile_app"
     date_of_birth:"$dateOfBirth"
     gender: $gender
     address_string:"$address"
     nationality:"$nationality"
     communication_preferrd: [${communicationPreferred.map((e) => '\"$e\"').join(", ")}]
     living_situation:"$livingSituation"
     is_ikea_family:$ikeaFamily                               
      ) {
     customer {
      firstname
     }
     token
   }
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> registrationUsingOtp(
      {String? value,
      String? otp,
      String? firstName,
      String? lastName,
      String? email,
      String dateOfBirth = '',
      int gender = 0,
      String address = '',
      String? nationality = '',
      required List<String> communicationPreferred,
      String? livingSituation = '',
      bool? ikeaFamily}) async {
    String query = '''
   mutation{
    registrationUsingOtp(value: "+971$value", 
    otp: "$otp", 
    firstname: "$firstName", 
    lastname: "$lastName", 
    email: "$email",
  
    date_of_birth:"$dateOfBirth"
    gender: $gender
    address_string:"$address"
    nationality:"$nationality"
    communication_preferrd: [${communicationPreferred.map((e) => '\"$e\"').join(", ")}]
    living_situation:"$livingSituation"
    is_ikea_family:$ikeaFamily

  platform: "mobile_app"){
    token
    customer{
      firstname
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> sendRegistrationOtp({String? value, bool? isResend}) async {
    String query = '''
 mutation{
  sendRegistrationOtp(value: "+971$value", is_resend: $isResend)
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getStoreCode(String? lat, String? long) async {
    String query = '''
query{
  getNearestStore(lat: "$lat", lng: "$long")
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

//   Future<dynamic> addSampleProductToCart(
//       String? cartId, Products product, double quantity) async {
//     int cartItemId = 0;
//     // if (product.isAddedToCart) {
//     //   cartItemId =int.parse( product.cartItemId);
//     // }
//     String query = '''
// mutation {
//   addSimpleProductsToCart(input:{
//     cart_id:"$cartId",
//     cart_items:{
//       data:{
//         quantity:$quantity
//         cart_item_id:$cartItemId
//         sku:"${product.sku}"
//       }
//     }
//   }) {
//     cart {
//       id
//        total_quantity
//       items {
//         id
//         product {
//           name
//           sku
//         }
//       }
//     }
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.mutation(query);
//   }
//
//   Future<dynamic> addBundleProductToCart(String? cartId, Products product,
//       double quantity, List<String> optionIds) async {
//     int cartItemId = 0;
//     // if (product.isAddedToCart) {
//     //   cartItemId =int.parse( product.cartItemId);
//     // }
//     String query = '''
// mutation {
//   addBundleProductsToCart(
// 	input: {
//   	cart_id: "$cartId"
//   	cart_items: [
//   	{
//     	data: {
//       	sku: "${product.sku}"
//       	cart_item_id:$cartItemId
//       	quantity: $quantity
//     	}
//     	bundle_options: [
//       	{
//         	id: ${product.bundleProduct![0].optionId}
//         	quantity:  $quantity
//         	value: ${jsonEncode(optionIds)}
//       	},
//
//
//     	]
//   	},
// 	]
//   }) {
// 	cart {
// 	 total_quantity
//
//   	items {
//     	id
//     	quantity
//     	product {
//       	sku
//     	}
//     	... on BundleCartItem {
//       	bundle_options {
//         	id
//         	label
//         	type
//         	values {
//           	id
//           	label
//           	price
//           	quantity
//         	}
//       	}
//     	}
//   	}
// 	}
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.mutation(query);
//   }
//
//   Future<dynamic> addCategoryProductToCart(
//       String? cartId, Items items, double quantity) async {
//     int cartItemId = 0;
//     // if (items.isAddedToCart) {
//     //   cartItemId =int.parse( items.cartItemId);
//     // }
//     String query = '''
// mutation {
//   addSimpleProductsToCart(input:{
//     cart_id:"$cartId",
//     cart_items:{
//       data:{
//         quantity:$quantity
//         cart_item_id:$cartItemId
//         sku:"${items.sku}"
//       }
//     }
//   }) {
//     cart {
//      total_quantity
//
//       id
//       items {
//         id
//         product {
//           name
//           sku
//         }
//       }
//     }
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.mutation(query);
//   }
//
//   Future<dynamic> addBundleCategoryProductToCart(String? cartId, Items items,
//       double quantity, List<String> optionIds) async {
//     int cartItemId = 0;
//     // if (items.isAddedToCart) {
//     //   cartItemId =int.parse( items.cartItemId);
//     // }
//     String query = '''
// mutation {
//   addBundleProductsToCart(
// 	input: {
//   	cart_id: "$cartId"
//   	cart_items: [
//   	{
//     	data: {
//       	sku: "${items.sku}"
//       	cart_item_id:$cartItemId
//       	quantity: $quantity
//     	}
//     	bundle_options: [
//       	{
//         	id: ${items.items![0].optionId}
//         	quantity:  $quantity
//         	value: ${jsonEncode(optionIds)}
//       	},
//
//
//     	]
//   	},
// 	]
//   }) {
// 	cart {
// 	 total_quantity
//
//   	items {
//     	id
//     	quantity
//     	product {
//       	sku
//     	}
//     	... on BundleCartItem {
//       	bundle_options {
//         	id
//         	label
//         	type
//         	values {
//           	id
//           	label
//           	price
//           	quantity
//         	}
//       	}
//     	}
//   	}
// 	}
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.mutation(query);
//   }

  Future<dynamic> getCustomerCartId() async {
    String query = '''
  query{
   customerCart {
   id
   email
 }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> mergeCarts(
      {String? sourceCartId, String? destinationCartId}) async {
    String query = '''
 mutation{
 mergeCarts(source_cart_id: "$sourceCartId", destination_cart_id: "$destinationCartId") {
  id
  product_not_available
}
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> revokeCustomerToken() async {
    String query = '''
 mutation {
 revokeCustomerToken {
   result
 }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> removeCartItem(String? cartId, String cartItemId) async {
    String query = '''
mutation {
  removeItemFromCart(input:{
    cart_id:"$cartId",
    cart_item_id:$cartItemId
  }) {
    cart {
    total_quantity
 items {
      id
      quantity
      product {
        id
        name
        family_name        
        small_image {
          mobile_app
        }
        upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
      }
      prices {
        row_total_including_tax {
          currency
          value
        }
      }      
    }
    prices {
      subtotal_excluding_tax {
        currency
        value
      }
      discounts {
        amount {
          currency
          value
        }
        label
      }
      total_tax_applied {
        amount {
          currency
          value
        }
        label
      }
      grand_total {
        currency
        value
      }
    }
    }
  }
}

    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> updateCartItem(
      String? cartId, String cartItemId, int quantity) async {
    String qnty = quantity.toString();
    String query = '''
mutation {
  updateCartItems(input:{
    cart_id:"$cartId",
    cart_items:{
      cart_item_id:$cartItemId,
      quantity:$qnty
    }
  }) {
    cart {
     total_quantity
 items {
      id
      quantity
      product {
        id
        name
        family_name        
        small_image {
          mobile_app
        }
        upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
      }
      prices {
        row_total_including_tax {
          currency
          value
        }
      }      
    }
      id
      prices {   
        grand_total {
          currency
          value
        }
        subtotal_excluding_tax {
          currency
          value
        }
        subtotal_including_tax {
          currency
          value
        }
        subtotal_with_discount_excluding_tax {
          currency
          value
        }
        total_discount_applied {
          amount {
            currency
            value
          }
          label
        }
        total_tax_applied {
          amount {
            currency
            value
          }
          label
        }
      } 
    }
  }
}

    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> applyCoupon(String couponCode) async {
    String query = '''
mutation {
  applyCouponToCart(
    input: {
      cart_id: "${AppData.cartId}"
      coupon_code: "$couponCode"
    }
  ) {
    cart {
      id
      custom_prices_app {
        class_name
        currency
        id
        label
        text_label
        value
      }
    }
  }
}

''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getRecentlyviewedProducts(String? cartId) async {
    String query = '''
query{
 getRecentlyviewedProducts(cartid:"$cartId") {
   name
   id
 thumbnail {
 mobile_app
 }
   small_image{
      mobile_app
    }
 
 }
}
   ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> removeCoupon() async {
    String query = '''
mutation {
  removeCouponFromCart(input: { cart_id: "${AppData.cartId}" }) {
    cart {
      id
      custom_prices_app {
        class_name
        currency
        id
        label
        text_label
        value
      }
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

//   Future<dynamic> addAddress(
//       String addressType,
//       String city,
//       String cCode,
//       String fName,
//       String lastName,
//       String? lat,
//       String? long,
//       AvailableRegions regions,
//       String street,
//       String mobile,
//       bool? isSaturday,
//       bool? isFriday,
//       bool? isDefaultAddress,
//       String flatNo,
//       String? countryCode) async {
//     String query = '''
// mutation{
//   createCustomerAddress(input:{
//     addresstype:"$addressType",
//     default_shipping:$isDefaultAddress,
//     city:"$city",
//     country_code:$cCode
//     firstname:"$fName"
//     lastname:"$lastName"
//     lat:"$lat"
//     lng:"$long"
//     region:{
//       region:"${regions.name}"
//       region_id:${regions.id}
//       region_code:"${regions.code}"
//     }
//     street:[
//       "$flatNo",
//       "$street"
//     ]
//     telephone:"$countryCode$mobile"
//     workdays:"{'open_on_saturday':$isSaturday,'open_on_friday':$isFriday}"
//   }){
//     addresstype
//     city
//     country_code
//     default_billing
//     default_shipping
//     fax
//     firstname
//     id
//     lastname
//     lat
//     lng
//     middlename
//     postcode
//     prefix
//     region {
//       region
//       region_code
//     }
//     street
//     suffix
//     telephone
//     vat_id
//     workdays
//   }
// }
//
//     ''';
//     return GraphQLClientConfiguration.instance.mutation(query);
//   }

  Future<dynamic> getAvailableRegions(String countryId) async {
    String query = '''
  query{
  country(id:"AE") {
    available_regions {
      code
      id
      name
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getAddressDetails() async {
    String query = '''
  query{

  customer {
    addresses {
    phone_country_code
      addresstype
      city
      country_code
      default_shipping
      extension_attributes {
        attribute_code
        value
      }
      workdays
      telephone
      street
      region {
        region
        region_code
      }      
      lng
      lat
      lastname
      id
      firstname      
    }    
    email
    firstname
    is_ikea_family_customer
    lastname
    mobile_number  
    date_of_birth  
    gender
    phone_country_code
  }

}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> deleteAddress(int? addressId) async {
    String query = '''
mutation {
  deleteCustomerAddress(id:$addressId)
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getProductDetails(String? sku) async {
    String query = '''
   query{
    products(filter:{
     sku:{eq:"$sku"}
     }) {  
     items {
      ... on ConfigurableProduct {
        configurable_options {
          id
          attribute_code
          label
          values {
            default_label
            label
            store_label

            use_default_value
            value_index
          }
        }
        variants {
          attributes {
            code
            value_index
          }

          product {
            id
            name
            sku
            family_name
            stock_status
            ikea_family_price
            short_description {
              html
            }
            price_range {
              minimum_price {
                final_price {
                  currency
                  value
                }
                regular_price {
                  value
                }
                discount {
                  amount_off
                  percent_off
                }
              }
            }
            media_gallery {
              jpg_url
            }
            __typename
          }
        }
      }
        upsell_products {
         small_image {
         mobile_app
        }
        id
        name
        sku
        ikea_family_price
        family_name
        price_range {
          maximum_price {
            final_price {
              value
            }
            regular_price {
              value
            }
            discount {
              amount_off
              percent_off
            }
          }
        }
      }
    id
    name
    sku
    family_name
    stock_status
    ikea_family_price
    short_description{
      html
    }
    price_range {
      minimum_price {
        final_price {
          currency
          value
        }
        regular_price {
          value
        }
        discount {
          amount_off
          percent_off
        }
      }
    }
    media_gallery {
      jpg_url
    }
    ... on BundleProduct {
      dynamic_sku
      dynamic_price
      items {
        option_id
        title
        sku
        options {
          id
        }
      }
    }
    related_products {
      id
     name
     tag
     new_to_date
     new_from_date
     family_name
     sku
     upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
     ikea_family_price
     small_image {
      mobile_app
     }
     price_range {
     minimum_price {
        final_price {
          currency
          value
        }
        regular_price {
          value
        }
        discount {
          amount_off
          percent_off
        }
      }
      maximum_price {
        final_price {
          value
        }
        regular_price {
          value
        }
        discount {
          amount_off
          percent_off
        }
      }
     }
      ... on BundleProduct {
      dynamic_sku
      dynamic_price
      items {
        option_id
        title
        sku
        options {
          id
        }
      }
    }
      __typename
  }
    __typename
}
}
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

//
//   Future<dynamic> addRelatedProductToCart(
//       String? cartId, RelatedProducts relatedProducts, double quantity) async {
//     String query = '''
// mutation {
//   addSimpleProductsToCart(input:{
//     cart_id:"$cartId",
//     cart_items:{
//       data:{
//         quantity:$quantity
//         sku:"${relatedProducts.sku}"
//       }
//     }
//   }) {
//     cart {
//       id
//       total_quantity
//       items {
//         id
//         product {
//           name
//           sku
//         }
//       }
//     }
//   }
// }
//     ''';
//
//     return GraphQLClientConfiguration.instance.query(query);
//   }

//   Future<dynamic> addRelatedBundleProductToCart(
//       String? cartId,
//       RelatedProducts relatedProducts,
//       double quantity,
//       List<String> optionIds) async {
//     String query = '''
// mutation {
//   addBundleProductsToCart(
// 	input: {
//   	cart_id: "$cartId"
//   	cart_items: [
//   	{
//     	data: {
//       	sku: "${relatedProducts.sku}"
//       	quantity: $quantity
//     	}
//     	bundle_options: [
//       	{
//         	id: ${relatedProducts.bundleProduct![0].optionId}
//         	quantity:  $quantity
//         	value: ${jsonEncode(optionIds)}
//       	},
//     	]
//   	},
// 	]
//   }) {
// 	cart {
// 	total_quantity
//   	items {
//     	id
//     	quantity
//     	product {
//       	sku
//     	}
//     	... on BundleCartItem {
//       	bundle_options {
//         	id
//         	label
//         	type
//         	values {
//           	id
//           	label
//           	price
//           	quantity
//         	}
//       	}
//     	}
//   	}
// 	}
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.query(query);
//   }

  Future<dynamic> updateCartWithCityStore(
    String? cartId,
    String addressId,
  ) async {
    String query = '''
mutation {
  updateCartWithCityStore(cart_id:"$cartId",customer_address_id:$addressId) {
    store_code
  }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setShippingAddressesOnCart(
    String? cartId,
    String addressId,
  ) async {
    String query = '''
mutation{
  setShippingAddressesOnCart(input:{cart_id:"$cartId", shipping_addresses: {
    customer_address_id:$addressId
  }}){
    cart {
      id
      delivery {
        status
        message
      }
      shipping_addresses {
        available_shipping_methods {
          amount {
            currency
            value
          }
          available
          carrier_code
          carrier_title
          method_code
          method_title          
        }
      }
      slots{
	date_label
	slot_data{
		label
		value
		is_active
	}
}
    }
  }
}

    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setTimeSlotOnCart(
    String? cartId,
    String timeSlot,
  ) async {
    String query = '''
mutation {
  setTimeSlotOnCart(cart_id:"$cartId",timeslot:"$timeSlot")
}

    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setBillingAddressOnCart(
    String? cartId,
    String addressId,
  ) async {
    String query = '''
mutation{
  setBillingAddressOnCart(input:{cart_id:"$cartId", billing_address: {
    customer_address_id:$addressId
  }}){
    cart {
      id
    available_payment_methods {
        additional_info
        code
        title
      }
    }
  }
}

    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> updateCartStore(String cartId) async {
    String query = '''
mutation {
  updateCartStore(cart_id:"$cartId")
}

    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> switchCartStore(String? cartId) async {
    String query = '''
mutation{
  switchCartStore(cart_id: "$cartId"){
    cart {
      id
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setShippingMethodsOnCart(
    String? cartId,
    String? carrierCode,
    String? methodCode,
  ) async {
    String query = '''
mutation {
  setShippingMethodsOnCart(input:{
    cart_id:"$cartId",
    shipping_methods:{
      carrier_code:"$carrierCode"
      method_code:"$methodCode"
    }
  }) {
    cart {
      id
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> deleteCustomerAddress(String addressId) async {
    String query = '''
mutation {
  deleteCustomerAddress(id:$addressId)
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

//   Future<dynamic> updateCustomerAddress(
//       String addressId,
//       String addressType,
//       String city,
//       String cCode,
//       String fName,
//       String lastName,
//       String? lat,
//       String? long,
//       AvailableRegions regions,
//       String street,
//       String mobile,
//       bool? isSaturday,
//       bool? isFriday,
//       bool? isDefaultAddress,
//       String flatNo,
//       String? countryCode) async {
//     String query = '''
// mutation {
//   updateCustomerAddress(id:$addressId, input:{
//     addresstype:"$addressType",
// city:"$city",
// country_code:$cCode
// firstname:"$fName"
// lastname:"$lastName"
// default_billing:$isDefaultAddress
// default_shipping:$isDefaultAddress
// lat:"$lat"
// lng:"$long"
// region:{
// region:"${regions.name.toString()}"
// region_id:${regions.id}
// region_code:"${regions.code.toString()}"
// }
// street:[
// "$flatNo",
// "$street"
// ]
// telephone:"$countryCode$mobile"
// workdays:"{'open_on_saturday':$isSaturday,'open_on_friday':$isFriday}"
//   }) {
//     id
//     firstname
//     lastname
//     addresstype
//     telephone
//     street
//     city
//     region {
//       region
//       region_code
//     }
//   }
// }
//
//     ''';
//
//     return GraphQLClientConfiguration.instance.query(query);
//   }

  Future<dynamic> customerOrders() async {
    String query = '''
query{
customerOrders {
items {
current_status {
date
}
id
order_number
products {
name
small_image {
mobile_app
}
}
status
store_type
grand_total
}
}
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setPaymentMethodOnCart(
      String? cartId, String? payMethodCode) async {
    String query = '''
mutation {
  setPaymentMethodOnCart(input:{
    cart_id:"$cartId",
    payment_method: {
      code:"$payMethodCode"
    }
  }) {
    cart {
      id
      selected_payment_method {
        code
        method_title
        title
      }
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> placeOrder(String? cartId) async {
    String query = '''

mutation {
  placeOrder(input:{
    cart_id:"$cartId"
  }) {
    order {
      order_number
      order_date
      order_total {
        currency
        value
      }
      payment_method
      shipping_address {
        addresstype
        firstname
        lastname
        region {
          label
        }
        street
        telephone
      }
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCartItemsCount(String cartId) async {
    String query = '''

query {
  getCartItemsCount(cart_id:"$cartId")
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> orderDetails(int? orderId) async {
    String query = '''

query{
  customerOrder(order_id: $orderId) {
    current_status {
      date
    }
    currency_code
    order_number
    store_type
    grand_total
    status
    products {
      name
      small_image {
        mobile_app
      }
      order_details {
        final_price
      }
    }
    shipping_addresses {
      addresstype
      firstname
      lastname
      region {
        label
      }
      street
      telephone
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> updateCustomer(
      String? dob,
      String? email,
      String? firstName,
      String? lastName,
      int? gender,
      String? password,
      String? mobileNumber,
      String? countryCode) async {
    String query = '''
mutation {
  updateCustomer(input:{
    date_of_birth:"$dob",
    email:"$email",
    firstname:"$firstName",
    lastname:"$lastName",
    gender: $gender,
    password:"$password"   
    mobile_number:"$countryCode$mobileNumber" 
  }) {
    customer {
      date_of_birth
      email
      firstname
      lastname
      gender
      mobile_number
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> addToCartAddOnSimple(
      String addOnItemsEncoded, String? cartId) async {
    String query = '''
mutation {
  addSimpleProductsToCart(input:{
    cart_id:"$cartId"
    cart_items:${jsonDecode(addOnItemsEncoded)}
  }) {
    cart {
      id
       total_quantity
      items {
        id
        product {
          name
          sku
        }
      }
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> addToCartAddOnBundle(
      String addOnItemsEncoded, String? cartId) async {
    String query = '''
mutation {
  addBundleProductsToCart(input:{
    cart_id:"$cartId"
    cart_items:${jsonDecode(addOnItemsEncoded)}
  }) {
    cart {
      id
       total_quantity
      items {
        id
        product {
          name
          sku
        }
      }
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getAddOnList(String sku) async {
    String query = '''

query{
  products(filter:{
    sku:{eq:"$sku"}
  }) {
    items {
      id
      sku
      upsell_products {
                id
      name
      sku
          ikea_family_price
          family_name
      price_range {
       maximum_price {
         final_price {
           value
         }
         regular_price {
           value
         }
         discount {
           amount_off
           percent_off
         }
       }
     }
          small_image {
          mobile_app
        }
          ... on BundleProduct {
       dynamic_sku
       dynamic_price
       items {
         option_id
         title
         sku
         options {
           id
         }
       }
     }
          __typename
        }
    }
  }
}
    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getOrderSuccessData(String? orderId) async {
    String query = '''
query{
customerOrderV2 ( order_number:"$orderId"){
  order_number
  currency_code
  prices{
    grand_total{
      value
    }
  }
  current_status{
     status
    date
    value
  }
  order_payment_method{
    code
    method_title
    purchase_order_number
  }
  shipping_addresses {
    street
    addresstype
    telephone
    addresstype
    firstname
    lastname
    region{
      label
    }
  }
}
  }
    ''';

    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getNationality() async {
    String query = '''
  query{
     NationalityListings {
       label
       value
       }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getLivingLocation() async {
    String query = '''
   query{
    LivingSituations {
      label
      value
     } 
   }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getDeleteAccountOtp(
      {required String phone, required bool isResend}) async {
    String query = '''
mutation{
  deleteAccountOtp(value: "$phone" is_resend:$isResend)
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> verifyDeleteAccountOtp(
      {required String phone, required String otp}) async {
    String query = '''
mutation{
  verifyDeleteAccountOtp(value: "$phone" otp: "$otp")
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }
}
