import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kulina_test/models/cart_product_model.dart';
import 'package:kulina_test/services/db_helper.dart';

class CartViewModel extends GetxController {
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<CartProductModel> _cartProductModel = [];
  List<CartProductModel> get cartProductModel => _cartProductModel;

  int get totalPrice => _totalPrice;
  int _totalPrice = 0;

  DateTime get dateProductAdd => _dateProductAdd;
  DateTime _dateProductAdd = DateTime.now();

  var dbHelper = CartDatabaseHelper.db;

  CartViewModel() {
    initializeDateFormatting();
    getAllProduct();
  }

  getDate(value) {
    _dateProductAdd = value;
    update();
  }

  getAllProduct() async {
    _loading.value = true;

    _cartProductModel.clear();
    _totalPrice = 0;

    _cartProductModel = await dbHelper.getAllProduct();

    _loading.value = false;
    getTotalPrice();
    update();
  }

  getTotalPrice() {
    for (int i = 0; i < _cartProductModel.length; i++) {
      _totalPrice += (int.parse(_cartProductModel[i].price!) *
          _cartProductModel[i].quantity!);
      update();
    }
  }

  addProduct(CartProductModel cartProductModel) async {
    for (int i = 0; i < _cartProductModel.length; i++) {
      if (_cartProductModel[i].productId == cartProductModel.productId) {
        return;
      }
    }
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.insert(cartProductModel);
    _cartProductModel.add(cartProductModel);
    _totalPrice +=
        (int.parse(cartProductModel.price!) * cartProductModel.quantity!);
    update();
  }

  increaseQuantity(int index) async {
    // ignore: unnecessary_statements
    _cartProductModel[index].quantity = _cartProductModel[index].quantity! + 1;
    _totalPrice += (int.parse(_cartProductModel[index].price!));
    await dbHelper.updateProduct(_cartProductModel[index]);

    update();
  }

  decreaseQuantity(int index) async {
    // ignore: unnecessary_statements
    _cartProductModel[index].quantity = _cartProductModel[index].quantity! - 1;
    _totalPrice -= (int.parse(_cartProductModel[index].price!));
    await dbHelper.updateProduct(_cartProductModel[index]);

    update();
  }

  deleteProduct(int index) async {
    await dbHelper.deleteProductWithId(_cartProductModel[index]);
    update();
    getAllProduct();
  }

  deleteAllProduct() async {
    await dbHelper.deleteAllPRoduct();
    update();
    getAllProduct();
  }
}
