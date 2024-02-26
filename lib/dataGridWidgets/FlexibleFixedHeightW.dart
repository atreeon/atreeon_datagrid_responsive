import 'package:flutter/material.dart';

///If a height is passed it is a fixed height widget
///
///If height is null it is flexible (column(expanded))
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
      return Column(
        children: [
          Expanded(child: child),
        ],
      );

    return Container(
      height: height,
      child: child,
    );
  }
}
