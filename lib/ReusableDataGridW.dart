import 'package:atreeon_datagrid_responsive/dataGridWidgets/DataGridRowsDTS.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/FlexibleFixedHeightW.dart';
import 'package:atreeon_datagrid_responsive/dataGridWidgets/atreeon_paginated_data_table.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/SortableFilterableContainerW.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_get_child_size/atreeon_get_child_size.dart';
import 'package:flutter/material.dart';

import 'sortFilterFields/logic/multi_filter.dart';
import 'sortFilterFields/logic/multi_sort.dart';

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
  final double headerHeight;
  final double footerHeight;
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

  final double fontSize;

  final double columnSpacing;
  final double horizontalMargin;

  ///[fields] definition of fields to display
  ///[lastSaveDate] change this field to update the list with new data (can't do a compare of thousands of records nicely)
  ResusableDatagridW({
    Key? key,
    required this.data,
    required this.fields,
    required this.lastSaveDate,
    required this.headerHeight,
    required this.footerHeight,
    this.onRowClick,
    this.onCreateClick,
    this.rowHeight = 30,
    this.identityFieldId = null,
    this.onSelect,
    this.selectName = "select",
    this.selectedIds,
    this.maxHeight,
    this.fontSize = 12,
    this.columnSpacing = 10,
    this.horizontalMargin = 10,
  }) : super(key: key);

  _ResusableDatagridW<T> createState() => _ResusableDatagridW();
}

class _ResusableDatagridW<T> extends State<ResusableDatagridW<T>> {
  var rowsPerPage = 100;
  var remainderHeight = 0.0;

  ///used to hold the widget size so we always have that value if recalculating the size
  var widgetSize = Size(100, 400);
  var selectedIds = <String>[];

  late double? maxHeight;

  // late bool hasFilter;
  late double rowHeight;
  late List<Field<T>> fields;
  late Iterable<T> data;

  void _init() {
    rowHeight = widget.rowHeight;
    fields = widget.fields;
    maxHeight = widget.maxHeight;
    data = widget.data.multiFilter(fields).multisort(fields);
    // hasFilter = fields.any((element) => (element.filter?.isSet ?? false) == true);
    onSizeChange(widgetSize);

    if (widget.selectedIds != null && widget.identityFieldId != null) {
      selectedIds = widget.selectedIds! //
          .map((x) => widget.identityFieldId!.fieldDefinition(x).toString())
          .toList();
    }
  }

  void initState() {
    _init();

    super.initState();
  }

  void didUpdateWidget(ResusableDatagridW<T> oldWidget) {
    _init();
    if (widget.lastSaveDate != oldWidget.lastSaveDate || widget.data.length != oldWidget.data.length) {
      selectedIds = [];
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
    // setState(() => hasFilter = !hasFilter);
    onSizeChange(widgetSize);
  }

  ///The callback for MeasureSize widget.
  ///When the size is changed the rows per page is adjusted so the
  /// datagrid can increase the number of rows shown.
  ///Ignored if [widget.maxHeight] is set
  void onSizeChange(Size size) {
    setState(() {
      if (maxHeight == null) {
        rowsPerPage = (size.height) ~/ (rowHeight) - 2;
        widgetSize = size;
        // print('size.height ${size.height}, rowHeight $rowHeight, rowsPerPage $rowsPerPage');
      } else {
        var rowsHeight = widget.maxHeight! - widget.footerHeight - widget.headerHeight;
        rowsPerPage = (rowsHeight ~/ rowHeight);
        var padding = (widget.footerHeight + widget.headerHeight + 2) / rowsPerPage;
        remainderHeight = widget.maxHeight! - (rowsPerPage * (rowHeight + padding));
        // print('size.height ${size.height}, maxHeight: $maxHeight, rowHeight $rowHeight, rowsPerPage $rowsPerPage, padding $padding, remainderHeight $remainderHeight, maxHeight: ${widget.maxHeight}');
        // print('data.length <= rowsPerPage ${data.length <= rowsPerPage}, data.length ${data.length}, rowsPerPage $rowsPerPage');

        //if the number of records <= max number of rows per page based on height
        //eg 10 rows <= 15 max rows per page
        if (data.length <= rowsPerPage) {
          rowsPerPage = data.length;

          //if so we set the maxHeight, when not null AtreeonPaginatedDataTable is used instead of DataTable
          maxHeight = (rowsPerPage * rowHeight) + rowHeight;
        }
      }
    });
  }

  Widget build(BuildContext context) {
    if (widget.data.length == 0) //
      return Text("no data");

    var columns = [
      ...widget.fields
          .map(
            (e) => DataColumn(
              label: SortableFilterableW(
                fields: fields,
                labelId: e.labelId,
                onPressed: setFields,
                onChanged: setFields,
                fontSize: widget.fontSize,
              ),
            ),
          )
          .toList(),
      if (widget.identityFieldId != null && widget.onSelect != null) //
        DataColumn(
          label: InkWell(
            child: Text(
              widget.selectName,
              style: TextStyle(fontSize: widget.fontSize, decoration: TextDecoration.underline),
            ),
            onTap: () => widget.onSelect!(this.selectedIds),
          ),
        ),
    ];

    var dts = DataGridRowsDTS(
      data.toList(),
      widget.fields,
      widget.onRowClick,
      widget.identityFieldId,
      selectedIds,
      (x) => setState(() => selectedIds = x),
      fontSize: widget.fontSize,
    );

    return FlexibleFixedHeightW(
      height: maxHeight == null ? null : maxHeight!,
      child: GetChildSize(
        onChange: (size) {
          onSizeChange(size);
        },
        child: Stack(
          children: [
            //if maxHeight is set & maxHeight hasn't been reset because the number of children is less than max per rows
            if (widget.maxHeight != null && maxHeight != widget.maxHeight)
              Container(
                decoration: BoxDecoration(
                    // border: Border.all(color: Colors.green),
                    ),
                child: DataTable(
                  columnSpacing: widget.columnSpacing,
                  horizontalMargin: widget.horizontalMargin,
                  dividerThickness: 0,
                  showCheckboxColumn: false,
                  dataRowMaxHeight: rowHeight,
                  dataRowMinHeight: rowHeight,
                  rows: dts.getAllRows(),
                  headingRowHeight: widget.headerHeight + (remainderHeight),
                  columns: columns,
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                    // border: Border.all(color: Colors.yellow),
                    ),
                child: SingleChildScrollView(
                  child: AtreeonPaginatedDataTable(
                    columnSpacing: widget.columnSpacing,
                    horizontalMargin: widget.horizontalMargin,
                    showCheckboxColumn: false,
                    showFirstLastButtons: true,
                    dataRowHeight: rowHeight,
                    source: dts,
                    headingRowHeight: widget.headerHeight + (remainderHeight / 2),
                    columns: columns,
                    rowsPerPage: rowsPerPage,
                    fontSize: widget.fontSize,
                    iconSize: 20,
                    footerHeight: widget.footerHeight + (remainderHeight / 2),
                  ),
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
