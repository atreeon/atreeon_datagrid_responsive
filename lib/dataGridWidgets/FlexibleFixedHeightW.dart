import 'package:flutter/material.dart';

///If a height is provided the widget constrains the child to that size.
///If height is null the widget returns an [Expanded] so the child fills the available space.
class FlexibleFixedHeightW extends StatelessWidget {
  final Widget child;
  final double? height;

  const FlexibleFixedHeightW({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  Widget build(BuildContext context) {
    if (height == null) //
      return Expanded(child: child);

    // Constrain the child to a fixed height using SizedBox rather than Container for clarity.
    return SizedBox(
      height: height,
      child: child,
    );
  }
}
