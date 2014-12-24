import 'package:unittest/unittest.dart';
import 'package:test_toolkit/test_toolkit.dart';

import 'package:exportable/exportable.dart';
import 'dart:convert' show JSON;

/**
 * Tests for different situations with Lists
 */
@groupdoc('Lists of different kinds')
class Lists extends TestGroup {

  void setUp() {
  }

  @testdoc('List of strings')
  void testStrings() {
    var testFrom = new ListOfStrings()
      ..value = ["str1", "str2", null];
    var testTo = new ListOfStrings()
      ..initFromJson(testFrom.toJson());
    expect(testTo.value, equals(testFrom.value));
    expect(testFrom.toJson(), equals('{"value":["str1","str2",null]}'));
  }

  @testdoc('List of numbers')
  void testNumber() {
    var testFrom = new ListOfNumbers()
      ..integers = [1, 2, null]
      ..floats = [1.2, 2.3, null]
      ..mixed = [1, 2.3, null];
    var testTo = new ListOfNumbers()
      ..initFromJson(testFrom.toJson());
    expect(testTo.integers, equals(testFrom.integers));
    expect(testTo.floats, equals(testFrom.floats));
    expect(testTo.mixed, equals(testFrom.mixed));
    expect(testFrom.toJson(), equals('{"integers":[1,2,null],"floats":[1.2,2.3,null],"mixed":[1,2.3,null]}'));
  }

  @testdoc('List of booleans')
  void testBoolean() {
    var testFrom = new ListOfBoolean()
      ..booleans = [true, false, null];
    var testTo = new ListOfBoolean()
      ..initFromJson(testFrom.toJson());
    expect(testTo.booleans, equals(testFrom.booleans));
    expect(testFrom.toJson(), equals('{"booleans":[true,false,null]}'));
  }

  @testdoc('Plain List of Exportables')
  void testExportablesPlain() {
    var testFrom = [
        new ExportableListItem()
          ..number = 1
          ..string = "str1",
        new ExportableListItem()
          ..number = 2
          ..string = "str2",
        null
    ];
    List<String> test = JSON.decode(JSON.encode(testFrom));
    List<ExportableListItem> testTo = test.map((item) => (item == null)?null:(new ExportableListItem()..initFromJson(item))).toList();
    expect(testTo, equals(testFrom));
    expect(JSON.encode(testFrom), equals('[{"number":1,"string":"str1"},{"number":2,"string":"str2"},null]'));
  }

  @testdoc('List of Exportables as field')
  void testExportablesField() {
    var testFrom = new ListOfExportables()
      ..values = [
        new ExportableListItem()
          ..number = 1
          ..string = "str1",
        new ExportableListItem()
          ..number = 2
          ..string = "str2",
        null
    ];
    var testTo = new ListOfExportables()
      ..initFromJson(testFrom.toJson());
    expect(testTo.values, equals(testFrom.values));
    expect(testFrom.toJson(), equals('{"values":[{"number":1,"string":"str1"},{"number":2,"string":"str2"},null]}'));
  }

  void tearDown() {
  }

}

@Export(ListOfStrings)
class ListOfStrings extends Object with Exportable {
  @export List<String> value;
}

@Export(ListOfNumbers)
class ListOfNumbers extends Object with Exportable {
  @export List<num> integers;
  @export List<num> floats;
  @export List<num> mixed;
}

@Export(ListOfBoolean)
class ListOfBoolean extends Object with Exportable {
  @export List<bool> booleans;
}

@Export(ExportableListItem)
class ExportableListItem extends Object with Exportable {
  @export num number;
  @export String string;
}

@Export(ListOfExportables)
class ListOfExportables extends Object with Exportable {
  @export List<ExportableListItem> values;
}
