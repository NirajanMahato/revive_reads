import 'package:flutter/material.dart';
import 'package:revive_reads/app/app.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  await initDependencies();
  runApp(const MyApp());
}
