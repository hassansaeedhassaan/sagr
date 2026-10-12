import 'package:flutter_test/flutter_test.dart';
import 'package:sagr/helper/base_url.dart';

void main() {
  group('base URLs', () {
    test('production hosts are https and consistent', () {
      expect(BASEURL, 'https://sagr.net/api/v1');
      expect(APIHOST, 'https://sagr.net');
      expect(HOSTURL, 'https://sagr.net/');
      expect(BASEURL.startsWith(APIHOST), isTrue);
    });
  });

  group('userImageUrl', () {
    test('absolute URLs pass through', () {
      expect(userImageUrl('https://cdn.example.com/a.jpg'),
          'https://cdn.example.com/a.jpg');
    });

    test('app uploads (public/images, public/files) are served from the web root', () {
      // RegisterController/CompleteController/UpdateProfileController move
      // uploads to public_path('images'|'files') and store 'images/<name>'.
      expect(userImageUrl('images/1700000000_abcd1234.jpg'),
          'https://sagr.net/images/1700000000_abcd1234.jpg');
      expect(userImageUrl('files/1700000000_abcd1234.pdf'),
          'https://sagr.net/files/1700000000_abcd1234.pdf');
    });

    test('admin-panel photos live on the public disk under /storage', () {
      expect(userImageUrl('employees/photo.png'),
          'https://sagr.net/storage/employees/photo.png');
    });

    test('a leading slash is not normalised (documents current behaviour)', () {
      expect(userImageUrl('/images/a.jpg'), 'https://sagr.net/storage//images/a.jpg');
    });
  });
}
