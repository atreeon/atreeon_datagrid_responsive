import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/FilterBox.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/WFilterButton.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final double fontSize;

  /// Controls whether the filter button is always visible or triggered by long press.
  final bool alwaysShowFilter;

  ///{@macro [SortableButton]}
  ///
  ///{@macro [labelId]}
  SortableButton(
    this.fields,
    this.labelId,
    this.onPressed, {
    super.key,
    this.buttonText,
    required this.fontSize,
    this.alwaysShowFilter = false,
    // required void Function(List<Field<T>>) onChanged,
  });

  Widget build(BuildContext context) {
    SortField? thisSort;
    var filterSet = false;
    int? index;

    fields.where((e) => e.sort != null).forEachIndexed((e, i) {
      if (e.labelId == labelId) {
        index = i + 1;
        thisSort = e.sort;
      }
    });

    fields.where((e) => e.filter != null).forEachIndexed((e, i) {
      if (e.labelId == labelId) {
        filterSet = e.filter?.isSet ?? false;
      }
    });

    // Render header tap target that cycles sort state while deferring filter controls.
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
      // Allow long press access to filter dialog only when the dedicated button is hidden.
      onLongPress: alwaysShowFilter
          ? null
          : () async {
              await _showFilterDialog(context);
            },
      child: Row(
        children: [
          if (thisSort != null) //
          ...[
            Icon(
              thisSort!.isAscending ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown,
              size: this.fontSize,
              color: Colors.blue,
            ),
            Text(
              index.toString(),
              style: TextStyle(color: Colors.blue, fontSize: this.fontSize),
            ),
          ],
          Text(
            this.buttonText ?? labelId,
            style: TextStyle(color: Colors.blue, fontSize: this.fontSize),
          ),
          if (alwaysShowFilter) //
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: WFilterButton(
                isFiltered: filterSet,
                iconSize: fontSize,
                iconColor: Colors.blue,
                onPressed: () => _showFilterDialog(context),
                tooltip: "Filter by '$labelId'",
              ),
            )
          else if (filterSet) //
            Icon(
              Icons.filter_alt,
              size: this.fontSize,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }

  /// Displays the filter dialog so the caller can adjust filter criteria.
  Future<void> _showFilterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Filter by '$labelId'"),
        content: Column(
          children: [
            FilterBox<T>(
              fields,
              labelId,
              onPressed,
              this.fontSize,
            ),
            Container(height: 50),
            ElevatedButton(
              onPressed: () {
                var newFields = fields.map((e) => e.labelId == labelId ? e.copyWithFilter(e.filter!.clear()) : e).toList();
                onPressed(newFields);
                Navigator.of(context).pop();
              },
              child: const Text('Clear This Filter'),
            ),
            ElevatedButton(
              onPressed: () {
                var newFields = fields.map((e) => e.copyWithFilter(e.filter!.clear())).toList();
                onPressed(newFields);
                Navigator.of(context).pop();
              },
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
