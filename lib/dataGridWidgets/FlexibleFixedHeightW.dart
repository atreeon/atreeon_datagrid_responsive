import 'package:flutter/material.dart';

///If a height is provided the widget constrains the child to that size.
///If height is null the widget only injects flex behavior when no other Flexible or Expanded ancestor already does so.
class FlexibleFixedHeightW extends StatelessWidget {
  final Widget child;
  final double? height;

  const FlexibleFixedHeightW({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // Guard flex sizing so we only provide ParentData when the caller has not supplied an explicit height.
    if (height == null) {
      // Identify an enclosing Flex so we know when tight layout behavior is still expected.
      final flexAncestor = context.findAncestorWidgetOfExactType<Flex>();
      final flexControllerAncestor = context.findAncestorWidgetOfExactType<Flexible>() ?? context.findAncestorWidgetOfExactType<Expanded>();

      // Supply tight flex sizing only when we are the sole widget responsible for it inside a Flex.
      if (flexAncestor != null && flexControllerAncestor == null) {
        return Flexible(fit: FlexFit.tight, child: child);
      }

      return child;
    }

    // Constrain the child to a fixed height using SizedBox rather than Container for clarity.
    return SizedBox(
      height: height,
      child: child,
    );
  }
}
