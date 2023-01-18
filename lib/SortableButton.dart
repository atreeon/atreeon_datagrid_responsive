import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'common.dart';

/// {@template [SortableButton]}
/// A button to sort & toggle sorting on multiple fields
/// {@endtemplate}
class SortableButton<T> extends StatelessWidget {
  /// The current list of sorted fields
  final List<Field<T>> fields;

  /// {@template [labelId]}
  /// [labelId]
  ///
  /// This is the label and id for the field (must be unique)
  /// {@endtemplate}
  final String labelId;

  /// The text for the button label
  final String? buttonText;

  final void Function(List<Field<T>>) onPressed;

  ///{@macro [SortableButton]}
  ///
  ///{@macro [labelId]}
  SortableButton(this.fields, this.labelId, this.onPressed, {this.buttonText});

  Widget build(BuildContext context) {
    SortField? thisSort;
    int? index;

    fields.where((e) => e.sort != null).forEachIndexed((e, i) {
      if (e.labelId == labelId) {
        index = i + 1;
        thisSort = e.sort;
      }
    });

    return InkWell(
      onTap: () {
        var thisField = fields.firstWhere((e) => e.labelId == labelId);
        Field<T> newField;
        if (thisField.sort == null) //
          newField = thisField.copyWithSort(SortField(isAscending: true));
        else if (thisField.sort!.isAscending) //
          newField = thisField.copyWithSort(SortField(isAscending: false));
        else //
          newField = thisField.copyWithSort(null);

        var notNullFields = fields.where((e) => e.sort != null && e.labelId != labelId);
        var nullFields = fields.where((e) => e.sort == null && e.labelId != labelId);

        var newFields = [
          ...notNullFields,
          newField,
          ...nullFields,
        ];
        onPressed(newFields);
      },
      child: Row(
        children: [
          if (thisSort != null) //
            ...[
            Icon(
              thisSort!.isAscending ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown,
              size: 15,
              color: Colors.blue,
            ),
            Text(
              index.toString(),
              textScaleFactor: 0.6,
              style: TextStyle(color: Colors.blue),
            ),
          ],
          Text(this.buttonText ?? labelId, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
