import 'dart:ui';

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:morphy_annotation/morphy_annotation.dart';

part 'reusable_data_grid_event.morphy.dart';

/// Base event that informs the bloc about grid interactions and prop updates.
@morphy
abstract class $ReusableDataGridEvent<T> {}

/// Event dispatched when the widget configuration or source data changes.
@morphy
abstract class $ReusableDataGridConfigurationChanged<T> implements $ReusableDataGridEvent<T> {
  /// Latest dataset supplied to the widget from the outside world.
  List<T> get data;

  /// Field definitions that describe columns, filters, and sort order.
  List<Field<T>> get fields;

  /// Identity field used to derive selection keys, when present.
  Field<T>? get identityField;

  /// Optional rows that should be considered selected initially.
  List<T>? get selectedRecords;

  /// Optional maximum height constraint applied to the grid container.
  double? get maxHeight;

  /// Height of an individual row in logical pixels.
  double get rowHeight;

  /// Height of the header section in logical pixels.
  double get headerHeight;

  /// Height of the footer section in logical pixels.
  double get footerHeight;

  /// Timestamp used to detect when persisted changes were saved externally.
  DateTime? get lastSaveDate;

  /// Whether current selections should be cleared before applying updates.
  bool get clearSelection;
}

/// Event emitted when the active sort or filter fields change.
@morphy
abstract class $ReusableDataGridFieldsUpdated<T> implements $ReusableDataGridEvent<T> {
  /// Updated field configuration containing the latest sort and filter state.
  List<Field<T>> get fields;
}

/// Event emitted when the rendered widget reports a new size measurement.
@morphy
abstract class $ReusableDataGridSizeChanged<T> implements $ReusableDataGridEvent<T> {
  /// Dimensions reported by [GetChildSize] when layout changes occur.
  Size get size;
}

/// Event emitted when row selection identifiers are replaced.
@morphy
abstract class $ReusableDataGridSelectionReplaced<T> implements $ReusableDataGridEvent<T> {
  /// Identifiers for rows currently marked as selected.
  List<String> get selectedIds;
}
