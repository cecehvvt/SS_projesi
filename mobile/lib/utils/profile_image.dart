import 'dart:convert';

import 'package:flutter/material.dart';

ImageProvider<Object>? profileImageProvider(String? source) {
  if (source == null || source.isEmpty) return null;
  if (source.startsWith('data:image/')) {
    final separator = source.indexOf(',');
    if (separator < 0) return null;
    try {
      return MemoryImage(base64Decode(source.substring(separator + 1)));
    } on FormatException {
      return null;
    }
  }
  return NetworkImage(source);
}
