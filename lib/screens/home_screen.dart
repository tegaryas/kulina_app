import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kulina_test/models/cart_product_model.dart';
import 'package:kulina_test/models/product_model.dart';
import 'package:kulina_test/screens/cart_screen.dart';
import 'package:kulina_test/utils/color.dart';
import 'package:kulina_test/view_models/cart_view_model.dart';
import 'package:kulina_test/view_models/home_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatePickerController _controller = DatePickerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, index) {
                return [
                  SliverToBoxAdapter(
                    child: Header(),
                  ),
                  GetBuilder<CartViewModel>(
                    builder: (controller) => SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        child: PreferredSize(
                          preferredSize: Size.fromHeight(80.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            color: Colors.white,
                            child: DatePicker(
                              DateTime.now(),
                              daysCount: 56,
                              locale: 'id_ID',
                              width: 60,
                              height: 80,
                              controller: _controller,
                              initialSelectedDate: DateTime.now(),
                              selectionColor: Colors.orange,
                              selectedTextColor: Colors.white,
                              dateTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              deactivatedColor: Colors.grey.withOpacity(0.3),
                              inactiveDates: [
                                DateTime.now().add(
                                    Duration(days: DateTime.now().weekday)),
                                DateTime.now().add(
                                    Duration(days: DateTime.now().weekday + 1)),
                              ],
                              onDateChange: (date) {
                                // New date selected
                                controller.getDate(date);
                              },
                            ),
                          ),
                        ),
                      ),
                      pinned: true,
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<CartViewModel>(
                        builder: (controller) => Text(
                          DateFormat.yMMMMEEEEd('id')
                              .format(controller.dateProductAdd),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GetBuilder<HomeViewModel>(
                        builder: (controller) => controller.loading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: ColorPallete.orangeColor,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15.0,
                                  mainAxisSpacing: 15.0,
                                  childAspectRatio: 1 / 1.8,
                                ),
                                itemCount: controller.productModel.length,
                                itemBuilder: (context, index) {
                                  var data = controller.productModel[index];

                                  return _buildProductCard(data);
                                },
                              ),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            GetBuilder<CartViewModel>(
              builder: (controller) => Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => CartScreen());
                    controller.getAllProduct();
                  },
                  child: controller.cartProductModel.length != 0
                      ? _buildCartNavBar(controller)
                      : Container(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: data.imageUrl ?? 'assets/images/error.png',
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: ColorPallete.orangeColor,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          data.rating! < 1.0
              ? Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'BARU',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RatingBar.builder(
                        itemSize: 12.0,
                        initialRating: data.rating!,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rate,
                          color: Colors.orangeAccent,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          Text(
            data.name ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'by ${data.brandName ?? ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            data.packageName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey.withOpacity(0.5),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(
                  int.parse(
                    data.price.toString(),
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Termasuk Ongkir',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.5),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GetBuilder<CartViewModel>(
            builder: (controller) => GestureDetector(
              onTap: () {
                controller.addProduct(CartProductModel(
                  name: data.name,
                  image: data.imageUrl,
                  price: data.price.toString(),
                  quantity: 1,
                  productId: data.id,
                  date: controller.dateProductAdd.toString(),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartNavBar(CartViewModel cart) {
    return Container(
      height: 55,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${cart.cartProductModel.length} item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' | ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(
                      int.parse(
                        cart.totalPrice.toString(),
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Termasuk Ongkos Kirm',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Icon(
            Icons.shopping_cart,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_sharp,
            size: 20,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Alamat Pengiriman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: ColorPallete.orangeColor,
                  )
                ],
              ),
              Text(
                'Kulina',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
