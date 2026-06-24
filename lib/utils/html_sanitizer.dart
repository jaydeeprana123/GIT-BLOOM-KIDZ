/// Sanitizes HTML from CMS / MS Word for [flutter_html] + [flutter_html_table].
String sanitizeHtmlForDisplay(String html) {
  if (html.isEmpty) return html;

  // MS Office tags (e.g. <o:p></o:p>)
  html = html.replaceAll(
    RegExp(r'<o:p[^>]*>.*?</o:p>', caseSensitive: false, dotAll: true),
    '',
  );
  html = html.replaceAll(RegExp(r'<o:p[^>]*/>', caseSensitive: false), '');

  // MSO-specific CSS properties
  html = html.replaceAllMapped(
    RegExp(r'mso-[^:]+:[^;"}]*;?', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'font-feature-settings:[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'font-variant-[^:]*:[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  // Height / overflow rules that clip rows
  html = html.replaceAllMapped(
    RegExp(r'\b(max-)?height\s*:\s*[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\boverflow(-[xy])?\s*:\s*[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\bwhite-space\s*:\s*nowrap[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  // Word tables often hide borders with border-style:none
  html = html.replaceAllMapped(
    RegExp(r'border-style\s*:\s*none', caseSensitive: false),
    (_) => 'border-style:solid',
  );

  html = html.replaceAllMapped(
    RegExp(r'border-width\s*:\s*medium', caseSensitive: false),
    (_) => 'border-width:1px',
  );

  // Fixed widths break layout on mobile (px, pt, cm, in, %, etc.)
  html = html.replaceAllMapped(
    RegExp(r'\b(?:max-)?width\s*:\s*[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAll(
    RegExp(r'\s+(?:width|height)="[^"]*"', caseSensitive: false),
    '',
  );

  // Word list/paragraph indents push content off-screen
  html = html.replaceAllMapped(
    RegExp(
      r'\b(?:margin|padding)-(?:left|right|top|bottom)\s*:\s*[^;}"]*;?',
      caseSensitive: false,
    ),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\btext-indent\s*:\s*[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\b(?:left|right|top|bottom)\s*:\s*[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\bposition\s*:\s*[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  // Legacy rules kept for table-specific cleanup
  html = html.replaceAllMapped(
    RegExp(r'\bwidth\s*:\s*[\d.]+(?:pt|cm)[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAll(RegExp(r'\s+width="[\d.]+"', caseSensitive: false), '');

  // Margins that push tables off-screen
  html = html.replaceAllMapped(
    RegExp(r'margin-(?:left|right)\s*:\s*[\d.]+pt[^;}"]*;?', caseSensitive: false),
    (_) => '',
  );

  // align/float cause partial table visibility
  html = html.replaceAll(
    RegExp(r'''\balign=["']?(left|right)["']?''', caseSensitive: false),
    '',
  );

  html = html.replaceAllMapped(
    RegExp(r'\bfloat\s*:\s*(left|right)[^;}"]*', caseSensitive: false),
    (_) => '',
  );

  html = html.replaceAll(';;', ';');
  html = html.replaceAll('style=""', '');
  html = html.replaceAll('style=" "', '');

  // Collapse empty paragraphs and leading whitespace before content
  html = html.replaceAll(RegExp(r'<p>\s+', caseSensitive: false), '<p>');
  html = html.replaceAll(RegExp(r'<p>\s*</p>', caseSensitive: false), '');

  return html;
}
