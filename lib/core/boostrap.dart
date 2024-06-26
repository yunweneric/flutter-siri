import 'package:flutter/cupertino.dart';
import 'package:flutter_openui/core/app.dart';
import 'package:flutter_openui/core/service_locator.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.register();
  runApp(const Application());
}
