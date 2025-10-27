//flutter test --plain-name=LessonSplitter

import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_filter.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/FilterField.dart';
import 'package:test/test.dart';

class Unsupported implements Comparable<dynamic> {
  int compareTo(dynamic other) {
    throw UnimplementedError();
  }
}

/// Class of Items
class Computer {
  final String name;
  final int ram;
  final double? cost;
  final Unsupported? unsupported;

  Computer(this.name, this.ram, {this.unsupported, this.cost});

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}, unsupported: ${this.unsupported}, cost: ${this.cost} ";
}

Map<String, Comparable?> itemSortFilterFields(Computer phone) => {
  'name': phone.name,
  'ram': phone.ram,
  'unsupported': phone.unsupported,
  'cost': phone.cost,
};

void main() {
  group("filterSort", () {
    var list = [
      Computer("Adrian", 1),
      Computer("Bob", 128),
      Computer("Andrew", 64, cost: 5000),
    ];

    test("1 filter by text", () {
      var fields = <Field<Computer>>[
        // codex: Use a const string filter to avoid recreating identical contains filters during tests.
        Field((x) => x.name, "name", const FilterFieldString(searchText: 'A')),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Adrian", 1),
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("3 filter by number", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.ram,
          "ram",
          // codex: Const numeric filter ensures range comparisons reuse the same immutable configuration.
          const FilterFieldNum(
            filter1: 63,
            filter2: null,
            numFilterType: eNumFilterType.between,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Bob", 128),
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("3b filter by single number (not range)", () {
      var fields = <Field<Computer>>[
        // codex: Const numeric filter avoids rebuilding identical equality checks for ram.
        Field((x) => x.ram, "ram", const FilterFieldNum(filter1: 64)),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("3c filter by single number & double", () {
      var fields = <Field<Computer>>[
        // codex: Apply const so the double-based equality filter stays immutable between assertions.
        Field((x) => x.ram, "ram", const FilterFieldNum(filter1: 64.0)),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("3d filter by number but using fieldDefForSortFilter as data is a string", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.ram.toString() + "x",
          "ram",
          // codex: Const numeric filter keeps the lookup test from reallocating equivalent filter instances.
          const FilterFieldNum(filter1: 64),
          fieldDefForSortFilter: (x) => x.ram,
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("4 filter by nullable double", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.cost,
          "cost",
          // codex: Const numeric filter stabilizes the null-tolerant range configuration for doubles.
          const FilterFieldNum(
            filter1: 2000.0,
            filter2: null,
            numFilterType: eNumFilterType.between,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("5 filter not set", () {
      var fields = <Field<Computer>>[
        // codex: Const string filter mirrors analyzer guidance even when the query is null.
        Field((x) => x.name, "name", const FilterFieldString(searchText: null)),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Adrian", 1),
        Computer("Bob", 128),
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("6 two filters", () {
      var fields = <Field<Computer>>[
        // codex: Const string filter avoids repeated creation for contains queries in combined filters.
        Field((x) => x.name, "name", const FilterFieldString(searchText: 'A', stringFilterType: eStringFilterType.contains)),
        Field(
          (x) => x.ram,
          "ram",
          // codex: Const numeric filter keeps the between range immutable inside multi-filter setups.
          const FilterFieldNum(
            filter1: null,
            filter2: 5,
            numFilterType: eNumFilterType.between,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Adrian", 1),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("with lookup list", () {
      var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

      var fields = <Field<Computer>>[
        // codex: Const string filter ensures lookup-based contains checks stay allocation-free.
        Field((x) => ramLookup[x.ram], "ram", const FilterFieldString(searchText: 't')),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Bob", 128), //t - 1Two8
        Computer("Andrew", 64, cost: 5000), //t - sixTyfour
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("10 diacritic", () {
      var list2 = [
        Computer("Adriân", 1),
        Computer("Bob", 128),
        Computer("Adrian", 64, cost: 5000),
      ];

      var fields = <Field<Computer>>[
        // codex: Const string filter keeps diacritic comparison setup immutable between runs.
        Field((x) => x.name, "name", const FilterFieldString(searchText: 'Adrian')),
      ];

      var sorted = list2.multiFilter(fields);
      var expected = [
        Computer("Adriân", 1),
        Computer("Adrian", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("11 diacritic", () {
      var list2 = [
        Computer("département", 1),
        Computer("Bob", 128),
        Computer("department", 64, cost: 5000),
      ];

      var fields = <Field<Computer>>[
        // codex: Const string filter ensures accent-insensitive comparisons reuse the same config.
        Field((x) => x.name, "name", const FilterFieldString(searchText: 'depart')),
      ];

      var sorted = list2.multiFilter(fields);
      var expected = [
        Computer("département", 1),
        Computer("department", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("12 FilterFieldString startsWith", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.name,
          "name",
          // codex: Const string filter ensures startsWith checks avoid redundant allocations.
          const FilterFieldString(
            searchText: 'A',
            stringFilterType: eStringFilterType.startsWith,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Adrian", 1),
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("13 FilterFieldString equals", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.name,
          "name",
          // codex: Const string filter keeps exact match queries immutable for equality tests.
          const FilterFieldString(
            searchText: 'Adrian',
            stringFilterType: eStringFilterType.equals,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Adrian", 1),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("13.1 FilterFieldString equals, if null shouldn't restrict", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.name,
          "name",
          // codex: Const string filter maintains empty-string equals checks without extra instances.
          const FilterFieldString(
            searchText: '',
            stringFilterType: eStringFilterType.equals,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expectedLength = 3;

      expect(sorted.length, expectedLength);
    });

    test("14 FilterFieldString endsWith", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.name,
          "w",
          // codex: Const string filter keeps endsWith test cases deterministic without reallocations.
          const FilterFieldString(
            searchText: 'w',
            stringFilterType: eStringFilterType.endsWith,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("14.5 FilterFieldString starts with textual but number", () {
      var items = [
        Item("id: 10", 11, 21, 31),
        Item("id: 20", 12, 22, 32),
        Item("id: 30", 13, 23, 33),
      ];

      var fields = <Field<Item>>[
        Field<Item>(
          (x) => x.name,
          "name",
          // codex: Const string filter powers prefix matching over numeric ids without new objects per run.
          const FilterFieldString(searchText: "id: 1", stringFilterType: eStringFilterType.startsWith),
        ),
      ];

      var sorted = items.multiFilter(fields);
      var expected = [
        Item("id: 10", 11, 21, 31),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("15 FilterFieldNum gt", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.ram,
          "ram",
          // codex: Const numeric filter keeps greater-than comparisons immutable in the scenario tests.
          const FilterFieldNum(
            filter1: 100,
            numFilterType: eNumFilterType.gt,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Bob", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("16 FilterFieldNum equals", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.ram,
          "ram",
          // codex: Const numeric filter stabilizes equality checks for RAM size comparisons.
          const FilterFieldNum(
            filter1: 64,
            numFilterType: eNumFilterType.equals,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Andrew", 64, cost: 5000),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("17 FilterFieldNum contains", () {
      var fields = <Field<Computer>>[
        Field(
          (x) => x.ram,
          "ram",
          // codex: Const numeric filter holds the contains-search configuration as an immutable reference.
          const FilterFieldNum(
            filter1: 8,
            numFilterType: eNumFilterType.contains,
          ),
        ),
      ];

      var sorted = list.multiFilter(fields);
      var expected = [
        Computer("Bob", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("18 FilterFieldDate between", () {
      final entries = <MapEntry<DateTime, int>>[
        MapEntry(DateTime(2023, 12, 31), 1),
        MapEntry(DateTime(2024, 01, 01), 2),
        MapEntry(DateTime(2024, 02, 14), 3),
        MapEntry(DateTime(2024, 03, 01), 4),
        MapEntry(DateTime(2024, 04, 01), 5),
      ];

      final fields = <Field<MapEntry<DateTime, int>>>[
        Field(
          (x) => x.key,
          "date",
          FilterFieldDate(
            filter1: DateTime(2024, 01, 01),
            filter2: DateTime(2024, 03, 01),
            dateFilterType: eDateFilterType.between,
          ),
        ),
      ];

      final filtered = entries.multiFilter(fields);
      final expected = [
        MapEntry(DateTime(2024, 01, 01), 2),
        MapEntry(DateTime(2024, 02, 14), 3),
        MapEntry(DateTime(2024, 03, 01), 4),
      ];

      expect(filtered.toString(), expected.toString());
    });
  });
}

class Item {
  String name;
  int ram;
  int price;
  int storage;

  Item(this.name, this.ram, this.price, this.storage);

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}, cost: ${this.price}, storage: ${this.storage}";
}

///// A matcher for functions that throw Exception.
//const Matcher throwsDataTypeNotSupportedException = Throws(isDataTypeNotSupportedException);
//const isDataTypeNotSupportedException = const TypeMatcher<DataTypeNotSupportedException>();

/// A matcher for functions that throw Exception.
//const Matcher throwsException = throwsA(DataTypeNotSupportedException);
