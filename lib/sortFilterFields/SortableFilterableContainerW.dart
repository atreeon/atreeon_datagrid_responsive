import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/SortableButton.dart';
import 'package:flutter/material.dart';
import 'package:atreeon_datagrid_responsive/theme/data_grid_header_theme.dart';
import 'package:flutter/widgets.dart';

class SortableFilterableW<T> extends StatelessWidget {
  final List<Field<T>> fields;

  ///{@macro [labelId]}
  final String labelId;

  final void Function(List<Field<T>>) onPressed;
  final void Function(List<Field<T>>) onChanged;

  // final bool showFilter;
  // final void Function() onShowFilter;

  final double? fontSize;
  final bool alwaysShowFilter;
  /// Tells the header button whether to keep the original column ordering when sorting.
  final bool preserveFieldOrderOnSort;

  const SortableFilterableW({
    Key? key,
    required this.fields,
    required this.labelId,
    required this.onPressed,
    required this.onChanged,
    // required this.showFilter,
    // required this.onShowFilter,
    // fontSize is now optional to allow theme-driven sizing.
    this.fontSize,
    this.alwaysShowFilter = false,
    this.preserveFieldOrderOnSort = true,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final theme = context.dgHeaderTheme;
    final scaler = MediaQuery.textScalerOf(context);
    final effectiveFontSize = scaler.scale(fontSize ?? (theme.titleStyle.fontSize ?? 14));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SortableButton(
          fields,
          labelId,
          onPressed,
          fontSize: effectiveFontSize,
          alwaysShowFilter: alwaysShowFilter,
          preserveFieldOrderOnSort: preserveFieldOrderOnSort,
        ),
      ],
    );
  }
}
