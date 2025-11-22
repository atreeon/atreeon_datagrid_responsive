import 'dart:math' as math;

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:flutter/material.dart';

/// Describes the calculated widths for each data column and the optional selection column.
class ColumnWidthPlan {
  /// Concrete widths applied to each data column in index order.
  final List<double> columnWidths;

  /// Optional width applied to the trailing selection column.
  final double? selectionColumnWidth;

  /// Total table width including margins and spacing so the caller can decide when to scroll.
  final double totalTableWidth;

  /// Creates an immutable width plan.
  const ColumnWidthPlan({required this.columnWidths, required this.selectionColumnWidth, required this.totalTableWidth});
}

/// Computes responsive column widths that prefer wider content while never shrinking below header width.
///
/// The algorithm works in three steps:
/// 1. Measure the minimum width for each column using the header text plus a padding allowance for icons.
/// 2. Measure the desired width using the longest formatted cell value plus padding.
/// 3. Distribute any remaining width proportionally to columns that need it, without violating minimums.
///
/// If the available width is smaller than the sum of minimums, the plan returns the minimum widths and the caller
/// should enable horizontal scrolling using [totalTableWidth].
ColumnWidthPlan computeColumnWidthPlan<T>({
  required List<Field<T>> fields,
  required List<T> data,
  required TextStyle headerStyle,
  required TextStyle cellStyle,
  required double availableWidth,
  required double columnSpacing,
  required double horizontalMargin,
  required bool hasSelectionColumn,
  required String selectionLabel,
}) {
  // Reserve space inside each header for text plus sort/filter affordances.
  const double headerPadding = 28;
  // Reserve space inside each cell for text padding.
  const double cellPadding = 16;
  // Estimated width for the checkbox in the selection column.
  const double checkboxWidth = 32;

  final columnCount = fields.length + (hasSelectionColumn ? 1 : 0);
  final availableContentWidth = availableWidth - (horizontalMargin * 2) - (columnSpacing * (columnCount - 1));

  double _measureWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    painter.layout();
    return painter.size.width;
  }

  final headerMinWidths = fields
      .map(
        (field) => _measureWidth(field.labelId, headerStyle) + headerPadding,
      )
      .toList();

  final selectionHeaderWidth = hasSelectionColumn ? _measureWidth(selectionLabel, headerStyle) + headerPadding : 0.0;

  final dataWidths = fields.map(
    (field) {
      var longest = 0.0;
      for (final row in data) {
        final value = field.format != null ? field.format!(row) : field.fieldDefinition(row);
        final textValue = value?.toString() ?? '';
        final measured = _measureWidth(textValue, cellStyle) + cellPadding;
        if (measured > longest) {
          longest = measured;
        }
      }
      return longest;
    },
  ).toList();

  final selectionDataWidth = hasSelectionColumn ? checkboxWidth + cellPadding : 0.0;

  final desiredWidths = List<double>.generate(
    fields.length,
    (index) => math.max(headerMinWidths[index], dataWidths[index]),
  );

  final selectionDesiredWidth = hasSelectionColumn ? math.max(selectionHeaderWidth, selectionDataWidth) : 0.0;

  final minWidths = List<double>.from(headerMinWidths);
  final selectionMinWidth = selectionHeaderWidth;

  final minSum = minWidths.fold<double>(selectionMinWidth, (sum, width) => sum + width);
  final desiredSum = desiredWidths.fold<double>(selectionDesiredWidth, (sum, width) => sum + width);

  List<double> resolvedWidths;
  double resolvedSelectionWidth;

  if (availableContentWidth.isFinite && availableContentWidth > 0) {
    if (desiredSum <= availableContentWidth) {
      resolvedWidths = desiredWidths;
      resolvedSelectionWidth = selectionDesiredWidth;
    } else if (minSum >= availableContentWidth) {
      resolvedWidths = minWidths;
      resolvedSelectionWidth = selectionMinWidth;
    } else {
      final extraAvailable = availableContentWidth - minSum;
      final extraNeeded = desiredSum - minSum;
      resolvedWidths = List<double>.generate(
        fields.length,
        (index) => minWidths[index] + ((desiredWidths[index] - minWidths[index]) / extraNeeded) * extraAvailable,
      );
      resolvedSelectionWidth = hasSelectionColumn ? selectionMinWidth + ((selectionDesiredWidth - selectionMinWidth) / extraNeeded) * extraAvailable : 0.0;
    }
  } else {
    resolvedWidths = desiredWidths;
    resolvedSelectionWidth = selectionDesiredWidth;
  }

  final resolvedSelection = hasSelectionColumn ? resolvedSelectionWidth : null;
  final totalTableWidth = resolvedWidths.fold<double>(0, (sum, width) => sum + width) + (resolvedSelection ?? 0) + (columnSpacing * (columnCount - 1)) + (horizontalMargin * 2);

  return ColumnWidthPlan(columnWidths: resolvedWidths, selectionColumnWidth: resolvedSelection, totalTableWidth: totalTableWidth);
}
