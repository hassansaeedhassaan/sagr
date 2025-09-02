import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // إضافة هذا
import '../models/user.dart';

class AuthService extends GetxService {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'userData';

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString token = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    // final prefs = await SharedPreferences.getInstance();
    
    // Load token
    // final savedToken = prefs.getString(_tokenKey);
    // if (savedToken != null) {
    //   token.value = savedToken;
    // }

    // Load user data
    // final userData = prefs.getString(_userKey);
    // if (userData != null) {
    //   try {
    //     final userJson = jsonDecode(userData);
    //     currentUser.value = User.fromJson(userJson);
    //     isLoggedIn.value = true;
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('Error loading user data: $e');
    //     }
    //   }
    // }
  }

  Future<void> setCurrentUser(User user) async {
    currentUser.value = user;
    isLoggedIn.value = true;
    
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> setToken(String authToken) async {
    token.value = authToken;
    
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_tokenKey, authToken);
  }

  Future<void> logout() async {
    currentUser.value = null;
    token.value = '';
    isLoggedIn.value = false;
    
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove(_tokenKey);
    // await prefs.remove(_userKey);
  }

  bool get hasValidToken => token.value.isNotEmpty;
}