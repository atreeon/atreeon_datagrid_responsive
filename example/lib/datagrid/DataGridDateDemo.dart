import 'package:atreeon_datagrid_responsive/ReusableDataGridW.dart';
import 'package:atreeon_datagrid_responsive/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final data = {
  DateTime(2022, 12, 20): 1,
  DateTime(2022, 12, 12): 2,
  DateTime(2022, 11, 15): 3,
  DateTime(2022, 11, 3): 4,
  DateTime(2022, 11, 01): 5,
  DateTime(2022, 10, 24): 6,
}.entries.map((e) => MapEntry(e.key, e.value)).toList();

class DataGridDateDemo extends StatefulWidget {
  @override
  _DataGridDateDemoState createState() => _DataGridDateDemoState();
}

class _DataGridDateDemoState extends State<DataGridDateDemo> {
  var dateUpdated = DateTime.now();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ResusableDatagridW<MapEntry<DateTime, int>>(
            maxHeight: 300,
            data: data,
            fields: [
              Field((x) => x.key, "key", FilterFieldString(), format: (x) => DateFormat('dd MMM yy').format(x.key)),
              Field((x) => x.value, "value", FilterFieldString()),
            ],
            onRowClick: (x) => print(x.toString()),
            lastSaveDate: dateUpdated,
            onSelect: (x) => //
                print(x.toString()),
            selectName: "Delete",
          ),
        ],
      ),
    );
  }
}
