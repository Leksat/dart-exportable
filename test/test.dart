import 'package:unittest/unittest.dart';
import 'package:exportable/exportable.dart';

void main() {
  test('TEST', () {
    expect(identical(1, 1), isTrue);
    expect(identical(1, 1.0), isFalse);
  });
}
