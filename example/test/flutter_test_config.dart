import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Provides shared configuration for the example widget test harness so goldens render text.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Prepare the binding before fonts are loaded for deterministic rendering.
  TestWidgetsFlutterBinding.ensureInitialized();

  // Load fonts from the Flutter SDK cache when available to unlock real glyph rendering.
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    await _loadMaterialFonts(flutterRoot);
  }

  // Defer to the actual test suite now that the environment mirrors the demos.
  await testMain();
}

/// Loads the Material text and icon fonts to mirror the runtime appearance.
Future<void> _loadMaterialFonts(String flutterRoot) async {
  await _registerFontFamily('Roboto', const [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Italic.ttf',
    'Roboto-Bold.ttf',
  ], flutterRoot);
  await _registerFontFamily('MaterialIcons', const [
    'MaterialIcons-Regular.otf',
  ], flutterRoot);
}

/// Registers the fonts for [family] by reading the files from the Flutter SDK cache.
Future<void> _registerFontFamily(
  String family,
  List<String> assets,
  String flutterRoot,
) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(_readFont(flutterRoot, asset));
  }
  await loader.load();
}

/// Reads the font at [asset] from the Flutter SDK cache directory.
Future<ByteData> _readFont(String flutterRoot, String asset) async {
  final file = File('$flutterRoot/bin/cache/artifacts/material_fonts/$asset');
  final bytes = await file.readAsBytes();
  return ByteData.view(bytes.buffer);
}
