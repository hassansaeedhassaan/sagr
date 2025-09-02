import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/services/auth_service.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

final SagrAuthController authController = Get.find<SagrAuthController>();
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }


  Future<void> _checkAuthStatus() async {
    // await Future.delayed(const Duration(seconds: 3));
    
    // final authService = Get.find<AuthService>();
    
    // if (authService.isLoggedIn.value) {
    //   Get.offAllNamed(AppRoutes.HOME);
    // } else {
    //   Get.offAllNamed(AppRoutes.LOGIN);
    // }
  // }

      Future.delayed(const Duration(seconds: 2), () {
      if (authController.isLoggedIn.value) {
          Get.offAllNamed(AppRoutes.HOME);
      } else {
         Get.offAllNamed(AppRoutes.LOGIN);
      }
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chat,
                  size: 60,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Chat App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect with everyone',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';

// class SplashScreen extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     // Check auth status after 2 seconds
//     Future.delayed(const Duration(seconds: 2), () {
//       if (authController.isLoggedIn.value) {
//         Get.offAllNamed('/home');
//       } else {
//         Get.offAllNamed('/login');
//       }
//     });

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF007AFF),
//               Color(0xFF34C759),
//             ],
//           ),
//         ),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.chat_bubble_rounded,
//                 size: 80,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 24),
//               Text(
//                 'Chat App',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Connect with everyone',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }