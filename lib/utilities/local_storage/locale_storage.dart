import 'package:get_storage/get_storage.dart';
import 'package:sagr/data/constants.dart';
import 'package:sagr/models/customer_model.dart';

class LocaleStorage {
  final GetStorage _storage = GetStorage();

  // Language methods
  Future<void> saveLanguage(String language) async {
    await _storage.write('lang', language);
  }

  Future<String> get selectedLanguage async {
    return _storage.read('lang') ?? DEFAULT_LANG;
  }

  Future<String> get updatedLanguage async {
    return _storage.read('updatedLanguage') ?? '';
  }

  // Generic storage methods
  Future<void> setLocaleStorageKeyValue({required String key, required String value}) async {
    await _storage.write(key, value);
  }

  // No need for an async version that doesn't use await
  void setLocaleStorageKeyValueSync({required String key, required String value}) {
    _storage.write(key, value);
  }

  // App type
  Future<String> get appType async {
    return _storage.read('app_type') ?? "tools";
  }

  // User related methods
  Future<CustomerModel> get getLoggedInUser async {
    return _storage.read('userData') ?? CustomerModel();
  }

  Future<String?> get getProfile async {
    return _storage.read('userData');
  }

  Future<String> get getAccessToken async {
    return _storage.read('access_token') ?? "";
  }

  // Consistent method naming and behavior
  String get authenticatedUserName {
    return _storage.read('loggedInUserName') ?? "";
  }

  Future<String> get authenticatedUserPhone async {
    return _storage.read('loggedInUserPhone') ?? "";
  }

  // Save read locator
  Future<void> saveReadLocator(String key, dynamic locator) async {
    await _storage.write(key, locator);
  }
}