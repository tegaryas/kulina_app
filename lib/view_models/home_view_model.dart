import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulina_test/models/product_model.dart';
import 'package:kulina_test/services/api_provider.dart';

class HomeViewModel extends GetxController {
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<ProductModel> get productModel => _productList;
  List<ProductModel> _productList = [];

  HomeViewModel() {
    getAllProduct();
  }

  void getAllProduct() async {
    _loading.value = true;
    var products = await ApiProvider().fetchProductList();
    // ignore: unnecessary_null_comparison
    if (products != null) {
      _productList = products;
    }
    _loading.value = false;
    update();
  }
}
