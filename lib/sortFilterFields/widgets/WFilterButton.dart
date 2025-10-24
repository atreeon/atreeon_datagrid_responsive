import 'package:flutter/material.dart';

/// {@template w_filter_button}
/// A compact icon-only button that toggles between filtered and unfiltered states.
/// {@endtemplate}
class WFilterButton extends StatelessWidget {
  /// {@macro w_filter_button}
  const WFilterButton({
    super.key,
    required this.isFiltered,
    required this.onPressed,
    required this.iconSize,
    required this.iconColor,
    this.tooltip,
  });

  /// Indicates whether the owning field currently has an active filter applied.
  final bool isFiltered;

  /// Invoked when the button is tapped.
  final VoidCallback onPressed;

  /// Controls the icon size so the button can match surrounding text.
  final double iconSize;

  /// Sets the foreground color of the icon.
  final Color iconColor;

  /// Optional tooltip to surface accessibility copy for assistive tech.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: iconSize,
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        isFiltered ? Icons.filter_alt : Icons.filter_alt_off_outlined,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
