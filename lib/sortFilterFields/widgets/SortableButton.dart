import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/FilterBox.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/widgets/WFilterButton.dart';
import 'package:atreeon_datagrid_responsive/theme/data_grid_header_theme.dart';
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

  // Make fontSize optional so headers can default to the theme-provided text size.
  final double? fontSize;

  /// Controls whether the filter button is always visible or triggered by long press.
  final bool alwaysShowFilter;

  /// Indicates whether sorting should preserve the incoming field order.
  final bool preserveFieldOrderOnSort;

  ///{@macro [SortableButton]}
  ///
  ///{@macro [labelId]}
  SortableButton(
    this.fields,
    this.labelId,
    this.onPressed, {
    super.key,
    this.buttonText,
    // fontSize no longer required; when null we resolve from theme.
    this.fontSize,
    this.alwaysShowFilter = false,
    this.preserveFieldOrderOnSort = true,
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

    // Resolve header design tokens from the theme and apply accessibility scaling.
    final headerTheme = context.dgHeaderTheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final effectiveTextSize = textScaler.scale(fontSize ?? (headerTheme.titleStyle.fontSize ?? 14));
    final effectiveTextStyle = headerTheme.titleStyle.copyWith(fontSize: effectiveTextSize);
    final effectiveIconSize = textScaler.scale(headerTheme.iconSize);

    final sortTapTarget = InkWell(
      onTap: () {
        var thisField = fields.firstWhere((e) => e.labelId == labelId);
        Field<T> newField;
        if (thisField.sort == null) //
          newField = thisField.copyWithSort(SortField(isAscending: true));
        else if (thisField.sort!.isAscending) //
          newField = thisField.copyWithSort(SortField(isAscending: false));
        else //
          newField = thisField.copyWithSort(null);

        // Chooses how to rebuild the field list based on the caller's order preference.
        late List<Field<T>> newFields;
        if (preserveFieldOrderOnSort) {
          // Replace only the tapped field so the original column ordering remains intact.
          newFields = fields.map((field) => field.labelId == labelId ? newField : field).toList();
        } else {
          var notNullFields = fields.where((e) => e.sort != null && e.labelId != labelId);
          var nullFields = fields.where((e) => e.sort == null && e.labelId != labelId);
          // Sort sorted columns ahead of unsorted ones
          newFields = [
            ...notNullFields,
            newField,
            ...nullFields,
          ];
        }
        onPressed(newFields);
      },
      onLongPress: alwaysShowFilter
          ? null
          : () async {
              await _showFilterDialog(context);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (thisSort != null) //
          ...[
            Icon(
              thisSort!.isAscending ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown,
              size: effectiveIconSize,
              color: Colors.blue,
            ),
            Text(
              index.toString(),
              style: effectiveTextStyle.copyWith(color: Colors.blue),
            ),
          ],
          Flexible(
            child: Text(
              this.buttonText ?? labelId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: effectiveTextStyle.copyWith(color: Colors.blue),
            ),
          ),
          if (!alwaysShowFilter && filterSet) //
            Icon(
              Icons.filter_alt,
              size: effectiveIconSize,
              color: Colors.blue,
            ),
        ],
      ),
    );

    if (!alwaysShowFilter) {
      return sortTapTarget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: sortTapTarget),
        const SizedBox(width: 4),
        WFilterButton(
          isFiltered: filterSet,
          iconColor: Colors.blue,
          onPressed: () => _showFilterDialog(context),
          tooltip: "Filter by '$labelId'",
        ),
      ],
    );
  }

  /// Displays the filter dialog so the caller can adjust filter criteria.
  Future<void> _showFilterDialog(BuildContext context) async {
    final headerTheme = context.dgHeaderTheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final dialogFontSize = textScaler.scale(fontSize ?? (headerTheme.titleStyle.fontSize ?? 14));
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
              dialogFontSize,
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
