import 'package:junitconfiguration/junitconfiguration.dart';

import 'src/simple.dart';
import 'src/lists.dart';
import 'src/maps.dart';
import 'src/nested.dart';
import 'src/missing.dart';

/**
 * This tests file is for continuous integrations with JUnit compartible xml result.
 * Should be run something like `pub run test/junit.dart > junit.xml`
 */
main() {
  JUnitConfiguration.install();
  (new Simple()).call();
  (new Lists()).call();
  (new Maps()).call();
  (new Nested()).call();
  (new Missing()).call();
}