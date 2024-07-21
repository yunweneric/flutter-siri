import 'dart:io';

class AppConfig {
  static late String apiKey;
  static init() async {
    final key = Platform.environment['API_KEY'];
    if (key == null) {
      throw Exception("No api key");
    }
    apiKey = key;
  }
}
