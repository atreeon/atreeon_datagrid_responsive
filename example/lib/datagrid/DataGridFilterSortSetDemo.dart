import 'package:atreeon_datagrid_responsive/ReusableDataGrid.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:flutter/material.dart';

/// Class of Items
class Item {
  String name;
  int ram;
  int price;
  int storage;

  Item(this.name, this.ram, this.price, this.storage);
}

enum Item$ { name, ram, price, storage }

var originalData = List<Item>.generate(
  2000,
  (i) => //
      Item("id: $i", i * 2, i ~/ 2, i + 500),
);

var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

class DataGridFilterSortSetDemo extends StatelessWidget {
  const DataGridFilterSortSetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ReusableDataGrid<Item>(
              data: originalData,
              fields: [
                Field<Item>((x) => x.name, "name", FilterFieldString(searchText: "1")),
                Field<Item>((x) => (ramLookup[x.ram] ?? x.ram.toString()) + "x", "ram", FilterFieldNum(), fieldDefForSortFilter: (x) => x.ram),
                Field<Item>((x) => x.price, "price", FilterFieldNum()),
                Field<Item>((x) => x.storage, "storage", FilterFieldNum()),
              ],
              onRowClick: (x, y) => print(x.toString()),
              lastSaveDate: null,
              fontSize: 12,
              headerHeight: 20,
              footerHeight: 20,
            ),
          ),
        ],
      ),
    );
  }
}
