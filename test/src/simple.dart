import 'package:unittest/unittest.dart';
import 'package:test_toolkit/test_toolkit.dart';

import 'package:exportable/exportable.dart';

/**
 * Tests for simple JSON.convert() supported types
 */
@groupdoc('Simple field types')
class Simple extends TestGroup {

  void setUp() {
  }

  @testdoc('String fields')
  void testStrings() {
    var testFrom = new SimpleStrings()
      ..value = "Some Value";
    var testTo = new SimpleStrings()
      ..initFromJson(testFrom.toJson());
    expect(testTo.value, equals(testFrom.value));
    expect(testFrom.toJson(), equals('{"value":"Some Value"}'));
  }

  @testdoc('Number fields')
  void testNumber() {
    var testFrom = new SimpleNumbers()
      ..integer = 5
      ..float = 3.1415;
    var testTo = new SimpleNumbers()
      ..initFromJson(testFrom.toJson());
    expect(testTo.integer, equals(testFrom.integer));
    expect(testTo.float, equals(testFrom.float));
    expect(testFrom.toJson(), equals('{"integer":5,"float":3.1415}'));
  }

  @testdoc('Boolean fields')
  void testBoolean() {
    var testFrom = new SimpleBoolean();
    var testTo = new SimpleBoolean()
      ..initFromJson(testFrom.toJson());
    expect(testTo.trueValue, equals(testFrom.trueValue));
    expect(testTo.falseValue, equals(testFrom.falseValue));
    expect(testFrom.toJson(), equals('{"trueValue":true,"falseValue":false}'));
  }

  @testdoc('Nullable fields')
  void testNullable() {
    var testFrom = new SimpleNull()
      ..notNullValue = "some";
    var testTo = new SimpleNull()
      ..initFromJson(testFrom.toJson());
    expect(testTo.notNullValue, equals("some"));
    expect(testTo.nullValue, equals(null));
    expect(testFrom.toJson(), equals('{"notNullValue":"some","nullValue":null}'));
  }

  void tearDown() {
  }

}

@Export(SimpleStrings)
class SimpleStrings extends Object with Exportable {
  @export String value;
}

@Export(SimpleNumbers)
class SimpleNumbers extends Object with Exportable {
  @export num integer;
  @export num float;
}

@Export(SimpleBoolean)
class SimpleBoolean extends Object with Exportable {
  @export bool trueValue = true;
  @export bool falseValue = false;
}

@Export(SimpleNull)
class SimpleNull extends Object with Exportable {
  @export String notNullValue = "some";
  @export String nullValue = null;
}
