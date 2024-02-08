import 'package:atreeon_datagrid_responsive/atreeon_paginated_data_table.dart';
import 'package:atreeon_get_child_size/atreeon_get_child_size.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'SortableFilterableContainerW.dart';
import 'common.dart';
import 'multi_filter.dart';
import 'multi_sort.dart';

///[ResusableDatagridW.fields] what you pass into here is what will be compared in the filter.
///For example if your original data is [1,2,3]
///but your field is Field<int>((x) => x.toString() + 'x'), "blah", "FitlerField2String())
///then your filter will compare this output
///
/// To display an int formatted into a string but search on the original int use
/// the field property of [Field.fieldDefForSortFilter]
class ResusableDatagridW<T> extends StatefulWidget {
  final List<T> data;
  final List<Field<T>> fields;
  final double rowHeight;
  final void Function(T)? onRowClick;
  final void Function()? onCreateClick;
  final DateTime? lastSaveDate;

  ///is used to identify the item for the selectedIds
  final Field<T>? identityFieldId;
  final void Function(List<String>)? onSelect;
  final String selectName;
  final List<T>? selectedIds;

  ///if set, the datagrid shrinks to height of rows or [maxHeight] where it will page
  ///
  ///if [maxHeight] is less than the calculated height of the available
  /// records then we show as normal and page
  ///
  ///if [maxHeight] is more than the calculated height of the available
  /// rows then we shrink the grid to fit the rows
  ///
  ///if [maxHeight] is null then we display as normal (page number)
  final double? maxHeight;

  ///[fields] definition of fields to display
  ///[lastSaveDate] change this field to update the list with new data (can't do a compare of thousands of records nicely)
  ResusableDatagridW({
    Key? key,
    required this.data,
    required this.fields,
    required this.lastSaveDate,
    this.onRowClick,
    this.onCreateClick,
    this.rowHeight = 30,
    this.identityFieldId = null,
    this.onSelect,
    this.selectName = "select",
    this.selectedIds,
    this.maxHeight,
  }) : super(key: key);

  _ResusableDatagridW<T> createState() => _ResusableDatagridW();
}

class _ResusableDatagridW<T> extends State<ResusableDatagridW<T>> {
  var rowsPerPage = 100;

  ///used to hold the widget size so we always have that value if recalculating the size
  var widgetSize = Size(100, 100);
  var selectedIds = <String>[];

  late double? maxHeight;
  late bool hasFilter;
  late double rowHeight;
  late List<Field<T>> fields;
  late Iterable<T> data;

  void initState() {
    rowHeight = widget.rowHeight;
    fields = widget.fields;
    maxHeight = widget.maxHeight;
    data = widget.data.multiFilter(fields).multisort(fields);
    hasFilter = fields.any((element) => (element.filter?.isSet ?? false) == true);

    if (widget.selectedIds != null && widget.identityFieldId != null) {
      selectedIds = widget.selectedIds! //
          .map((x) => widget.identityFieldId!.fieldDefinition(x).toString())
          .toList();
    }

    super.initState();
  }

  void didUpdateWidget(ResusableDatagridW<T> oldWidget) {
    if (widget.lastSaveDate != oldWidget.lastSaveDate || widget.data.length != oldWidget.data.length) {
      data = widget.data;
      rowsPerPage = 100;
      selectedIds = [];
      maxHeight = widget.maxHeight;
      onSizeChange(widgetSize);
    }

    super.didUpdateWidget(oldWidget);
  }

  void setFields(List<Field<T>> _fields) {
    setState(() {
      this.fields = _fields;
      this.data = widget.data.multiFilter(fields).multisort(fields);
    });
  }

  void toggleFilter() {
    setState(() => hasFilter = !hasFilter);
    onSizeChange(widgetSize);
  }

  ///The callback for MeasureSize widget.
  ///When the size is changed the rows per page is adjusted so the
  /// datagrid can increase the number of rows shown.
  ///Ignored if [widget.maxHeight] is set
  void onSizeChange(Size size) {
    setState(() {
      //to do: add tests here as is complicated
      if (maxHeight == null) {
        rowsPerPage = (size.height - (hasFilter ? 145 : 110)) ~/ (rowHeight);
        widgetSize = size;
      } else {
        rowsPerPage = (widget.maxHeight! - (hasFilter ? 145 : 110)) ~/ (rowHeight);

        if (data.length <= rowsPerPage) {
          rowsPerPage = data.length;

          maxHeight = rowsPerPage * rowHeight + (hasFilter ? 85 : 50);
        }
      }
    });
  }

  Widget build(BuildContext context) {
    if (widget.data.length == 0) //
      return Text("no data");

    var columns = [
      DataColumn(
        label: InkWell(
          child: Icon(
            FontAwesomeIcons.search,
            color: widget.data.length == data.length ? Colors.black : Colors.blue,
            size: widget.data.length == data.length ? 10 : 15,
          ),
          onTap: toggleFilter,
        ),
      ),
      ...widget.fields
          .map(
            (e) => DataColumn(
              label: SortableFilterableW(
                fields: fields,
                labelId: e.labelId,
                onPressed: setFields,
                onChanged: setFields,
                showFilter: hasFilter,
                onShowFilter: toggleFilter,
              ),
            ),
          )
          .toList(),
      if (widget.identityFieldId != null && widget.onSelect != null) //
        DataColumn(
          label: ElevatedButton(
            child: Text(widget.selectName),
            onPressed: () => widget.onSelect!(this.selectedIds),
          ),
        ),
    ];

    var dts = DTS(
      data.toList(),
      widget.fields,
      widget.onRowClick,
      widget.identityFieldId,
      selectedIds,
      (x) => setState(() => selectedIds = x),
    );

    double headingRowHeight = hasFilter ? 77 : 45;

    return FlexibleFixedHeightW(
      height: maxHeight,
      child: GetChildSize(
        onChange: (size) {
          onSizeChange(size);
        },
        child: Stack(
          children: [
            //if maxHeight is set & maxHeight hasn't been reset because the number of children is less than max per rows
            if (widget.maxHeight != null && maxHeight != widget.maxHeight)
              DataTable(
                columnSpacing: 20,
                showCheckboxColumn: false,
                dataRowHeight: rowHeight,
                rows: dts.getAllRows(),
                headingRowHeight: headingRowHeight,
                columns: columns,
              )
            else
              SingleChildScrollView(
                child: AtreeonPaginatedDataTable(
                  columnSpacing: 20,
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  dataRowHeight: rowHeight,
                  source: dts,
                  headingRowHeight: headingRowHeight,
                  columns: columns,
                  rowsPerPage: rowsPerPage,
                ),
              ),
            widget.onCreateClick == null
                ? Container()
                : Align(
                    child: ElevatedButton(
                      onPressed: () => widget.onCreateClick!(),
                      child: Text('CREATE NEW'),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
          ],
        ),
      ),
    );
  }
}

class DTS<T> extends DataTableSource {
  final List<T> data;
  final List<Field<T>> fields;
  final void Function(T)? onRowClick;
  final Field<T>? identityField;
  final List<String> selectedIds;
  final void Function(List<String>) onSelected;

  DTS(
    this.data,
    this.fields,
    this.onRowClick,
    this.identityField,
    this.selectedIds,
    this.onSelected,
  );

  List<DataRow> getAllRows() {
    return data.mapIndexed((i, e) => getRow(i)).toList();
  }

  DataRow getRow(int i) {
    return DataRow.byIndex(
      onSelectChanged: (x) {
        onRowClick?.call(data[i]);
      },
      index: i,
      cells: [
        DataCell(Text('')),
        ...fields
            .map(
              (e) => DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.vertical, //.horizontal
                  child: Text(
                    e.format != null ? e.format!(data[i]) : e.fieldDefinition(data[i]).toString(),
                  ),
                ),
              ),
            )
            .toList(),
        if (identityField != null) //
          DataCell(
            Checkbox(
              value: selectedIds.contains(identityField!.fieldDefinition(data[i]).toString()),
              onChanged: (x) {
                var id = identityField!.fieldDefinition(data[i])!;
                var selected = selectedIds //
                    .where((element) => element != id)
                    .toList();
                onSelected([
                  //need to remove the checked value too!
                  ...selected.except([id.toString()]),
                  if (x != null && x == true) //
                    id.toString(),
                ]);
              },
            ),
          ),
      ],
    );
  }

  int get rowCount => data.length;

  bool get isRowCountApproximate => false;

  int get selectedRowCount => 0;
}

///If a height is passed it is a fixed height widget
///
///If height is null it is flexible (column(expanded))
class FlexibleFixedHeightW extends StatelessWidget {
  final Widget child;
  final double? height;

  const FlexibleFixedHeightW({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  Widget build(BuildContext context) {
    if (height == null) //
      return Column(
        children: [
          Expanded(child: child),
        ],
      );

    return Container(
      height: height,
      child: child,
    );
  }
}
