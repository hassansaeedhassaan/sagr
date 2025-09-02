import 'package:flutter/material.dart';

import '../../data/colors.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.0),
      appBar: AppBar(
        elevation: 0,
      
        leading: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: Icon(
            Icons.search,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Icon(
              Icons.menu,
              size: 30,
            ),
          )
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Container(
      //         width: double.infinity,
      //         // color: Colors.red,
      //         height: MediaQuery.of(context).size.height / 4,
      //         child: Image.asset(
      //           'assets/images/product2.png',
      //           // fit: BoxFit.contain,
      //         ),
      //       ),
      //       Container(
      //         padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      //         child: Text(
      //           "اسم المنتج قصير او طويل",
      //           style: TextStyle(color: BLACK_COLOR, fontSize: 16),
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Container(
      //         width: double.infinity,
      //         padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Row(
      //               // mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               children: [
      //                 Text(
      //                   "120.99",
      //                   style: TextStyle(
      //                       fontSize: 24.0, fontWeight: FontWeight.w600),
      //                 ),
      //                 Text(
      //                   "₪",
      //                   style: TextStyle(fontSize: 16, height: 1.9),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(
      //               height: 6,
      //             ),
      //             Text(
      //                 "وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل ",
      //                 style: TextStyle(fontSize: 12, color: BLACK_COLOR)),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             Row(
      //               children: [
      //                 Expanded(
      //                     flex: 1,
      //                     child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border.all(
      //                                 width: 1, color: Color(0xffdddddd)),
      //                             borderRadius: BorderRadius.circular(12)),
      //                         width: 15.0,
      //                         height: 15,
      //                         // color: Colors.amber,
      //                         child: SwitcherButton(
      //                             // onColor: Color(0xffffffff),
      //                             offColor: Color(0xfffebd69),
      //                             onColor: Colors.grey[400],
      //                             size: 80,
      //                             value: true,
      //                             onChange: (value) {
      //                               print(value);
      //                             }))),
      //                 Expanded(
      //                   flex: 7,
      //                   child: Text("الحفر علي المنتج"),
      //                 )
      //               ],
      //             ),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //             Text("a skdaslkj daslkdj askldj alksdj alskd"),
      //           ],
      //         ),
      //       ),
      //       Container(
      //         height: 50,
      //         width: double.maxFinite,
      //         decoration: BoxDecoration(
      //             color: Colors.deepOrange,
      //             borderRadius:
      //                 BorderRadius.vertical(top: Radius.circular(20.0))),
      //         child: Row(
      //           mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget>[
      //             IconButton(
      //               icon: Icon(Icons.arrow_forward),
      //               onPressed: () {},
      //             ),
      //             IconButton(
      //               icon: Icon(Icons.arrow_downward),
      //               onPressed: () {},
      //             ),
      //             IconButton(
      //               icon: Icon(Icons.arrow_left),
      //               onPressed: () {},
      //             ),
      //             IconButton(
      //               icon: Icon(Icons.arrow_upward),
      //               onPressed: () {},
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              // color: Colors.transparent,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      // color: Colors.red,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Image.asset(
                        'assets/images/product2.png',
                        // fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Text(
                        "اسم المنتج قصير او طويل",
                        style: TextStyle(color: BLACK_COLOR, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "120.99",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "₪",
                                  style: TextStyle(fontSize: 16, height: 1.9),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                                "وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل وصف للمنتج قصير او طويل ",
                                style: TextStyle(
                                    fontSize: 12, color: BLACK_COLOR)),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Color(0xffdddddd)),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      width: 15.0,
                                      height: 15,
                                      // color: Colors.amber,
                                      // child: SwitcherButton(
                                      //     // onColor: Color(0xffffffff),
                                      //     offColor: Color(0xfffebd69),
                                      //     // onColor: Colors.grey[400],
                                      //     size: 80,
                                      //     value: true,
                                      //     onChange: (value) {
                                      //       print(value);
                                      //     })
                                          )
                                          ),
                              Expanded(
                                flex: 7,
                                child: Text("الحفر علي المنتج"),
                              )
                            ])
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    //   height: 440,
                    //   // color: Colors.amber,
                    //   child: GridView.count(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     crossAxisCount: 2,
                    //     children: List.generate(4, (index) {
                    //       return Container(
                    //           margin: EdgeInsets.only(bottom: 10),
                    //           // height: 40,
                    //           child: ProductItem(
                    //             tag: '9090',
                    //           ));
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Container(
          //   width: 116.0,
          //   height: 174.0,
          //   color: Colors.transparent,
          //   foregroundDecoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         Colors.black.withOpacity(0.2),
          //         Colors.transparent,
          //         Colors.transparent,
          //         Colors.black
          //       ],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       stops: [0, 0.2, 0.8, 1],
          //     ),
          //   ),
          //   // child: Image.network('https://i.picsum.photos/id/200/400/600.jpg'),
          // ),
          // Container(
          //   height: 120,
          //   width: double.infinity,
          //   // color: Colors.red,
          //   // decoration: BoxDecoration(color: Colors.transparent),
          //   child: CustomPaint(
          //     // size: Size.zero,
          //     // foregroundPainter: FadingEffect(),
          //     //child gets the fading effect
          //     child: Column(
          //       children: [
          //         Expanded(
          //             child: Column(
          //           children: [
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //             Text('Test text', style: TextStyle(color: Colors.black)),
          //           ],
          //         ))
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            height: 160.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xffffffff),
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                      Colors.black.withOpacity(0.0),
                    ],
                    stops: [
                      0.0,
                      0.1,
                      0.2,
                      0.3,
                      0.4,
                      1.0
                    ])),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الكمية",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: BLACK_COLOR),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 12),
                                // width: 40.0,
                                // height: 20.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xffe0e0e0),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff7d7d7d),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              width: 18.0,
                              height: 18.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  // color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xffe0e0e0),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xff7d7d7d),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "278",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR,
                            ),
                          ),
                          Text(
                            "₪",
                            style: TextStyle(
                                color: BLACK_COLOR, fontSize: 14, height: 2.2),
                          ),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsetsDirectional.fromSTEB(30, 20, 30, 20),
                      padding: EdgeInsetsDirectional.fromSTEB(5, 12, 5, 12),
                      // width: double.maxFinite,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/shopping_cart.png',
                              width: 22.0,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Text(
                                "إضافه إلي السلة",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff7d3b7e),
                          borderRadius: BorderRadius.circular(22.0)),
                    ),
                  )
                ],
              ),
            ),
          ),

          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: FractionalOffset.topLeft,
          //         end: FractionalOffset.bottomRight,
          //         colors: [
          //           Color(0xff692eff).withOpacity(0.8),
          //           Color(0xff642cf4).withOpacity(0.8),
          //           Color(0xff602ae9).withOpacity(0.8),
          //           Color(0xff5224c8).withOpacity(0.8),
          //           Color(0xff5e29e5).withOpacity(0.8),
          //         ],
          //         stops: [
          //           0.0,
          //           0.25,
          //           0.5,
          //           0.75,
          //           1.0
          //         ]),
          //   ),
          // ),

          // Container(
          //   height: MediaQuery.of(context).size.height / 4,
          //   width: double.maxFinite,
          //   decoration: BoxDecoration(
          //       // color: Colors.deepOrange,
          //       borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
          //       gradient: LinearGradient(
          //           tileMode: TileMode.mirror,
          //           begin: Alignment(0.0, -1.0),
          //           end: Alignment(0.0, 0.2),

          //           // begin: const Alignment(0.0, -1.0),
          //           // end: const Alignment(0.0, 0.6),
          //           // begin: Alignment.topCenter,
          //           // end: Alignment.bottomCenter,
          //           colors: [
          //             Colors.transparent.withOpacity(0.2),
          //             Color.fromARGB(0, 255, 0, 0).withOpacity(0.1),
          //             Color.fromARGB(0, 0, 0, 255).withOpacity(0.1),
          //             Color.fromARGB(255, 0, 0, 255).withOpacity(0.1),
          //             // Colors.transparent,
          //           ])),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       IconButton(
          //         icon: Icon(Icons.arrow_forward),
          //         onPressed: () {},
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.arrow_downward),
          //         onPressed: () {},
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.arrow_left),
          //         onPressed: () {},
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.arrow_upward),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
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
