import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failure_mapper.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/auth/data/datasource/auth_data_source.dart';
import 'package:sagr/features/auth/domain/repositories/auth_repository.dart';
import 'package:sagr/features/auth/domain/usecases/auth.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/models/customer_model.dart';

/// Records what the controller hands the usecase and answers with [result].
class _FakeAuthRepository implements AuthRepository {
  Map<String, dynamic>? lastBody;
  Either<Failure, CustomerModel> result =
      Right(CustomerModel(id: 7, firstName: 'Hassan'));

  @override
  Future<Either<Failure, CustomerModel>> updateProfile(
      Map<String, dynamic> body) async {
    lastBody = body;
    return result;
  }

  @override
  Future<Either<Failure, CustomerModel>> completeAccount(
          Map<String, dynamic> body) =>
      updateProfile(body);

  @override
  Future<Either<Failure, CustomerModel>> createAccount(
          Map<String, dynamic> body) =>
      updateProfile(body);
}

/// The profile JSON the API returns (ProfileIndexResource), as stored in
/// GetStorage 'userData' after login.
Map<String, dynamic> _savedProfile({Map<String, dynamic>? education}) => {
      'id': 7,
      'firstName': 'Hassan',
      'middleName': 'Ahmed',
      'lastName': 'Ibraheem',
      'birthdate': '1995-04-09',
      'job': {'id': 2, 'name': 'حراسة خاصة'},
      'maritalStatus': {'id': 2, 'name': 'متزوج'},
      'education': education ?? {'id': 1, 'name': 'بكالوريوس'},
      'region': {'id': 1, 'name': 'الرياض'},
      'languages': [
        {'id': 1, 'name': 'العربية'},
        {'id': 2, 'name': 'الفرنسية'},
      ],
    };

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

  tearDown(Get.reset);

  late _FakeAuthRepository repo;

  /// A controller loaded with [profile] the way the update screen gets it.
  CreateAccountController build(Map<String, dynamic> profile) {
    Get.testMode = true;
    repo = _FakeAuthRepository();
    final ctrl = CreateAccountController(AuthUsecase(repo));
    ctrl.authController.authenticatedUser = profile;
    ctrl.onReady();
    ctrl
      ..firstName = 'Hassan'
      ..middleName = 'Ahmed'
      ..lastName = 'Ibraheem'
      ..nationalNo = '1098765432'
      ..bankAccountName = 'Hassan Ahmed';
    return ctrl;
  }

  /// Runs [body], ignoring only the snackbar GetX cannot show without an
  /// overlay; any other error fails the test.
  Future<void> guarded(Future<void> Function() body) async {
    final errors = <Object>[];
    await runZonedGuarded(() async {
      await body();
      await Future<void>.delayed(Duration.zero);
    }, (e, st) {
      if (!'$st'.contains('snackbar')) errors.add(e);
    });
    expect(errors, isEmpty);
  }

  group('multipart body', () {
    test('languages go out as langs[] so PHP reads an array', () {
      final form = buildProfileFormData({
        'firstName': 'Hassan',
        'job_id': 2,
        'langs': [1, 2, 5],
      });

      final langs = form.fields.where((f) => f.key.startsWith('langs'));
      expect(langs.map((f) => f.key), everyElement('langs[]'));
      expect(langs.map((f) => f.value), ['1', '2', '5']);
      expect(form.fields.any((f) => f.key == 'langs'), isFalse);
      expect(
          form.fields.firstWhere((f) => f.key == 'firstName').value, 'Hassan');
      expect(form.fields.firstWhere((f) => f.key == 'job_id').value, '2');
    });

    test('files stay files', () {
      final form = buildProfileFormData({
        'image': MultipartFile.fromString('x', filename: 'me.jpg'),
        'langs': [1],
      });
      expect(form.files.single.key, 'image');
      expect(form.fields.single.key, 'langs[]');
    });
  });

  group('updateProfile body', () {
    test('sends the saved job, marital status, education, languages and birth date',
        () async {
      final ctrl = build(_savedProfile());

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      final body = repo.lastBody!;
      expect(body['job_id'], 2);
      expect(body['marital_status_id'], 2);
      expect(body['education_id'], 1);
      expect(body['langs'], [1, 2]);
      expect(body['birthdate'], '1995-04-09');
      expect(body['firstName'], 'Hassan');
      expect(body['nationalID'], '1098765432');
      expect(ctrl.isLoading, isFalse);
    });

    test('empty fields and unpicked files are left out', () async {
      final ctrl = build(_savedProfile());
      ctrl
        ..ibanNumber = ''
        ..experts = '';

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      final body = repo.lastBody!;
      for (final key in ['iban', 'image', 'emp_cv', 'iban_file']) {
        expect(body.containsKey(key), isFalse, reason: key);
      }
      // Optional notes go out empty so a user can clear them.
      expect(body['experts'], '');
    });

    test('a picked file and a typed IBAN are sent', () async {
      final ctrl = build(_savedProfile());
      ctrl.ibanNumber = 'SA0380000000608010167519';
      await ctrl.takenPhoto(XFile('/tmp/me.jpg'));

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      expect(repo.lastBody!['iban'], 'SA0380000000608010167519');
      expect(repo.lastBody!['image'], '/tmp/me.jpg');
    });

    test('an education the API returns empty is not sent as education_id',
        () async {
      final ctrl =
          build(_savedProfile(education: {'id': null, 'name': null}));

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      expect(repo.lastBody!.containsKey('education_id'), isFalse);
      expect(repo.lastBody!['job_id'], 2);
    });
  });

  group('updateProfile errors', () {
    test("a 422 shows the server's first error and re-enables the button",
        () async {
      final ctrl = build(_savedProfile());
      repo.result = Left(failureFromException(ValidationException(
        {
          'message': 'The education id field is required.',
          'errors': {
            'education_id': ['The education id field is required.'],
          },
        },
        message: 'API validation failed',
        statusCode: 422,
      )));

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      expect(ctrl.lastErrorMessage, 'The education id field is required.');
      expect(ctrl.isLoading, isFalse);
    });

    test('a dropped connection is not reported as a validation error', () {
      final failure =
          failureFromException(ValidationException(null, statusCode: null));
      expect(failure, isA<NetworkFailure>());
      expect(
          failureFromException(ValidationException('<html>', statusCode: 500)),
          isA<ServerFailure>());
    });

    test('a server error shows the generic message and re-enables the button',
        () async {
      final ctrl = build(_savedProfile());
      repo.result = const Left(ServerFailure());

      await guarded(() => ctrl.updateProfile(showSuccessMessage: false));

      expect(ctrl.lastErrorMessage, "Couldn't save your profile");
      expect(ctrl.isLoading, isFalse);
    });
  });
}
