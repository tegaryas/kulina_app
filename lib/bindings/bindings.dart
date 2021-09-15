import 'package:get/get.dart';
import 'package:kulina_test/view_models/cart_view_model.dart';
import 'package:kulina_test/view_models/home_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => CartViewModel());
  }
}
