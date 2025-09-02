import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';

import '../../config/app_config.dart';
import '../models/slider.dart';

class ProductSliderWidget extends StatefulWidget {
  const ProductSliderWidget({Key? key}) : super(key: key);

  @override
  _ProductSliderWidgetState createState() => _ProductSliderWidgetState();
}

class _ProductSliderWidgetState extends State<ProductSliderWidget> {
  int _current = 0;
  SliderList? _sliderList = new SliderList();
  @override
  Widget build(BuildContext context) {
    return Stack(
 
      alignment: AlignmentDirectional.bottomEnd,
//      fit: StackFit.expand,
      children: <Widget>[

        CarouselSlider(
          // autoPlay: true,
          // autoPlayInterval: Duration(seconds: 5),
          // height: 240,
          // viewportFraction: 1.0,
          // onPageChanged: (index) {
          //   setState(() {
          //     _current = index;
          //   });
          // },
          items: _sliderList!.list!.map((
              // prefix0.Slider
              slide) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(slide.image!), scale: 2.8),
                    // borderRadius: BorderRadius.circular(6),
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
                    alignment: AlignmentDirectional.centerStart,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 200),
                    child: SizedBox(
                      width:
                          // config.
                          App(context).appWidth(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "",
                            style: TextStyle(
                              color: Color(0xff4e4e4e),
                              fontSize: 12,
                            ),
                            // Theme.of(context)
                            //     .textTheme
                            //     .headline6!
                            //     .merge(TextStyle(height: 0.8)),
                            // textAlign: TextAlign.right,
                            // overflow: TextOverflow.fade,
                            // maxLines: 3,
                          ),
//                           TextButton(
//                             style: ButtonStyle(
//                               padding: MaterialStateProperty.all<EdgeInsets>(
//                                   EdgeInsets.fromLTRB(5, 5, 5, 5)),
//                               backgroundColor: MaterialStateProperty.all(
//                                 Color(0xffff0072),
//                               ),
//                             ),
//                             onPressed: () {
// //                              Navigator.of(context).pushNamed('/Checkout');
//                             },
//                             // padding: EdgeInsets.symmetric(vertical: 5),
//                             // color: Theme.of(context).accentcolor,
//                             // shape: StadiumBorder(),
//                             child: Text(
//                               slide.button!,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 color: Color(0xffffffff),
//                               ),
//                             ),
//                           ),
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
            autoPlayInterval: Duration(seconds: 5),
            height: 230,
             onPageChanged: ((index, reason) => setState(() {
                  _current = index;
                })),
            
            // onPageChanged: ((index, reason) => {print(index), print(reason)}),
            viewportFraction: 1,
          ),
        ),
        Positioned.fill(
          bottom: -10,
          // left: 41,
//          width: config.App(context).appWidth(100),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sliderList!.list!.map((
                  // prefix0.Slider
                  slide) {



               return _current == _sliderList!.list!.indexOf(slide) ? Container(
                  width: 14.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: AMBER_COLOR),
                ) : Container(
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Theme.of(context).shadowColor.withOpacity(0.3)),
                );
                    
                // return Container(
                //   width: 14.0,
                //   height: 6.0,
                //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: _current == _sliderList!.list!.indexOf(slide)
                //           ? AMBER_COLOR
                //           : Theme.of(context).shadowColor.withOpacity(0.3)),
                // );
              }).toList(),
            ),
          ),
        ),
  
      ],
    );
  }
}
