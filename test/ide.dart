import 'src/simple.dart';
import 'src/lists.dart';
import 'src/maps.dart';
import 'src/nested.dart';
import 'src/missing.dart';

/**
 * This tests file is prepared to be run with IDE test runner (for example IntelliJ IDEA)
 */
main() {
  new Simple().groupRun();
  new Lists().groupRun();
  new Maps().groupRun();
  new Nested().groupRun();
  new Missing().groupRun();
}