import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/settings/setting_controller.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/helper/base_url.dart';

import '../../config/app_config.dart';
import '../models/slider.dart';

class HomeSliderWidget extends StatefulWidget {
  const HomeSliderWidget({Key? key}) : super(key: key);

  @override
  _HomeSliderWidgetState createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  int _current = 0;
  SliderList? _sliderList = new SliderList();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
     
      init: SettingController(),
      builder: (controller){
        
      return Stack(
      alignment: AlignmentDirectional.bottomEnd,
//      fit: StackFit.expand,
      children: <Widget>[
       controller.isLoading ? CircularProgressIndicator()  : CarouselSlider(
          // autoPlay: true,
          // autoPlayInterval: Duration(seconds: 5),
          // height: 240,
          // viewportFraction: 1.0,
          // onPageChanged: (index) {
          //   setState(() {
          //     _current = index;
          //   });
          // },
          items: controller.setting.sliders!.map((
              // prefix0.Slider
              slide) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  decoration: BoxDecoration(
                    
                    image: DecorationImage(image: NetworkImage(IMAGE_PATH+'/${slide['image']}'), fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(4),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Theme.of(context)
                    //           .primaryColorDark
                    //           .withOpacity(0.3),
                    //       offset: Offset(0, 4),
                    //       blurRadius: 9)
                    // ],
                  ),
                  child: Container(
                    // color: WHITE_COLOR,
                    alignment: AlignmentDirectional.centerStart,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: SizedBox(
                      width: App(context).appWidth(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              "",
                            style: TextStyle(
                              color: Color(0xff4e4e4e),
                              fontSize: 12,
                            ),
                
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayInterval: Duration(seconds: 10),
            height: 160,
            onPageChanged: ((index, reason) => setState(() {
                  _current = index;
                })),
            // onPageChanged: ((index, reason) => {print(index), print(reason)}),
            viewportFraction: 1,
          aspectRatio: 1.0,
          ),
        ),
        controller.isLoading ? SizedBox.shrink() : Positioned(
          bottom: -1,
          right:41,
//          width: config.App(context).appWidth(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: controller.setting.sliders!.map((
                // prefix0.Slider
                slide) {
              return Container(
                width: 20.0,
                height: 3.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: _current == controller.setting.sliders!.indexOf(slide)
                        ? AMBER_COLOR
                        : Theme.of(context).shadowColor.withOpacity(0.3)),
              );
            }).toList(),
          ),
        ),
      ],
    );
    });
  }
}
