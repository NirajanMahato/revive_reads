import 'package:flutter/material.dart';
import 'package:revive_reads/app/app.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/core/network/bloc/network_bloc.dart';
import 'package:revive_reads/core/network/bloc/network_event.dart';
import 'package:revive_reads/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();
  
  await initDependencies();

  getIt<NetworkBloc>().add(NetworkObserveEvent());
  runApp(const MyApp());
}
