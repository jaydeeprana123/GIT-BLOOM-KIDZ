import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Renders `<img>` tags including base64 `data:image/...` URIs from CMS/Word HTML.
TagExtension htmlImageExtension() {
  return TagExtension(
    tagsToExtend: {"img"},
    builder: (context) {
      final src = context.attributes['src'] ?? '';
      if (src.startsWith('data:image')) {
        try {
          final base64Str = src.split(',').last;
          final bytes = base64Decode(base64Str);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          );
        } catch (_) {
          return const SizedBox();
        }
      }
      if (src.isNotEmpty && !src.startsWith('data:')) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(
            src,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        );
      }
      return const SizedBox();
    },
  );
}
