/// Plain text from the HTML the dashboard's rich-text editor saves (event
/// descriptions): block ends become line breaks, list items get a bullet,
/// tags are dropped and entities decoded.
String htmlToPlainText(String? html) {
  if (html == null) return '';
  var s = html;
  if (!s.contains('<') && !s.contains('&')) return s.trim();

  s = s
      .replaceAll(RegExp(r'<\s*(script|style)[^>]*>[\s\S]*?<\s*/\s*\1\s*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '\n• ')
      .replaceAll(
          RegExp(r'<\s*/\s*(p|div|h[1-6]|ul|ol|tr|blockquote)\s*>', caseSensitive: false),
          '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '');

  const named = {
    'nbsp': ' ',
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    'hellip': '…',
    'ndash': '–',
    'mdash': '—',
    'laquo': '«',
    'raquo': '»',
  };
  s = s.replaceAllMapped(RegExp(r'&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);'), (m) {
    final e = m.group(1)!;
    if (e.startsWith('#x') || e.startsWith('#X')) {
      final code = int.tryParse(e.substring(2), radix: 16);
      return code == null ? m.group(0)! : String.fromCharCode(code);
    }
    if (e.startsWith('#')) {
      final code = int.tryParse(e.substring(1));
      return code == null ? m.group(0)! : String.fromCharCode(code);
    }
    return named[e.toLowerCase()] ?? m.group(0)!;
  });

  return s
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t ]+'), ' ').trim())
      .join('\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}
