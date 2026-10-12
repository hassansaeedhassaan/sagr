import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/features/auth/data/datasource/auth_data_source.dart';
import 'package:sagr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sagr/features/auth/domain/usecases/auth.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tmp;

  setUpAll(() async {
    tmp = await Directory.systemTemp.createTemp('sagr_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => tmp.path,
    );
    await GetStorage.init();
  });

  tearDownAll(() async {
    await tmp.delete(recursive: true);
  });

  CreateAccountController build() {
    Get.testMode = true;
    // No network: any request would fail, and none should be sent here.
    final usecase = AuthUsecase(
        AuthRepositoryImpl(AuthDataSourceImpl(dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9')))));
    return CreateAccountController(usecase);
  }

  tearDown(Get.reset);

  group('completeAccount without a birth date', () {
    test('stops before the request and re-enables the submit button',
        () async {
      final ctrl = build();
      await ctrl.takenPhoto(XFile('/tmp/does-not-matter.jpg'));
      // Without an app overlay GetX's error snackbar throws on its own queue;
      // ignore that one and keep anything else (the old selectedYear! crash).
      final errors = <Object>[];
      await runZonedGuarded(() async {
        await ctrl.completeAccount();
        await Future<void>.delayed(Duration.zero);
      }, (e, st) {
        if (!'$st'.contains('snackbar_controller.dart')) errors.add(e);
      });
      expect(errors, isEmpty);
      // The submit button is disabled while isLoading is true.
      expect(ctrl.isLoading, isFalse);
    });
  });
}
