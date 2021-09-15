import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulina_test/models/product_model.dart';
import 'package:kulina_test/services/api_provider.dart';

class HomeViewModel extends GetxController {
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<ProductModel> get productModel => _productList;
  List<ProductModel> _productList = [];

  ScrollController get scrollController => _scrollController;
  ScrollController _scrollController = ScrollController();

  int _page = 1;

  HomeViewModel() {
    getAllProduct();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        await getAllProduct();
      }
    });
  }

  getAllProduct() async {
    _loading.value = true;
    var products = await ApiProvider().fetchProductList(_page);

    // ignore: unnecessary_null_comparison
    if (products != null) {
      _productList.addAll(products);
    }
    if (_page < 4) {
      ++_page;
    }

    _loading.value = false;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    getAllProduct();
  }
}
