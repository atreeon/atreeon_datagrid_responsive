import 'package:atreeon_datagrid_responsive/ReusableDataGridW.dart';
import 'package:atreeon_datagrid_responsive/common.dart';
import 'package:flutter/material.dart';

/// Class of Items
class Item {
  int id;
  String name;

  Item(this.id, this.name);
}

enum Item$ { name, ram }

var smallList = <Item>[
  Item(1, "Adrian"),
  Item(2, "B"),
  Item(3, "CX"),
];

var largeList = <Item>[
  Item(4, "C"),
  Item(5, "D"),
  Item(6, "E"),
  Item(7, "F"),
  Item(11, "Adrian"),
  Item(12, "B"),
  Item(13, "CX"),
  Item(14, "C"),
  Item(15, "D"),
  Item(16, "E"),
  Item(17, "F"),
  Item(21, "Adrian"),
  Item(22, "B"),
  Item(23, "CX"),
  Item(24, "C"),
  Item(25, "D"),
  Item(26, "E"),
  Item(27, "F"),
  Item(31, "Adrian"),
  Item(32, "B"),
  Item(33, "CX"),
  Item(34, "C"),
  Item(35, "D"),
  Item(36, "E"),
  Item(37, "F"),
];

var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

class DataGridMaxHeightDemo extends StatefulWidget {
  @override
  _DataGridMaxHeightDemoState createState() => _DataGridMaxHeightDemoState();
}

class _DataGridMaxHeightDemoState extends State<DataGridMaxHeightDemo> {
  var data = smallList;
  var dateUpdated = DateTime.now();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ResusableDatagridW<Item>(
            maxHeight: 300,
            data: data,
            fields: [
              Field((x) => x.id, "id", FilterFieldNum()),
              Field((x) => x.name, "name", FilterFieldString()),
            ],
            onRowClick: (x) => print(x.toString()),
            lastSaveDate: dateUpdated,
            identityFieldId: Field((x) => x.id, "id", FilterFieldNum()),
            onSelect: (x) => //
            print(x.toString()),
            selectName: "Delete",
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    data = smallList;
                    dateUpdated = DateTime.now();
                  });
                },
                child: Text("small list"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    data = smallList + largeList;
                    dateUpdated = DateTime.now();
                  });
                },
                child: Text("full list"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    data = [];
                    dateUpdated = DateTime.now();
                  });
                },
                child: Text("no data"),
              )
            ],
          )
        ],
      ),
    );
  }
}
