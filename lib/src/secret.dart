import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secret {
  final String zoomato_api;  
  Secret({this.zoomato_api = ""});  
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    var secret = new Secret(zoomato_api: jsonMap["zoomato_api"]);
    return secret;
  }
}

class SecretLoader {
  final String secretPath;
  SecretLoader({this.secretPath});  
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
