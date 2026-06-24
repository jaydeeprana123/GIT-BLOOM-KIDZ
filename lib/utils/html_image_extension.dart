import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

double _resolveMaxWidth(BuildContext context, BoxConstraints constraints) {
  if (constraints.maxWidth.isFinite && constraints.maxWidth > 0) {
    return constraints.maxWidth;
  }
  // Card horizontal margin (20*2) + description padding (12*2)
  return MediaQuery.sizeOf(context).width - 64;
}

Widget _buildMemoryImage(Uint8List bytes, double maxWidth) {
  return Image.memory(
    bytes,
    width: maxWidth,
    fit: BoxFit.contain,
    gaplessPlayback: true,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

Widget _buildNetworkImage(String src, double maxWidth) {
  return Image.network(
    src,
    width: maxWidth,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

/// Renders `<img>` tags including base64 `data:image/...` URIs from CMS/Word HTML.
TagExtension htmlImageExtension() {
  return TagExtension(
    tagsToExtend: {"img"},
    builder: (extensionContext) {
      final src = extensionContext.attributes['src'] ?? '';

      return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = _resolveMaxWidth(context, constraints);

          Widget? image;
          if (src.startsWith('data:image')) {
            try {
              final base64Str = src.split(',').last;
              image = _buildMemoryImage(base64Decode(base64Str), maxWidth);
            } catch (_) {
              image = null;
            }
          } else if (src.isNotEmpty && !src.startsWith('data:')) {
            image = _buildNetworkImage(src, maxWidth);
          }

          if (image == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: image,
          );
        },
      );
    },
  );
}
