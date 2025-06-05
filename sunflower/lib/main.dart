import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sunflower/app/my_app.dart';
import 'package:sunflower/app/models/app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appModel = AppModel();
  await appModel.init();

  runApp(SunFlowerApp(appModel: appModel));
}
