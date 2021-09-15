class CartProductModel {
  String? name, image, price;
  int? quantity, productId;
  String? date;

  CartProductModel({
    this.name,
    this.image,
    this.price,
    this.quantity,
    this.productId,
    this.date,
  });

  CartProductModel.fromJson(Map<dynamic, dynamic> map) {
    // ignore: unnecessary_null_comparison
    if (map == null) {
      return;
    }
    name = map['name'];
    image = map['image'];
    quantity = map['quantity'];
    price = map['price'];
    productId = map['productId'];
    date = map['date'];
  }

  toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'productId': productId,
      'date': date,
    };
  }
}
