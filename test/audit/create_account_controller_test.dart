import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
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

  group('register', () {
    /// A server that refuses the sign-up the way RegisterFormRequest does.
    CreateAccountController refusing(Map<String, dynamic> body) {
      Get.testMode = true;
      final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9'));
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: options, statusCode: 422, data: body),
        ));
      }));
      return CreateAccountController(
          AuthUsecase(AuthRepositoryImpl(AuthDataSourceImpl(dio: dio))));
    }

    Future<String?> run(CreateAccountController ctrl) async {
      await runZonedGuarded(() async {
        await ctrl.register();
        await Future<void>.delayed(Duration.zero);
      }, (e, st) {});
      return ctrl.lastErrorMessage;
    }

    test('a phone already used shows the server\'s message, not "Registration failed"', () async {
      const taken = 'رقم الجوال مسجل بحساب آخر، سجّل الدخول أو استخدم رقماً آخر';
      final ctrl = refusing({
        'message': taken,
        'errors': {
          'phone': [taken]
        },
      });

      expect(await run(ctrl), taken);
      expect(ctrl.isLoading, isFalse);
    });

    test('an email already used shows the server\'s message', () async {
      const taken = 'البريد الإلكتروني مسجل بحساب آخر، سجّل الدخول أو استخدم بريداً آخر';
      final ctrl = refusing({
        'message': taken,
        'errors': {
          'email': [taken]
        },
      });

      expect(await run(ctrl), taken);
    });
  });
}
