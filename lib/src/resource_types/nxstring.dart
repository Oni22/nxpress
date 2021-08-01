import 'package:nxpress/src/models/nxpress_config.dart';
import 'package:nxpress/src/models/nxpress_resource.dart';

class NxString extends NxpressResource {
  NxString(Map<String, Object> keys) : super(keys: keys);

  String text({Map<String, Object>? placeholders}) {
    var content = getStringValue(NxConfig.lang);

    if (placeholders != null) {
      placeholders.forEach((name, value) {
        content = setPlaceholder(content, name, value.toString());
      });
    }

    return content;
  }
}
