// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: unused_element

part of 'reusable_data_grid_event.dart';

// **************************************************************************
// Generator: MorphyGenerator<Morphy>
// **************************************************************************

/// Base event that informs the bloc about grid interactions and prop updates.
///
class ReusableDataGridEvent<T> extends $ReusableDataGridEvent<T> {
  /// Base event that informs the bloc about grid interactions and prop updates.
  ///
  ReusableDataGridEvent();
  ReusableDataGridEvent._();
  String toString2() => "ReusableDataGridEvent()";

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridEvent && runtimeType == other.runtimeType;
  ReusableDataGridEvent<T> copyWith_ReusableDataGridEvent<T>() {
    return ReusableDataGridEvent._() as ReusableDataGridEvent<T>;
  }
}

extension $ReusableDataGridEvent_changeTo_E on $ReusableDataGridEvent {
  ReusableDataGridEvent<T> changeTo_ReusableDataGridEvent<T>() {
    return ReusableDataGridEvent._() as ReusableDataGridEvent<T>;
  }
}

/// Event dispatched when the widget configuration or source data changes.
///
///implements [$ReusableDataGridEvent]
///

/// Base event that informs the bloc about grid interactions and prop updates.
///
class ReusableDataGridConfigurationChanged<T>
    extends $ReusableDataGridConfigurationChanged<T>
    implements ReusableDataGridEvent<T> {
  /// Latest dataset supplied to the widget from the outside world.
  final List<T> data;

  /// Field definitions that describe columns, filters, and sort order.
  final List<Field<T>> fields;

  /// Identity field used to derive selection keys, when present.
  final Field<T>? identityField;

  /// Optional rows that should be considered selected initially.
  final List<T>? selectedRecords;

  /// Optional maximum height constraint applied to the grid container.
  final double? maxHeight;

  /// Height of an individual row in logical pixels.
  final double rowHeight;

  /// Height of the header section in logical pixels.
  final double headerHeight;

  /// Height of the footer section in logical pixels.
  final double footerHeight;

  /// Timestamp used to detect when persisted changes were saved externally.
  final DateTime? lastSaveDate;

  /// Whether current selections should be cleared before applying updates.
  final bool clearSelection;

  /// Event dispatched when the widget configuration or source data changes.
  ///
  ///implements [$ReusableDataGridEvent]
  ///

  /// Base event that informs the bloc about grid interactions and prop updates.
  ///
  ReusableDataGridConfigurationChanged({
    required this.data,
    required this.fields,
    this.identityField,
    this.selectedRecords,
    this.maxHeight,
    required this.rowHeight,
    required this.headerHeight,
    required this.footerHeight,
    this.lastSaveDate,
    required this.clearSelection,
  });
  ReusableDataGridConfigurationChanged._({
    required this.data,
    required this.fields,
    this.identityField,
    this.selectedRecords,
    this.maxHeight,
    required this.rowHeight,
    required this.headerHeight,
    required this.footerHeight,
    this.lastSaveDate,
    required this.clearSelection,
  });
  String toString() =>
      "(ReusableDataGridConfigurationChanged-data:${data.toString()}|fields:${fields.toString()}|identityField:${identityField.toString()}|selectedRecords:${selectedRecords.toString()}|maxHeight:${maxHeight.toString()}|rowHeight:${rowHeight.toString()}|headerHeight:${headerHeight.toString()}|footerHeight:${footerHeight.toString()}|lastSaveDate:${lastSaveDate.toString()}|clearSelection:${clearSelection.toString()})";
  String toString2() =>
      "ReusableDataGridConfigurationChanged(data:${data.map((dynamic x) {
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
      }).toList().toString()},identityField:${identityField == null ? null : "${identityField.toString()} "},selectedRecords:${selectedRecords == null ? null : selectedRecords!.map((dynamic x) {
              try {
                return x.toString2();
              } catch (e) {
                return x.toString();
              }
            }).toList().toString()},maxHeight:${maxHeight == null ? null : "${maxHeight.toString()} "},rowHeight:${rowHeight.toString()},headerHeight:${headerHeight.toString()},footerHeight:${footerHeight.toString()},lastSaveDate:${lastSaveDate == null ? null : "DateTime.parse(\"${lastSaveDate.toString()}\") "},clearSelection:${clearSelection.toString()})";
  int get hashCode => hashObjects([
    data.hashCode,
    fields.hashCode,
    identityField.hashCode,
    selectedRecords.hashCode,
    maxHeight.hashCode,
    rowHeight.hashCode,
    headerHeight.hashCode,
    footerHeight.hashCode,
    lastSaveDate.hashCode,
    clearSelection.hashCode,
  ]);
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridConfigurationChanged &&
          runtimeType == other.runtimeType &&
          (data).equalUnorderedD(other.data) &&
          (fields).equalUnorderedD(other.fields) &&
          identityField == other.identityField &&
          (selectedRecords ?? []).equalUnorderedD(
            other.selectedRecords ?? [],
          ) &&
          maxHeight == other.maxHeight &&
          rowHeight == other.rowHeight &&
          headerHeight == other.headerHeight &&
          footerHeight == other.footerHeight &&
          lastSaveDate == other.lastSaveDate &&
          clearSelection == other.clearSelection;
  ReusableDataGridEvent<T> copyWith_ReusableDataGridEvent<T>() {
    return ReusableDataGridConfigurationChanged._(
          data: (this as ReusableDataGridConfigurationChanged).data,
          fields: (this as ReusableDataGridConfigurationChanged).fields,
          identityField:
              (this as ReusableDataGridConfigurationChanged).identityField,
          selectedRecords:
              (this as ReusableDataGridConfigurationChanged).selectedRecords,
          maxHeight: (this as ReusableDataGridConfigurationChanged).maxHeight,
          rowHeight: (this as ReusableDataGridConfigurationChanged).rowHeight,
          headerHeight:
              (this as ReusableDataGridConfigurationChanged).headerHeight,
          footerHeight:
              (this as ReusableDataGridConfigurationChanged).footerHeight,
          lastSaveDate:
              (this as ReusableDataGridConfigurationChanged).lastSaveDate,
          clearSelection:
              (this as ReusableDataGridConfigurationChanged).clearSelection,
        )
        as ReusableDataGridEvent<T>;
  }

  ReusableDataGridConfigurationChanged<T>
  copyWith_ReusableDataGridConfigurationChanged<T>({
    List<T> Function()? data,
    List<Field<T>> Function()? fields,
    Field<T>? Function()? identityField,
    List<T>? Function()? selectedRecords,
    double? Function()? maxHeight,
    double Function()? rowHeight,
    double Function()? headerHeight,
    double Function()? footerHeight,
    DateTime? Function()? lastSaveDate,
    bool Function()? clearSelection,
  }) {
    return ReusableDataGridConfigurationChanged._(
          data: data == null ? this.data as List<T> : data() as List<T>,
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
          identityField: identityField == null
              ? this.identityField as Field<T>?
              : identityField() as Field<T>?,
          selectedRecords: selectedRecords == null
              ? this.selectedRecords as List<T>?
              : selectedRecords() as List<T>?,
          maxHeight: maxHeight == null
              ? this.maxHeight as double?
              : maxHeight() as double?,
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
          clearSelection: clearSelection == null
              ? this.clearSelection as bool
              : clearSelection() as bool,
        )
        as ReusableDataGridConfigurationChanged<T>;
  }
}

extension $ReusableDataGridConfigurationChanged_changeTo_E
    on $ReusableDataGridConfigurationChanged {
  ReusableDataGridConfigurationChanged<T>
  changeTo_ReusableDataGridConfigurationChanged<T>({
    List<T> Function()? data,
    List<Field<T>> Function()? fields,
    Field<T>? Function()? identityField,
    List<T>? Function()? selectedRecords,
    double? Function()? maxHeight,
    double Function()? rowHeight,
    double Function()? headerHeight,
    double Function()? footerHeight,
    DateTime? Function()? lastSaveDate,
    bool Function()? clearSelection,
  }) {
    return ReusableDataGridConfigurationChanged._(
          data: data == null ? this.data as List<T> : data() as List<T>,
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
          identityField: identityField == null
              ? this.identityField as Field<T>?
              : identityField() as Field<T>?,
          selectedRecords: selectedRecords == null
              ? this.selectedRecords as List<T>?
              : selectedRecords() as List<T>?,
          maxHeight: maxHeight == null
              ? this.maxHeight as double?
              : maxHeight() as double?,
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
          clearSelection: clearSelection == null
              ? this.clearSelection as bool
              : clearSelection() as bool,
        )
        as ReusableDataGridConfigurationChanged<T>;
  }
}

enum ReusableDataGridConfigurationChanged$ {
  data,
  fields,
  identityField,
  selectedRecords,
  maxHeight,
  rowHeight,
  headerHeight,
  footerHeight,
  lastSaveDate,
  clearSelection,
}

/// Event emitted when the active sort or filter fields change.
///
///implements [$ReusableDataGridEvent]
///

/// Base event that informs the bloc about grid interactions and prop updates.
///
class ReusableDataGridFieldsUpdated<T> extends $ReusableDataGridFieldsUpdated<T>
    implements ReusableDataGridEvent<T> {
  /// Updated field configuration containing the latest sort and filter state.
  final List<Field<T>> fields;

  /// Event emitted when the active sort or filter fields change.
  ///
  ///implements [$ReusableDataGridEvent]
  ///

  /// Base event that informs the bloc about grid interactions and prop updates.
  ///
  ReusableDataGridFieldsUpdated({required this.fields});
  ReusableDataGridFieldsUpdated._({required this.fields});
  String toString() =>
      "(ReusableDataGridFieldsUpdated-fields:${fields.toString()})";
  String toString2() =>
      "ReusableDataGridFieldsUpdated(fields:${fields.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()})";
  int get hashCode => hashObjects([fields.hashCode]);
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridFieldsUpdated &&
          runtimeType == other.runtimeType &&
          (fields).equalUnorderedD(other.fields);
  ReusableDataGridEvent<T> copyWith_ReusableDataGridEvent<T>() {
    return ReusableDataGridFieldsUpdated._(
          fields: (this as ReusableDataGridFieldsUpdated).fields,
        )
        as ReusableDataGridEvent<T>;
  }

  ReusableDataGridFieldsUpdated<T> copyWith_ReusableDataGridFieldsUpdated<T>({
    List<Field<T>> Function()? fields,
  }) {
    return ReusableDataGridFieldsUpdated._(
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
        )
        as ReusableDataGridFieldsUpdated<T>;
  }
}

extension $ReusableDataGridFieldsUpdated_changeTo_E
    on $ReusableDataGridFieldsUpdated {
  ReusableDataGridFieldsUpdated<T> changeTo_ReusableDataGridFieldsUpdated<T>({
    List<Field<T>> Function()? fields,
  }) {
    return ReusableDataGridFieldsUpdated._(
          fields: fields == null
              ? this.fields as List<Field<T>>
              : fields() as List<Field<T>>,
        )
        as ReusableDataGridFieldsUpdated<T>;
  }
}

enum ReusableDataGridFieldsUpdated$ { fields }

/// Event emitted when the rendered widget reports a new size measurement.
///
///implements [$ReusableDataGridEvent]
///

/// Base event that informs the bloc about grid interactions and prop updates.
///
class ReusableDataGridSizeChanged<T> extends $ReusableDataGridSizeChanged<T>
    implements ReusableDataGridEvent<T> {
  /// Dimensions reported by [GetChildSize] when layout changes occur.
  final Size size;

  /// Event emitted when the rendered widget reports a new size measurement.
  ///
  ///implements [$ReusableDataGridEvent]
  ///

  /// Base event that informs the bloc about grid interactions and prop updates.
  ///
  ReusableDataGridSizeChanged({required this.size});
  ReusableDataGridSizeChanged._({required this.size});
  String toString() => "(ReusableDataGridSizeChanged-size:${size.toString()})";
  String toString2() => "ReusableDataGridSizeChanged(size:${size.toString()})";
  int get hashCode => hashObjects([size.hashCode]);
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridSizeChanged &&
          runtimeType == other.runtimeType &&
          size == other.size;
  ReusableDataGridEvent<T> copyWith_ReusableDataGridEvent<T>() {
    return ReusableDataGridSizeChanged._(
          size: (this as ReusableDataGridSizeChanged).size,
        )
        as ReusableDataGridEvent<T>;
  }

  ReusableDataGridSizeChanged<T> copyWith_ReusableDataGridSizeChanged<T>({
    Size Function()? size,
  }) {
    return ReusableDataGridSizeChanged._(
          size: size == null ? this.size as Size : size() as Size,
        )
        as ReusableDataGridSizeChanged<T>;
  }
}

extension $ReusableDataGridSizeChanged_changeTo_E
    on $ReusableDataGridSizeChanged {
  ReusableDataGridSizeChanged<T> changeTo_ReusableDataGridSizeChanged<T>({
    Size Function()? size,
  }) {
    return ReusableDataGridSizeChanged._(
          size: size == null ? this.size as Size : size() as Size,
        )
        as ReusableDataGridSizeChanged<T>;
  }
}

enum ReusableDataGridSizeChanged$ { size }

/// Event emitted when row selection identifiers are replaced.
///
///implements [$ReusableDataGridEvent]
///

/// Base event that informs the bloc about grid interactions and prop updates.
///
class ReusableDataGridSelectionReplaced<T>
    extends $ReusableDataGridSelectionReplaced<T>
    implements ReusableDataGridEvent<T> {
  /// Identifiers for rows currently marked as selected.
  final List<String> selectedIds;

  /// Event emitted when row selection identifiers are replaced.
  ///
  ///implements [$ReusableDataGridEvent]
  ///

  /// Base event that informs the bloc about grid interactions and prop updates.
  ///
  ReusableDataGridSelectionReplaced({required this.selectedIds});
  ReusableDataGridSelectionReplaced._({required this.selectedIds});
  String toString() =>
      "(ReusableDataGridSelectionReplaced-selectedIds:${selectedIds.toString()})";
  String toString2() =>
      "ReusableDataGridSelectionReplaced(selectedIds:${selectedIds.map((dynamic x) {
        try {
          return x.toString2();
        } catch (e) {
          return x.toString();
        }
      }).toList().toString()})";
  int get hashCode => hashObjects([selectedIds.hashCode]);
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReusableDataGridSelectionReplaced &&
          runtimeType == other.runtimeType &&
          (selectedIds).equalUnorderedD(other.selectedIds);
  ReusableDataGridEvent<T> copyWith_ReusableDataGridEvent<T>() {
    return ReusableDataGridSelectionReplaced._(
          selectedIds: (this as ReusableDataGridSelectionReplaced).selectedIds,
        )
        as ReusableDataGridEvent<T>;
  }

  ReusableDataGridSelectionReplaced<T>
  copyWith_ReusableDataGridSelectionReplaced<T>({
    List<String> Function()? selectedIds,
  }) {
    return ReusableDataGridSelectionReplaced._(
          selectedIds: selectedIds == null
              ? this.selectedIds as List<String>
              : selectedIds() as List<String>,
        )
        as ReusableDataGridSelectionReplaced<T>;
  }
}

extension $ReusableDataGridSelectionReplaced_changeTo_E
    on $ReusableDataGridSelectionReplaced {
  ReusableDataGridSelectionReplaced<T>
  changeTo_ReusableDataGridSelectionReplaced<T>({
    List<String> Function()? selectedIds,
  }) {
    return ReusableDataGridSelectionReplaced._(
          selectedIds: selectedIds == null
              ? this.selectedIds as List<String>
              : selectedIds() as List<String>,
        )
        as ReusableDataGridSelectionReplaced<T>;
  }
}

enum ReusableDataGridSelectionReplaced$ { selectedIds }
