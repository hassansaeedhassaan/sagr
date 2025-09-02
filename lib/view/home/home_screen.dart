
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  
   const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
      
        // appBar: CustomAppBar(),
        body: Navigator(
            key: Get.nestedKey(1), // create a key by index
            initialRoute: '/main',
            onGenerateRoute: (settings) {
              // var route = routes.firstWhere(
              //     (element) =>
              //         settings.name != "/" && element.name == settings.name,
              //     );
              // return GetPageRoute(
              //     // settings: route.settings,
              //     page: route.page,
              //     bindings: route.bindings,
              //     transition: Transition.fade,
              //     binding: route.binding);
              // // var routes = Navigator.of(context).widget.
              // return GetPageRoute(
              //   settings: settings,
              //   page: () => TabBarView(
              //     children: [
              //       const HomeScreen(),
              //       ProfileScreen(ProfileController()),
              //       CartScreen(CartController(Get.find())),
              //       MainScreen(MainController(Get.find())),
              //       MainScreen(MainController(Get.find())),
              //     ],
              //   ),
              // );
            }),
        bottomNavigationBar: CustomBottomNavigationBar(),
        // drawer: Drawer(
        //   child: Column(
        //     children: [
        //       GestureDetector(
        //         onTap: () {
        //           AuthService.logout();
        //         },
        //         child: Container(
        //           child: Text("Logout"),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
