import 'package:flutter_test/flutter_test.dart';
import 'package:sagr/utilities/html_text.dart';

void main() {
  test('rich-text description becomes plain text', () {
    expect(
      htmlToPlainText(
          '<p>فعالية <strong>رياضية</strong>&nbsp;كبرى</p><p>المتطلبات:</p><ul><li>زي موحد</li><li>الالتزام &amp; الانضباط</li></ul>'),
      'فعالية رياضية كبرى\nالمتطلبات:\n\n• زي موحد\n• الالتزام & الانضباط',
    );
  });

  test('plain text is left alone', () {
    expect(htmlToPlainText('  نص عادي  '), 'نص عادي');
    expect(htmlToPlainText(null), '');
  });

  test('line breaks and numeric entities', () {
    expect(htmlToPlainText('سطر<br>سطر&#39;ثاني&#x21;'), "سطر\nسطر'ثاني!");
  });
}
