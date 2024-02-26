import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/FilterBox.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/SortableButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SortableFilterableW<T> extends StatelessWidget {
  final List<Field<T>> fields;

  ///{@macro [labelId]}
  final String labelId;

  final void Function(List<Field<T>>) onPressed;
  final void Function(List<Field<T>>) onChanged;
  // final bool showFilter;
  // final void Function() onShowFilter;

  final double fontSize;

  const SortableFilterableW({
    Key? key,
    required this.fields,
    required this.labelId,
    required this.onPressed,
    required this.onChanged,
    // required this.showFilter,
    // required this.onShowFilter,
    required this.fontSize,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Visibility(
        //   child: FilterBox<T>(fields, labelId, onChanged, this.fontSize),
        //   visible: showFilter,
        //   maintainState: true,
        // ),
        SortableButton(
          fields,
          labelId,
          onPressed,
          fontSize: this.fontSize,
        ),
      ],
    );
  }
}
