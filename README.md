# atreeon_datagrid_responsive

A datagrid with sorting and filtering capabilities.  It is also responsive to screen size.  Fully Typed.

<p align="center">
<img alt="atreeon_datagrid_responsive example" src="https://github.com/atreeon/atreeon_datagrid_responsive/raw/master/resources/atreeon_datagrid_responsive_demo.gif">
</p>

## Simple Demo

see examples folder for more examples

```
class SimpleDemo extends StatelessWidget {
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

var ramLookup = {64: "sixtyfour", 1: "one", 128: "one hundred & twenty eight"};


```

## Features
* multi select
* sorting and secondary sort capabilities
* typed filtering
* vertical responsive design

## Limitations
* no cell editing capability (you can open a dialog on click of a row though)
* some data types aren't yet supported (DateTime)
* no grouping
* no reording column placement
* no widening or narrowing of column widths
