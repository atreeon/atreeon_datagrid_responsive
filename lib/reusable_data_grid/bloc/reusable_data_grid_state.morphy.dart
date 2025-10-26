// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: unused_element

part of 'reusable_data_grid_state.dart';

// **************************************************************************
// Generator: MorphyGenerator<Morphy>
// **************************************************************************

/// {@template reusable_data_grid_state}
/// Immutable snapshot of the grid values used to render rows and pagination.
/// {@endtemplate}
///
class ReusableDataGridState<T> extends $ReusableDataGridState<T> {
  /// Complete dataset provided to the grid before any filtering or sorting.
  final List<T> rawData;

  /// Fields describing how each column should render and transform data.
  final List<Field<T>> fields;

  /// Filtered and sorted view of [rawData] that will be displayed.
  final List<T> data;

  /// Identity field used for checkbox selection lookups when available.
  final Field<T>? identityField;

  /// Selected identifiers associated with the current data set.
  final List<String> selectedIds;

  /// Number of rows that can be displayed per page in the paginated view.
  final int rowsPerPage;

  /// Remaining height that should be redistributed between header and footer.
  final double remainderHeight;

  /// Most recent measured size for the rendered widget subtree.
  final Size widgetSize;

  /// Height constraint applied to the wrapping widget when pagination is fixed.
  final double? effectiveMaxHeight;

  /// User requested maximum height before layout calculations adjust the grid.
  final double? requestedMaxHeight;

  /// Height of each data row in logical pixels.
  final double rowHeight;

  /// Height of the grid header region in logical pixels.
  final double headerHeight;

  /// Height of the grid footer region in logical pixels.
  final double footerHeight;

  /// Timestamp used to determine when data refreshes should reset selection.
  final DateTime? lastSaveDate;

  /// {@template reusable_data_grid_state}
  /// Immutable snapshot of the grid values used to render rows and pagination.
  /// {@endtemplate}
  ///
  ReusableDataGridState({
    required this.rawData,
    required this.fields,
    required this.data,
    this.identityField,
    required this.selectedIds,
    required this.rowsPerPage,
    required this.remainderHeight,
    required this.widgetSize,
    this.effectiveMaxHeight,
    this.requestedMaxHeight,
    required this.rowHeight,
    required this.headerHeight,
    required this.footerHeight,
    this.lastSaveDate,
  });
  ReusableDataGridState._({
    required this.rawData,
    required this.fields,
    required this.data,
    this.identityField,
    required this.selectedIds,
    required this.rowsPerPage,
    required this.remainderHeight,
    required this.widgetSize,
    this.effectiveMaxHeight,
    this.requestedMaxHeight,
    required this.rowHeight,
    required this.headerHeight,
    required this.footerHeight,
    this.lastSaveDate,
  });
  String toString() =>
      "(ReusableDataGridState-rawData:${rawData.toString()}|fields:${fields.toString()}|data:${data.toString()}|identityField:${identityField.toString()}|selectedIds:${selectedIds.toString()}|rowsPerPage:${rowsPerPage.toString()}|remainderHeight:${remainderHeight.toString()}|widgetSize:${widgetSize.toString()}|effectiveMaxHeight:${effectiveMaxHeight.toString()}|requestedMaxHeight:${requestedMaxHeight.toString()}|rowHeight:${rowHeight.toString()}|headerHeight:${headerHeight.toString()}|footerHeight:${footerHeight.toString()}|lastSaveDate:${lastSaveDate.toString()})";
  String toString2() =>
      "ReusableDataGridState(rawData:${rawData.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()},fields:${fields.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()},data:${data.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()},identityField:${identityField == null ? null : "${identityField.toString()} "},selectedIds:${selectedIds.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()},rowsPerPage:${rowsPerPage.toString()},remainderHeight:${remainderHeight.toString()},widgetSize:${widgetSize.toString()},effectiveMaxHeight:${effectiveMaxHeight == null ? null : "${effectiveMaxHeight.toString()} "},requestedMaxHeight:${requestedMaxHeight == null ? null : "${requestedMaxHeight.toString()} "},rowHeight:${rowHeight.toString()},headerHeight:${headerHeight.toString()},footerHeight:${footerHeight.toString()},lastSaveDate:${lastSaveDate == null ? null : "DateTime.parse(\"${lastSaveDate.toString()}\") "})";
  int get hashCode => hashObjects([
    rawData.hashCode,
    fields.hashCode,
    data.hashCode,
    identityField.hashCode,
    selectedIds.hashCode,
    rowsPerPage.hashCode,
    remainderHeight.hashCode,
    widgetSize.hashCode,
    effectiveMaxHeight.hashCode,
    requestedMaxHeight.hashCode,
    rowHeight.hashCode,
    headerHeight.hashCode,
    footerHeight.hashCode,
    lastSaveDate.hashCode,
  ]);
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridState &&
          runtimeType == other.runtimeType &&
          (rawData).equalUnorderedD(other.rawData) &&
          (fields).equalUnorderedD(other.fields) &&
          (data).equalUnorderedD(other.data) &&
          identityField == other.identityField &&
          (selectedIds).equalUnorderedD(other.selectedIds) &&
          rowsPerPage == other.rowsPerPage &&
          remainderHeight == other.remainderHeight &&
          widgetSize == other.widgetSize &&
          effectiveMaxHeight == other.effectiveMaxHeight &&
          requestedMaxHeight == other.requestedMaxHeight &&
          rowHeight == other.rowHeight &&
          headerHeight == other.headerHeight &&
          footerHeight == other.footerHeight &&
          lastSaveDate == other.lastSaveDate;
  ReusableDataGridState<T> copyWith_ReusableDataGridState<T>({
    List<T> Function()? rawData,
    List<Field<T>> Function()? fields,
    List<T> Function()? data,
    Field<T>? Function()? identityField,
    List<String> Function()? selectedIds,
    int Function()? rowsPerPage,
    double Function()? remainderHeight,
    Size Function()? widgetSize,
    double? Function()? effectiveMaxHeight,
    double? Function()? requestedMaxHeight,
    double Function()? rowHeight,
    double Function()? headerHeight,
    double Function()? footerHeight,
    DateTime? Function()? lastSaveDate,
  }) {
    return ReusableDataGridState._(
          rawData: rawData == null
              ? this.rawData as List<T>
              : rawData() as List<T>,
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
          data: data == null ? this.data as List<T> : data() as List<T>,
          identityField: identityField == null
              ? this.identityField as Field<T>?
              : identityField() as Field<T>?,
          selectedIds: selectedIds == null
              ? this.selectedIds as List<String>
              : selectedIds() as List<String>,
          rowsPerPage: rowsPerPage == null
              ? this.rowsPerPage as int
              : rowsPerPage() as int,
          remainderHeight: remainderHeight == null
              ? this.remainderHeight as double
              : remainderHeight() as double,
          widgetSize: widgetSize == null
              ? this.widgetSize as Size
              : widgetSize() as Size,
          effectiveMaxHeight: effectiveMaxHeight == null
              ? this.effectiveMaxHeight as double?
              : effectiveMaxHeight() as double?,
          requestedMaxHeight: requestedMaxHeight == null
              ? this.requestedMaxHeight as double?
              : requestedMaxHeight() as double?,
          rowHeight: rowHeight == null
              ? this.rowHeight as double
              : rowHeight() as double,
          headerHeight: headerHeight == null
              ? this.headerHeight as double
              : headerHeight() as double,
          footerHeight: footerHeight == null
              ? this.footerHeight as double
              : footerHeight() as double,
          lastSaveDate: lastSaveDate == null
              ? this.lastSaveDate as DateTime?
              : lastSaveDate() as DateTime?,
        )
        as ReusableDataGridState<T>;
  }
}

extension $ReusableDataGridState_changeTo_E on $ReusableDataGridState {
  ReusableDataGridState<T> changeTo_ReusableDataGridState<T>({
    List<T> Function()? rawData,
    List<Field<T>> Function()? fields,
    List<T> Function()? data,
    Field<T>? Function()? identityField,
    List<String> Function()? selectedIds,
    int Function()? rowsPerPage,
    double Function()? remainderHeight,
    Size Function()? widgetSize,
    double? Function()? effectiveMaxHeight,
    double? Function()? requestedMaxHeight,
    double Function()? rowHeight,
    double Function()? headerHeight,
    double Function()? footerHeight,
    DateTime? Function()? lastSaveDate,
  }) {
    return ReusableDataGridState._(
          rawData: rawData == null
              ? this.rawData as List<T>
              : rawData() as List<T>,
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
          data: data == null ? this.data as List<T> : data() as List<T>,
          identityField: identityField == null
              ? this.identityField as Field<T>?
              : identityField() as Field<T>?,
          selectedIds: selectedIds == null
              ? this.selectedIds as List<String>
              : selectedIds() as List<String>,
          rowsPerPage: rowsPerPage == null
              ? this.rowsPerPage as int
              : rowsPerPage() as int,
          remainderHeight: remainderHeight == null
              ? this.remainderHeight as double
              : remainderHeight() as double,
          widgetSize: widgetSize == null
              ? this.widgetSize as Size
              : widgetSize() as Size,
          effectiveMaxHeight: effectiveMaxHeight == null
              ? this.effectiveMaxHeight as double?
              : effectiveMaxHeight() as double?,
          requestedMaxHeight: requestedMaxHeight == null
              ? this.requestedMaxHeight as double?
              : requestedMaxHeight() as double?,
          rowHeight: rowHeight == null
              ? this.rowHeight as double
              : rowHeight() as double,
          headerHeight: headerHeight == null
              ? this.headerHeight as double
              : headerHeight() as double,
          footerHeight: footerHeight == null
              ? this.footerHeight as double
              : footerHeight() as double,
          lastSaveDate: lastSaveDate == null
              ? this.lastSaveDate as DateTime?
              : lastSaveDate() as DateTime?,
        )
        as ReusableDataGridState<T>;
  }
}

enum ReusableDataGridState$ {
  rawData,
  fields,
  data,
  identityField,
  selectedIds,
  rowsPerPage,
  remainderHeight,
  widgetSize,
  effectiveMaxHeight,
  requestedMaxHeight,
  rowHeight,
  headerHeight,
  footerHeight,
  lastSaveDate,
}
