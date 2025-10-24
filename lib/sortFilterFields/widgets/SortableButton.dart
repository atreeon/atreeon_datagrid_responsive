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

    // codex: Build the sortable tap target separately so hover highlights exclude the filter button.
    final sortTapTarget = InkWell(
      // codex: Retains the existing sort-cycle behavior on tap.
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
      // codex: Keep long-press dialog access only when the icon is hidden.
      onLongPress: alwaysShowFilter
          ? null
          : () async {
              await _showFilterDialog(context);
            },
      child: Row(
        // codex: Shrinks to the intrinsic width so padding stays tight beside the filter icon.
        mainAxisSize: MainAxisSize.min,
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
          if (!alwaysShowFilter && filterSet) //
            Icon(
              Icons.filter_alt,
              size: this.fontSize,
              color: Colors.blue,
            ),
        ],
      ),
    );

    if (!alwaysShowFilter) {
      // codex: Preserve legacy hover behavior when the dedicated filter button is disabled.
      return sortTapTarget;
    }

    // codex: Split hover regions so the filter icon highlights independently from the text label.
    return Row(
      // codex: Let the row hug its content so headers stay compact in constrained layouts.
      mainAxisSize: MainAxisSize.min,
      children: [
        // codex: Presents the original sort tap target as an independent hit region.
        sortTapTarget,
        // codex: Adds breathing room between the sort label and filter icon hover areas.
        const SizedBox(width: 4),
        WFilterButton(
          // codex: Reflect whether a filter is active for icon selection.
          isFiltered: filterSet,
          // codex: Match icon sizing with the header font.
          iconSize: fontSize,
          // codex: Continue using the established brand color.
          iconColor: Colors.blue,
          // codex: Reuse the dialog launcher tapped from the button.
          onPressed: () => _showFilterDialog(context),
          tooltip: "Filter by '$labelId'",
        ),
      ],
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
