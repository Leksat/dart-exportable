import 'package:junitconfiguration/junitconfiguration.dart';

import 'src/simple.dart';
import 'src/lists.dart';
import 'src/maps.dart';
import 'src/nested.dart';

main() {
  JUnitConfiguration.install();
  (new Simple()).call();
  (new Lists()).call();
  (new Maps()).call();
  (new Nested()).call();
}