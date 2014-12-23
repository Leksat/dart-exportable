import 'package:unittest/html_enhanced_config.dart';

import 'src/simple.dart';
import 'src/lists.dart';
import 'src/maps.dart';
import 'src/nested.dart';

/**
 * This tests file is for default Dartium test runner served by `pub serve`. (Works in pair with index.html)
 */
main() {
  useHtmlEnhancedConfiguration();
  (new Simple()).call();
  (new Lists()).call();
  (new Maps()).call();
  (new Nested()).call();
}