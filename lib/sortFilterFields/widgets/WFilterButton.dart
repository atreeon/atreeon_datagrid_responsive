import 'package:flutter/material.dart';
import 'package:atreeon_datagrid_responsive/theme/data_grid_header_theme.dart';

/// {@template w_filter_button}
/// A compact icon-only button that toggles between filtered and unfiltered states.
/// {@endtemplate}
class WFilterButton extends StatelessWidget {
  /// {@macro w_filter_button}
  const WFilterButton({
    super.key,
    required this.isFiltered,
    required this.onPressed,
    // iconSize optional so the widget can default to the theme-provided header icon size.
    this.iconSize,
    required this.iconColor,
    this.tooltip,
  });

  /// Indicates whether the owning field currently has an active filter applied.
  final bool isFiltered;

  /// Invoked when the button is tapped.
  final VoidCallback onPressed;

  /// Controls the icon size so the button can match surrounding text.
  /// If null, uses `context.dgHeaderTheme.iconSize` multiplied by the current
  /// text scale factor for accessibility.
  final double? iconSize;

  /// Sets the foreground color of the icon.
  final Color iconColor;

  /// Optional tooltip to surface accessibility copy for assistive tech.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    // Resolve the effective icon size from the theme when not provided, and multiply by textScaleFactor for accessibility scaling.
    final scaler = MediaQuery.textScalerOf(context);
    final effectiveIconSize = scaler.scale(iconSize ?? context.dgHeaderTheme.iconSize);
    return IconButton(
      iconSize: effectiveIconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: effectiveIconSize,
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        isFiltered ? Icons.filter_alt : Icons.filter_alt_off_outlined,
        size: effectiveIconSize,
        color: iconColor,
      ),
    );
  }
}
