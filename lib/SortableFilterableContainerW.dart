import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:atreeon_datagrid_responsive/common.dart';

import 'FilterBox.dart';
import 'SortableButton.dart';

class SortableFilterableW<T> extends StatelessWidget {
  final List<Field<T>> fields;

  ///{@macro [labelId]}
  final String labelId;

  final void Function(List<Field<T>>) onPressed;
  final void Function(List<Field<T>>) onChanged;
  final bool showFilter;
  final void Function() onShowFilter;

  const SortableFilterableW({
    Key? key,
    required this.fields,
    required this.labelId,
    required this.onPressed,
    required this.onChanged,
    required this.showFilter,
    required this.onShowFilter,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          child: FilterBox<T>(fields, labelId, onChanged),
          visible: showFilter,
          maintainState: true,
        ),
        SortableButton(fields, labelId, onPressed),
      ],
    );
  }
}

//        container.showFilter
//            ? //
//            FilterBox(container.filteredFields, fieldName, container.onChanged, filterDataType)
//            : Text(''),
//        InkWell(
//                child: Icon(
//                  FontAwesomeIcons.search,
//                  size: 10,
//                ),
//                onTap: container.onShowFilter,
//              ),
//        SortableButton(container.sortedFields, fieldName, container.onPressed, buttonText: this.buttonText),

//how do I get the field?
