import 'package:nxpress/src/models/nxpress_config.dart';
import 'package:nxpress/src/models/nxpress_resource.dart';

class NxString extends NxpressResource {
  NxString(Map<String, Object> keys) : super(keys: keys);

  String text({Map<String, Object>? placeholders}) {
    var content = getStringValue(NxConfig.lang);

    if (placeholders != null) {
      return setPlaceholders(content, placeholders);
    }

    return content;
  }

  String plural(int quantity, {Map<String, Object>? placeholders}) {
    var content = getListValue(NxConfig.lang)[quantity];
    if (placeholders != null) return setPlaceholders(content, placeholders);
    return content;
  }
}
