import 'package:flutter/cupertino.dart';

class Slider {
  String? image;
  String? button;
  String? description;
  TextStyle? textStyle;
  Slider({this.image, this.button, this.description});
}

class SliderList {
  
  List<Slider>? _list;

  List<Slider>? get list => _list;

  SliderList() {
    _list = [
      new Slider(
          image: 'assets/images/banners/banner1.jpeg',
          button: '',
          description: ''),
      new Slider(
          image: 'assets/images/banners/banner2.jpeg',
          button: '',
          description: ''),
    ];
  }
}
