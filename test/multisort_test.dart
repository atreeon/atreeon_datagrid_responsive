//flutter test --plain-name=LessonSplitter

import 'package:atreeon_datagrid_responsive/sortFilterFields/logic/multi_sort.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/Field.dart';
import 'package:atreeon_datagrid_responsive/sortFilterFields/models/SortField.dart';
import 'package:test/test.dart';

// Class of Phone
class Phone {
  final String name;
  final int ram;

  Phone(this.name, this.ram);

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}";
}

Map<String, Comparable?> itemSortFilterFields(Phone phone) => {
      'name': phone.name,
      'ram': phone.ram,
    };

class NullablePhone {
  final String name;
  final int? ram;

  NullablePhone(this.name, this.ram);

  String toString() => //
      "name: ${this.name}, ram: ${this.ram}";
}

Map<String, Comparable?> itemSortFilterFields2(NullablePhone phone) => {
      'name': phone.name,
      'ram': phone.ram,
    };

void main() {
  group("multiSort", () {
    var list = [
      Phone("b", 1),
      Phone("b", 128),
      Phone("a", 64),
    ];

    test("two asc", () {
      var sortedFields = <Field<Phone>>[
        Field((x) => x.ram, "RAM", null, sort: SortField(isAscending: true)),
        Field((x) => x.name, "Name", null, sort: SortField(isAscending: true)),
      ];

      var sorted = list.multisort(sortedFields).toList();
      var expected = [
        Phone("b", 1),
        Phone("a", 64),
        Phone("b", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("two asc & desc", () {
      var sortedFields2 = <Field<Phone>>[
        Field((x) => x.name, "Name", null, sort: SortField()),
        Field((x) => x.ram, "RAM", null, sort: SortField(isAscending: false)),
      ];

      var sorted = list.multisort(sortedFields2).toList();
      var expected = [
        Phone("a", 64),
        Phone("b", 128),
        Phone("b", 1),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sort set to null", () {
      var sortedFields2 = <Field<Phone>>[
        Field((x) => x.name, "Name", null),
        Field((x) => x.ram, "RAM", null),
      ];
      var sorted = list.multisort(sortedFields2).toList();
      var expected = [
        Phone("b", 1),
        Phone("b", 128),
        Phone("a", 64),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sorting on nulls", () {
      var list = [
        NullablePhone("b", null),
        NullablePhone("b", 128),
        NullablePhone("a", null),
      ];

      var sortedFields2 = <Field<NullablePhone>>[
        Field((x) => x.ram, "RAM", null, sort: SortField(isAscending: false)),
        Field((x) => x.name, "Name", null, sort: SortField(isAscending: false)),
      ];
      var sorted = list.multisort(sortedFields2).toList();
      var expected = [
        NullablePhone("b", 128),
        NullablePhone("b", null),
        NullablePhone("a", null),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("only one field sorting", () {
      var sortedFields2 = <Field<Phone>>[
        Field((x) => x.name, "Name", null, sort: SortField(isAscending: true)),
      ];

      var sorted = list.multisort(sortedFields2).toList();
      var expected = [
        Phone("a", 64),
        Phone("b", 1),
        Phone("b", 128),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("with lookup list", () {
      var ramLookup = {64: "sixtyfour", 1: "one", 128: "1two8"};

      var sortedFields2 = <Field<Phone>>[
        Field((x) => ramLookup[x.ram], "Name", null, sort: SortField(isAscending: true)),
      ];

      var sorted = list.multisort(sortedFields2).toList();
      var expected = [
        Phone("b", 128),
        Phone("b", 1),
        Phone("a", 64),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("10 diacritic sorting", () {
      var list2 = [
        Phone("département", 1),
        Phone("Bob", 128),
        Phone("dunce", 64),
      ];

      var sortedFields2 = <Field<Phone>>[
        Field((x) => x.name, "Name", null, sort: SortField(isAscending: true)),
      ];

      var sorted = list2.multisort(sortedFields2).toList();
      var expected = [
        Phone("Bob", 128),
        Phone("département", 1),
        Phone("dunce", 64),
      ];

      expect(sorted.toString(), expected.toString());
    });

    test("sort by date", () {
      final data = {
        DateTime(2022, 12, 20): 1,
        DateTime(2022, 12, 12): 2,
        DateTime(2022, 11, 15): 3,
        DateTime(2022, 11, 3): 4,
        DateTime(2022, 11, 01): 5,
        DateTime(2022, 10, 24): 6,
      }.entries.map((e) => MapEntry(e.key, e.value)).toList();

      var sortedFields2 = <Field<MapEntry<DateTime, int>>>[
        Field((x) => x.key, "Name", null, sort: SortField(isAscending: true)),
      ];

      var sorted = data.multisort(sortedFields2).toList();

      final expected = {
        DateTime(2022, 10, 24): 6,
        DateTime(2022, 11, 01): 5,
        DateTime(2022, 11, 3): 4,
        DateTime(2022, 11, 15): 3,
        DateTime(2022, 12, 12): 2,
        DateTime(2022, 12, 20): 1,
      }.entries.map((e) => MapEntry(e.key, e.value)).toList();

      expect(sorted.map((e) => e.value).toString(), expected.map((e) => e.value).toString());
    });
  });
}
