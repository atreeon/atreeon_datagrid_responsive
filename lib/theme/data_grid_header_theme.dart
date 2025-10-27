import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// {@template data_grid_header_theme}
/// Typed design tokens for the DataGrid header area (text, icons, paddings, height).
///
/// Add one of the provided presets to `ThemeData.extensions` and retrieve with
/// `context.dgHeaderTheme`.
/// {@endtemplate}
@immutable
class DataGridHeaderTheme extends ThemeExtension<DataGridHeaderTheme> {
  /// Primary text style for header labels.
  final TextStyle titleStyle;

  /// Secondary/accent style if a header needs a secondary line.
  final TextStyle secondaryStyle;

  /// Base icon size for header controls (sort arrows, filter icon).
  final double iconSize;

  /// Padding applied around header contents.
  final EdgeInsets padding;

  /// Height of the full header row.
  final double height;

  /// {@macro data_grid_header_theme}
  const DataGridHeaderTheme({
    required this.titleStyle,
    required this.secondaryStyle,
    required this.iconSize,
    required this.padding,
    required this.height,
  });

  /// Regular-sized header preset based on the given [TextTheme].
  factory DataGridHeaderTheme.regular(TextTheme tt) => DataGridHeaderTheme(
        titleStyle: tt.titleSmall ?? const TextStyle(fontSize: 14),
        secondaryStyle: tt.labelSmall ?? const TextStyle(fontSize: 12),
        iconSize: (tt.titleSmall?.fontSize ?? 14) + 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: 48,
      );

  /// Large header preset with increased text and icon sizes.
  factory DataGridHeaderTheme.large(TextTheme tt) => DataGridHeaderTheme(
        titleStyle: (tt.titleMedium ?? const TextStyle(fontSize: 16)).copyWith(fontSize: 18),
        secondaryStyle: (tt.labelMedium ?? const TextStyle(fontSize: 14)).copyWith(fontSize: 16),
        iconSize: ((tt.titleMedium?.fontSize ?? 16) + 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: 56,
      );

  @override
  DataGridHeaderTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? secondaryStyle,
    double? iconSize,
    EdgeInsets? padding,
    double? height,
  }) {
    return DataGridHeaderTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      secondaryStyle: secondaryStyle ?? this.secondaryStyle,
      iconSize: iconSize ?? this.iconSize,
      padding: padding ?? this.padding,
      height: height ?? this.height,
    );
  }

  @override
  DataGridHeaderTheme lerp(ThemeExtension<DataGridHeaderTheme>? other, double t) {
    if (other is! DataGridHeaderTheme) return this;
    return DataGridHeaderTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t) ?? titleStyle,
      secondaryStyle: TextStyle.lerp(secondaryStyle, other.secondaryStyle, t) ?? secondaryStyle,
      iconSize: lerpDouble(iconSize, other.iconSize, t) ?? iconSize,
      padding: EdgeInsets.lerp(padding, other.padding, t) ?? padding,
      height: lerpDouble(height, other.height, t) ?? height,
    );
  }
}

/// Context helpers for retrieving the header theme safely with a sensible default.
extension BuildContextDataGridHeaderTheme on BuildContext {
  /// Returns the configured [DataGridHeaderTheme], or a regular preset derived
  /// from the current theme if none is registered.
  DataGridHeaderTheme get dgHeaderTheme =>
      Theme.of(this).extension<DataGridHeaderTheme>() ?? DataGridHeaderTheme.regular(Theme.of(this).textTheme);
}
