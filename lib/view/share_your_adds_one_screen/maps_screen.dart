import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/categories/domain/entities/category.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'dart:async';

import 'package:sagr/view/share_your_adds_one_screen/widget_to_map_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/image_constant.dart';
import '../../features/chat/presentation/controllers/conversations_controller.dart';
import '../../features/products/presentation/widgets/product_item.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import '../widgets/Forms/easy_app_text_form_field.dart';

class MapsScreen extends StatefulWidget {
  static const routeName = '/maps-screen';

  final List<Product> products;

  MapsScreen(this.products);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Completer<GoogleMapController> _controller = Completer();

  // Completer<GoogleMapController> googleMapController = Completer();
  List<Marker> markerList = [];

  bool loading = false;

  double? latitude;

  double? longitude;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> appLaunchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  // Marker marker1 = Marker(
  //   markerId: MarkerId('Marker1'),
  //   position: LatLng(32.195476, 74.2023563),
  //   infoWindow: InfoWindow(title: 'Business 1'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  // );
  // Marker marker2 = Marker(
  //   markerId: MarkerId('Marker2'),
  //   position: LatLng(31.110484, 72.384598),
  //   infoWindow: InfoWindow(title: 'Business 2'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  // );
  // List<Marker> list = [];

  @override
  void initState() {
    // list = [marker1, marker2];
    // _markers.addAll(list);

    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      await generateMarkerList();
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  Future<BitmapDescriptor> getCustomIcon(String price) async {
    // return Scaffold(
    //   body: Padding(
    //                                   padding: EdgeInsets.only(left: 0.h),
    //                                   child: _buildSearch(
    //                                     context,
    //                                     price: "2000 EGP",
    //                                   ),
    //                                 ),
    // ).toBitmapDescriptor();
    return SizedBox(
      height: 39.v,
      width: 120.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.h,
                vertical: 6.v,
              ),
              decoration: AppDecoration.white.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: Text(
                price,
                style: CustomTextStyles.titleSmallPrimary.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),

          Container(
            height: 26.adaptSize,
            width: 30.adaptSize,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Icon(
                Icons.arrow_drop_down,
                color: WHITE_COLOR,
                size: 35,
              ),
            ),
          )
          // CustomImageView(
          //   onTap: () => {},
          //   imagePath: ImageConstant.imgArrowDownOnprimary,
          //   height: 16.adaptSize,
          //   width: 16.adaptSize,
          //   radius: BorderRadius.circular(
          //     1.h,
          //   ),

          // ),
        ],
      ),
    ).toBitmapDescriptor();
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  Future<void> generateMarkerList() async {
    // List<Marker> markerList = [];

    // widget.products.forEach((item) async => {

    //   markerList.add(Marker(
    //    markerId: MarkerId('Marker1'),
    //    position: LatLng(31.110484, 72.384598),
    //    infoWindow: InfoWindow(title: 'Business 1'),
    //    icon: await getCustomIcon("EGP 2000"),
    // ))
    // });

    for (int i = 0; i < widget.products.length; i++) {
      var obj = widget.products[i];

      Marker marker = Marker(
          markerId: MarkerId('${obj.id}'),
          position:
              LatLng(double.parse(obj.latitude!), double.parse(obj.longitude!)),
          icon: await getCustomIcon(
              "EGP ${obj.price} ${obj.min_price} ${obj.max_price}"),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.all(15),
                      content: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: 10,
                                top: -15,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: WHITE_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: SizedBox(
                                      width: 22,
                                      child: CustomImageView(
                                        imagePath: ImageConstant
                                            .imgVuesaxLinearUserRemove,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ProductItem(obj: obj),
                            ],
                          ),
                        ),
                      ),
                    ));
          });

      markerList.add(marker);

      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        setState(() {
          latitude = value.latitude;
          longitude = value.longitude;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(50.0))),
      //     onPressed: () {
      //       print('Test bottom nav bar');
      //     },
      //     child: Container(
      //       width: 60,
      //       height: 60,
      //       child: Icon(
      //         Icons.add,
      //         size: 30,
      //         color: WHITE_COLOR,
      //       ),
      //       decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           gradient: LinearGradient(
      //             //  begin: Alignment(-0.11, -0.23),
      //             end: Alignment(0.60, 0.2),
      //             colors: [
      //               Color(0xffD20653),
      //               Color(0xffFF951D),
      //             ],
      //           )),
      //     )),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Maps'),
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
      ),
      body: Column(
        children: [
//                 Column(

//                  children: mapIndexed(
//   widget.products,
//   (index, item) => Text("event_$item")
// ).toList()

//  ),

          Container(
            color: WHITE_COLOR,
            padding: EdgeInsets.only(top: 0),
            child: _buildSearchHorizontalScroll(context),
          ),

          Expanded(
            child: !loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: Set<Marker>.of(markerList),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },

                    //  onMapCreated: (GoogleMapController controller) {
                    //   googleMapController.complete(controller);
                    // },

                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude!, longitude!),
                      zoom: 6.0,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

/// Navigates to the popUpScreen when the action is triggered.
onTapImgCircleImage(BuildContext context) {
  // Navigator.pushNamed(context, AppRoutes.popUpScreen);
}

/// Section Widget
Widget _buildSearchHorizontalScroll(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.only(left: 16.h, right: 16),
    child: IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 6),
                  child: CustomIconButton(
                    height: 35.adaptSize,
                    width: 35.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.h,
                      vertical: 6.v,
                    ),
                    decoration: IconButtonStyleHelper.fillPrimary,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgSearch141,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 4),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.h,
                    vertical: 6.v,
                  ),
                  decoration: AppDecoration.outlineOrange.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Text(
                    "All",
                    style: CustomTextStyles.bodyMediumOrange400,
                  ),
                ),
                GetBuilder<CategoriesController>(
                    init: CategoriesController(Get.find()),
                    builder: (CategoriesController _catCntr) {
                      _catCntr.getChildLevelTwo(2);

                      return Row(
                        children: _catCntr.subCategoriesTwo
                            .map((item) => Container(
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 4),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.h,
                                    vertical: 6.v,
                                  ),
                                  decoration:
                                      AppDecoration.outlineGray.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder8,
                                  ),
                                  child: Text(
                                    item.name!,
                                    style: CustomTextStyles
                                        .bodyMediumBluegray90002,
                                  ),
                                ))
                            .toList(),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Common widget
Widget _buildSearch(
  BuildContext context, {
  required String price,
}) {
  return SizedBox(
    height: 39.v,
    width: 97.h,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 6.v,
            ),
            decoration: AppDecoration.white.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Text(
              price,
              style: CustomTextStyles.titleSmallPrimary.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgArrowDownOnprimary,
          height: 16.adaptSize,
          width: 16.adaptSize,
          radius: BorderRadius.circular(
            1.h,
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    ),
  );
}

class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;
  final double width;

  const GradientBoxBorder({
    required this.gradient,
    this.width = 1.0,
  });

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (shape == BoxShape.rectangle) {
      if (borderRadius != null) {
        _paintRRect(canvas, rect, borderRadius);
      } else {
        _paintRect(canvas, rect);
      }
    } else {
      _paintCircle(canvas, rect);
    }
  }

  void _paintRect(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    canvas.drawRRect(rrect, paint);
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(rect.center, rect.shortestSide / 2, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}

class ProductPriceWidget extends StatelessWidget {
  final Product? product;
  const ProductPriceWidget(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16.h, bottom: 22.v),
        child: Column(children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 1.h),
                  child: Text(" in ${product!.created_at}",
                      style: CustomTextStyles.bodySmall10))),
          Text(
            product!.price_type == "open_offer" ? "Open Offer".tr : "",
            style: TextStyle(color: Colors.green),
          ),
          product!.price_type == "open_offer"
              ? Row(
                  children: [
                    Text("${product!.min_price} ${product!.currency}",
                        style: theme.textTheme.titleMedium)
                  ],
                )
              : Text("${product!.price} ${product!.currency}",
                  style: theme.textTheme.titleMedium)
        ]));
  }
}
