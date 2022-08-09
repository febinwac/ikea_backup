class CustomerCartData {
  CustomerCart? customerCart;
  String? errorMessage;

  CustomerCartData({this.customerCart, this.errorMessage});

  CustomerCartData.fromJson(Map<String, dynamic> json) {
    customerCart = json['customerCart'] != null
        ? CustomerCart.fromJson(json['customerCart'])
        : null;
  }
}

class CustomerCart {
  String? id;
  String? email;

  CustomerCart({this.id, this.email});

  CustomerCart.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    email = json['email']??"";
  }
}
