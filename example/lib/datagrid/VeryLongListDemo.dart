import 'package:atreeon_datagrid_responsive/ReusableDataGridW.dart';
import 'package:atreeon_datagrid_responsive/common.dart';
import 'package:flutter/material.dart';

class Item {
  String name;
  int ram;
  int price;
  int storage;

  Item(this.name, this.ram, this.price, this.storage);
}

var originalData = List<Item>.generate(
    2000,
    (i) => //
        Item("id: $i", i * 2, i ~/ 2, i + 500));

var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

class VeryLongListDemo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ResusableDatagridW<Item>(
              data: originalData,
              fields: [
                Field<Item>((x) => x.name, "name", FilterFieldString()),
                Field<Item>((x) => ramLookup[x.ram] ?? x.ram.toString(), "ram", FilterFieldNum()),
                Field<Item>((x) => x.price, "price", FilterFieldNum()),
                Field<Item>((x) => x.storage, "storage", FilterFieldNum()),
              ],
              onRowClick: (x) => print(x.toString()),
              lastSaveDate: null,
            ),
          ),
        ],
      ),
    );
  }
}
