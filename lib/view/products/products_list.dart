import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/colors.dart';

class ProductsList extends StatelessWidget {

  final bool active = true;

  final List<String> allItemList = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Black',
    'Violet',
  ];

  final List _selecteCategorys = [];

  final Map<String, dynamic> _categories = {
    "responseCode": "1",
    "responseText": "List categories.",
    "responseBody": [
      {"category_id": "5", "category_name": "هاجيز"},
      {"category_id": "3", "category_name": "بامبرز"},
      {"category_id": "7", "category_name": "ماركة ثالثة"},
      {"category_id": "7", "category_name": "ماركة رابعة "}
    ],
    "responseTotalResult":
        4 // Total result is 3 here becasue we have 3 categories in responseBody.
  };

  ProductsList({Key? key}) : super(key: key);

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      // setState(() {
      //   _selecteCategorys.add(category_id);
      // });
    } else {
      // setState(() {
      //   _selecteCategorys.remove(category_id);
      // });
    }
  }

  static List<String> checkedItemList = ['Green', 'Yellow'];

  final List<String> selectedItemList = checkedItemList;
  @override
  Widget build(BuildContext context) {
    // final categoryID =
    //     (ModalRoute.of(context)?.settings.arguments as CategoryModel).id;
    return  Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 80.0, bottom: 20, right: 15.0),
          width: double.infinity,
          color: const Color(0xfff0f0f0),
          child: Column(
            children: [
              Expanded(
                  flex: 11,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding:
                               EdgeInsetsDirectional.fromSTEB(10, 0, 0, 5),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20
                        ),
                        const Padding(
                          padding:
                               EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),

                        const SizedBox(
                          height: 20
                        ),
                        const Padding(
                          padding:
                               EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            "الماركات",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categories['responseTotalResult'],
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30.0,
                                  child: LabeledCheckbox(
                                    activeColor: BLACK_COLOR,
                                    defaultColor: GREY_COLOR,
                                    gap: 4.0,
                                    bold: true,
                                    value: _selecteCategorys.contains(
                                        _categories['responseBody'][index]
                                            ['category_id']),
                                    onTap: (bool selected) {
                                      _onCategorySelected(
                                          selected,
                                          _categories['responseBody'][index]
                                              ['category_id']);
                                    },
                                    label: _categories['responseBody'][index]
                                        ['category_name'],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                        //   child: Text(
                        //     "الماركات",
                        //     style: TextStyle(color: Colors.black),
                        //   ),
                        // ),
                        // Container(
                        //   // height: 80.0,
                        //   // color: Colors.green,
                        //   child: MediaQuery.removePadding(
                        //     context: context,
                        //     removeTop: true,
                        //     child: ListView.builder(
                        //         shrinkWrap: true,
                        //         itemCount: _categories['responseTotalResult'],
                        //         itemBuilder: (BuildContext context, int index) {
                        //           return SizedBox(
                        //             height: 30.0,
                        //             child: ListTileTheme(
                        //               // contentPadding:
                        //               //     EdgeInsets.only(left: 0, right: 0),
                        //               child: CheckboxListTile(
                        //                 controlAffinity:
                        //                     ListTileControlAffinity.leading,
                        //                 contentPadding:
                        //                     EdgeInsetsDirectional.fromSTEB(
                        //                         15, 0, 0, 0),
                        //                 value: _selecteCategorys.contains(
                        //                     _categories['responseBody'][index]
                        //                         ['category_id']),
                        //                 onChanged: (bool selected) {
                        //                   _onCategorySelected(
                        //                       selected,
                        //                       _categories['responseBody'][index]
                        //                           ['category_id']);
                        //                 },
                        //                 title: Text(_categories['responseBody']
                        //                     [index]['category_name']),
                        //               ),
                        //             ),
                        //           );
                        //         }),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.fromSTEB(
                        //       15, 0, 0, 10),
                        //   child: Text(
                        //     "الماركات",
                        //     style: TextStyle(color: Colors.black),
                        //   ),
                        // ),
                        // GroupedCheckbox(
                        //   materialTapTargetSize:
                        //       MaterialTapTargetSize.shrinkWrap,
                        //   wrapSpacing: 0.0,
                        //   wrapRunSpacing: 0.0,
                        //   wrapTextDirection: TextDirection.ltr,
                        //   wrapRunAlignment: WrapAlignment.center,
                        //   wrapVerticalDirection: VerticalDirection.down,
                        //   wrapAlignment: WrapAlignment.center,
                        //   itemList: <String>[
                        //     "هاجيز",
                        //     "بامبرز",
                        //     "ماركة ثالثة",
                        //     "ماركة رابعه",
                        //   ],
                        //   checkedItemList: checkedItemList,
                        //   disabled: ['Black'],
                        //   onChanged: (itemList) {
                        //     // setState(() {
                        //     //   selectedItemList = itemList;
                        //     //   print('SELECTED ITEM LIST $itemList');
                        //     // });
                        //   },
                        //   orientation: CheckboxOrientation.VERTICAL,
                        //   checkColor: Colors.grey,
                        //   activeColor: Colors.white,
                        //   textStyle: TextStyle(color: Colors.black),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.fromSTEB(
                        //       15, 15, 0, 10),
                        //   child: Text(
                        //     "ترتيب",
                        //     style: TextStyle(color: Colors.black),
                        //   ),
                        // ),
                        // GroupedCheckbox(
                        //   materialTapTargetSize:
                        //       MaterialTapTargetSize.shrinkWrap,
                        //   wrapSpacing: 0.0,
                        //   wrapRunSpacing: 0.0,
                        //   wrapTextDirection: TextDirection.ltr,
                        //   wrapRunAlignment: WrapAlignment.center,
                        //   wrapVerticalDirection: VerticalDirection.down,
                        //   wrapAlignment: WrapAlignment.center,
                        //   itemList: <String>["حسب الارخص", "حسب الاغلي"],
                        //   checkedItemList: checkedItemList,
                        //   disabled: ['Black'],
                        //   onChanged: (itemList) {
                        //     // setState(() {
                        //     //   selectedItemList = itemList;
                        //     //   print('SELECTED ITEM LIST $itemList');
                        //     // });
                        //   },
                        //   orientation: CheckboxOrientation.VERTICAL,
                        //   checkColor: Colors.grey,
                        //   activeColor: Colors.white,
                        //   textStyle: TextStyle(color: Colors.black),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.fromSTEB(
                        //       15, 15, 0, 10),
                        //   child: Text(
                        //     "تشكيلة",
                        //     style: TextStyle(color: Colors.black),
                        //   ),
                        // ),
                        // GroupedCheckbox(
                        //   materialTapTargetSize:
                        //       MaterialTapTargetSize.shrinkWrap,
                        //   wrapSpacing: 0.0,
                        //   wrapRunSpacing: 0.0,
                        //   wrapTextDirection: TextDirection.ltr,
                        //   wrapRunAlignment: WrapAlignment.center,
                        //   wrapVerticalDirection: VerticalDirection.down,
                        //   wrapAlignment: WrapAlignment.center,
                        //   itemList: <String>["رجالي", "حريمي"],
                        //   checkedItemList: checkedItemList,
                        //   disabled: ['Black'],
                        //   onChanged: (itemList) {
                        //     // setState(() {
                        //     //   selectedItemList = itemList;
                        //     //   print('SELECTED ITEM LIST $itemList');
                        //     // });
                        //   },
                        //   orientation: CheckboxOrientation.VERTICAL,
                        //   checkColor: Colors.grey,
                        //   activeColor: Colors.white,
                        //   textStyle: TextStyle(color: Colors.black),
                        // ),
                      ],
                    ),
                  )),
              // Expanded(
              //     flex: 6,
              //     child: Directionality(
              //       textDirection: TextDirection.ltr,
              //       child: ListView(
              //         children: ListData.keys.map((String key) {
              //           return new CheckboxListTile(
              //             selected: false,
              //             title: new Text(key),
              //             value: ListData[key],
              //             activeColor: Colors.deepPurple[400],
              //             checkColor: Colors.white,
              //             onChanged: (bool value) {},
              //           );
              //         }).toList(),
              //       ),
              //     )),
            
            ],
          ),
        
      )
     ,
    );
  }
}

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          //create 2 white colors, one transparent
          Colors.white,
          Colors.white.withOpacity(0.6),
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect linePainter) => false;
}

class LabeledCheckbox extends StatelessWidget {


  final String? label;
  final EdgeInsets? contentPadding;
  final bool? value;
  final Function(bool val)? onTap;
  final Color? activeColor;
  final Color? defaultColor;
  final double? fontSize;
  final double? gap;
  final bool? bold;


   LabeledCheckbox({
    this.label,
    this.contentPadding,
    this.value,
    this.onTap,
    this.activeColor,
    this.defaultColor,
    this.fontSize,
    this.gap = 2.0,
    this.bold = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(!value!),
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              value: value,
              activeColor: activeColor,
              visualDensity: VisualDensity.compact,
              onChanged: (val) => onTap!(val!),
            ),
            SizedBox(
              width: gap,
            ), // you can control gap between checkbox and label with this field
            Flexible(
              child: Text(
                label!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: defaultColor,
                  fontWeight: bold! ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
