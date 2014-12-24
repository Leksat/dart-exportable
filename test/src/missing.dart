import 'package:unittest/unittest.dart';
import 'package:test_toolkit/test_toolkit.dart';

import 'package:exportable/exportable.dart';

/**
 * Missing model fields should initFromJson() to nulls/default values without errors
 */
@groupdoc('Missing fields')
class Missing extends TestGroup {

  void setUp() {
  }

  @testdoc('String fields')
  void testStrings() {
    var testTo = new MissingStrings()
      ..initFromJson('{"value":"Some Value"}');
    expect(testTo.value, equals("Some Value"));
    expect(testTo.missing, equals(null));
    expect(testTo.missingDef, equals("missing"));
  }

  @testdoc('Number fields')
  void testNumber() {
    var testTo = new MissingNumbers()
      ..initFromJson('{"integer":5,"float":3.1415}');
    expect(testTo.integer, equals(5));
    expect(testTo.float, equals(3.1415));
    expect(testTo.missing, equals(null));
    expect(testTo.missingDef, equals(111));
  }

  @testdoc('Boolean fields')
  void testBoolean() {
    var testTo = new MissingBoolean()
      ..initFromJson('{"trueValue":true,"falseValue":false}');
    expect(testTo.trueValue, equals(true));
    expect(testTo.falseValue, equals(false));
    expect(testTo.missing, equals(null));
    expect(testTo.missingDef, equals(true));
  }

  void tearDown() {
  }

}

@Export(MissingStrings)
class MissingStrings extends Object with Exportable {
  @export String value;
  @export String missing;
  @export String missingDef = "missing";
}

@Export(MissingNumbers)
class MissingNumbers extends Object with Exportable {
  @export num integer;
  @export num float;
  @export num missing;
  @export num missingDef = 111;
}

@Export(MissingBoolean)
class MissingBoolean extends Object with Exportable {
  @export bool trueValue = true;
  @export bool falseValue = false;
  @export bool missing;
  @export bool missingDef = true;
}

