
import 'package:flutter/material.dart';
class BookReader extends StatelessWidget {
  const BookReader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Column(
        children: [
          
        ],
      )
//  EpubViewer.setConfig(
//                               themeColor: Theme.of(context).primaryColor,
//                               identifier: "iosBook",
//                               scrollDirection:
//                                   EpubScrollDirection.ALLDIRECTIONS,
//                               allowSharing: true,
//                               enableTts: true,
//                               nightMode: true);

//                           // get current locator
//                           EpubViewer.locatorStream.listen((locator) {
//                             print(
//                                 'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
//                           });


//                           Text(fileInfo.file.path);

//                           EpubViewer.open(
//                           fileInfo.file.path,
//                             // lastLocation: EpubLocator.fromJson({
//                             //   "bookId":Random().nextInt(100).toString(),
//                             //   "href": "/OEBPS/ch06.xhtml",
//                             //   "created": 1539934158390,
//                             //   "locations": {
//                             //     "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//                             //   }
//                             // }),
//                           );,
    );
  }
}