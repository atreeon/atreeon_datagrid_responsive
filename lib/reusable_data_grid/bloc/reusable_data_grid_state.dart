import 'dart:ui';

import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:morphy_annotation/morphy_annotation.dart';

part 'reusable_data_grid_state.morphy.dart';

/// {@template reusable_data_grid_state}
/// Immutable snapshot of the grid values used to render rows and pagination.
/// {@endtemplate}
@morphy
abstract class $ReusableDataGridState<T> {
  /// Complete dataset provided to the grid before any filtering or sorting.
  List<T> get rawData;

  /// Fields describing how each column should render and transform data.
  List<Field<T>> get fields;

  /// Filtered and sorted view of [rawData] that will be displayed.
  List<T> get data;

  /// Identity field used for checkbox selection lookups when available.
  Field<T>? get identityField;

  /// Selected identifiers associated with the current data set.
  List<String> get selectedIds;

  /// Number of rows that can be displayed per page in the paginated view.
  int get rowsPerPage;

  /// Remaining height that should be redistributed between header and footer.
  double get remainderHeight;

  /// Most recent measured size for the rendered widget subtree.
  Size get widgetSize;

  /// Height constraint applied to the wrapping widget when pagination is fixed.
  double? get effectiveMaxHeight;

  /// User requested maximum height before layout calculations adjust the grid.
  double? get requestedMaxHeight;

  /// Height of each data row in logical pixels.
  double get rowHeight;

  /// Height of the grid header region in logical pixels.
  double get headerHeight;

  /// Height of the grid footer region in logical pixels.
  double get footerHeight;

  /// Timestamp used to determine when data refreshes should reset selection.
  DateTime? get lastSaveDate;
}
