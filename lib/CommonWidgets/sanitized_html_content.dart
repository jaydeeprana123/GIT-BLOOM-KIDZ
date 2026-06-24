import 'package:bloom_kidz/Styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

import '../utils/html_image_extension.dart';
import '../utils/html_sanitizer.dart';

/// Renders CMS / Word HTML with the same sanitization and layout as News Feed.
class SanitizedHtmlContent extends StatelessWidget {
  final String html;
  final EdgeInsetsGeometry padding;

  const SanitizedHtmlContent({
    super.key,
    required this.html,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final sanitized = sanitizeHtmlForDisplay(html);
    if (sanitized.trim().isEmpty) return const SizedBox.shrink();

    const cellBorder = Border.fromBorderSide(
      BorderSide(color: Color(0xFF9E9E9E), width: 1),
    );

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Html(
            data: sanitized,
            shrinkWrap: true,
            style: {
              "*": Style(
                fontSize: FontSize(13),
                color: text_color,
                lineHeight: LineHeight(1.4),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              "p": Style(
                margin: Margins.only(bottom: 6),
                padding: HtmlPaddings.zero,
              ),
              "ul": Style(
                margin: Margins.only(bottom: 6),
                padding: HtmlPaddings.only(left: 20),
              ),
              "ol": Style(
                margin: Margins.only(bottom: 6),
                padding: HtmlPaddings.only(left: 20),
              ),
              "li": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                display: Display.listItem,
              ),
              "img": Style(
                width: Width(constraints.maxWidth, Unit.px),
                margin: Margins.symmetric(vertical: 8),
              ),
              "table": Style(
                width: Width(constraints.maxWidth, Unit.px),
                margin: Margins.symmetric(vertical: 8),
                border: cellBorder,
              ),
              "td": Style(
                padding: HtmlPaddings.all(8),
                border: cellBorder,
                alignment: Alignment.centerLeft,
              ),
              "th": Style(
                padding: HtmlPaddings.all(8),
                border: cellBorder,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerLeft,
              ),
            },
            extensions: [
              TableHtmlExtension(),
              htmlImageExtension(),
              TagWrapExtension(
                tagsToWrap: {"table"},
                builder: (child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: child,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
