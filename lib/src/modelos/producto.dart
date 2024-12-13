// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String id;
  int quantity;
  String nameProduct;
  double priceProduct;
  double commissionProduct;
  String cityProduct;
  String addressProduct;
  String phoneProduct;
  String descriptionProduct;
  String areaProduct;
  String nameOwner;
  String lastnameOwner;
  String emailOwner;
  String phoneOwner;
  String ciOwner;
  String idContract;
  String imageProduct1;
  String imageProduct2;
  String imageProduct3;
  String imageProduct4;
  String imageProduct5;
  String imageProduct6;
  String idCategory;
  String createdAt;
  String updatedAt;
  String category;
  List<Product> toList = [];

  Product(
      {this.id,
      this.quantity,
      this.nameProduct,
      this.priceProduct,
      this.commissionProduct,
      this.cityProduct,
      this.addressProduct,
      this.phoneProduct,
      this.descriptionProduct,
      this.areaProduct,
      this.nameOwner,
      this.lastnameOwner,
      this.emailOwner,
      this.phoneOwner,
      this.ciOwner,
      this.idContract,
      this.imageProduct1,
      this.imageProduct2,
      this.imageProduct3,
      this.imageProduct4,
      this.imageProduct5,
      this.imageProduct6,
      this.idCategory,
      this.createdAt,
      this.updatedAt,
      this.category});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        quantity: json["quantity"],
        nameProduct: json["name_product"],
        priceProduct: json["price_product"] == null
            ? 0.0 // Valor por defecto si es null
            : json["price_product"] is String
                ? double.tryParse(json["price_product"]) ?? 0.0
                : json["price_product"].toDouble(),
        commissionProduct: json["commission_product"] == null
            ? 0.0
            : json["commission_product"] is String
                ? double.tryParse(json["commission_product"]) ?? 0.0
                : json["commission_product"].toDouble(),
        cityProduct: json["city_product"],
        addressProduct: json["address_product"],
        phoneProduct: json["phone_product"],
        descriptionProduct: json["description_product"],
        areaProduct: json["area_product"],
        nameOwner: json["name_owner"],
        lastnameOwner: json["lastname_owner"],
        emailOwner: json["email_owner"],
        phoneOwner: json["phone_owner"],
        ciOwner: json["ci_owner"],
        idContract: json["id_contract"],
        imageProduct1: json["image1"],
        imageProduct2: json["image2"],
        imageProduct3: json["image3"],
        imageProduct4: json["image4"],
        imageProduct5: json["image5"],
        imageProduct6: json["image6"],
        idCategory: json["id_category"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        category: json["category"],
      );

  Product.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Product product = Product.fromJson(item);
      toList.add(product);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "name_product": nameProduct,
        "price_product": priceProduct,
        "commission_product": commissionProduct,
        "city_product": cityProduct,
        "address_product": addressProduct,
        "phone_product": phoneProduct,
        "description_product": descriptionProduct,
        "area_product": areaProduct,
        "name_owner": nameOwner,
        "lastname_owner": lastnameOwner,
        "email_owner": emailOwner,
        "phone_owner": phoneOwner,
        "ci_owner": ciOwner,
        "id_contract": idContract,
        "image1": imageProduct1,
        "image2": imageProduct2,
        "image3": imageProduct3,
        "image4": imageProduct4,
        "image5": imageProduct5,
        "image6": imageProduct6,
        "id_category": idCategory,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category": category,
      };

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();
}
