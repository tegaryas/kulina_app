import 'package:http/http.dart' as http;
import 'package:kulina_test/models/product_model.dart';

const BASE_URL = 'https://kulina-recruitment.herokuapp.com';

class ApiProvider {
  late List<ProductModel> product;
  Future<List<ProductModel>> fetchProductList(int page) async {
    var response = await http.get(Uri.parse('$BASE_URL/products?_page=$page'));
    if (response.statusCode == 200) {
      var result = productModelFromJson(response.body);

      product = result;
      return product;
    } else {
      throw Exception('Unable to get Products list');
    }
  }
}
