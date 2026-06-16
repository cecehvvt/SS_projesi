import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ListingImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ListingImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (source.startsWith('data:image')) {
      child = Image.memory(
        _bytesFromDataUri(source),
        fit: fit,
        width: width,
        height: height,
      );
    } else if (source.startsWith('http')) {
      child = Image.network(
        source,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: _error,
      );
    } else if (source.startsWith('assets/')) {
      child = Image.asset(
        source,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: _error,
      );
    } else {
      child = _placeholder();
    }

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  Uint8List _bytesFromDataUri(String value) {
    final payload = value.substring(value.indexOf(',') + 1);
    return base64Decode(payload);
  }

  Widget _error(BuildContext context, Object error, StackTrace? stackTrace) =>
      _placeholder();

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFEDEDED),
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
