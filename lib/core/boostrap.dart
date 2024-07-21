import 'package:flutter/cupertino.dart';
import 'package:flutter_openui/core/app.dart';
import 'package:flutter_openui/core/config.dart';
import 'package:flutter_openui/core/service_locator.dart';

void bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  await ServiceLocator.register();
  runApp(const Application());
}
