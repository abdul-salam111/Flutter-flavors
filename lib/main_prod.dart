import 'package:flutter/cupertino.dart';
import 'package:flutter_flavors_project/common_main.dart';
import 'package:flutter_flavors_project/flavors_config/flavors_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setEnvironment(Environment.prod);
  commonMain();
}
