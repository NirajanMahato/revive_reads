import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkConnectivity {
  // Singleton pattern
  static final NetworkConnectivity _instance = NetworkConnectivity._internal();
  factory NetworkConnectivity() => _instance;
  NetworkConnectivity._internal();

  // Stream controller for network status
  final _networkStatusController = StreamController<NetworkStatus>.broadcast();
  Stream<NetworkStatus> get networkStatus => _networkStatusController.stream;

  // Stream subscription to listen for connectivity changes
  StreamSubscription? _connectivitySubscription;

  // Initialize network connectivity monitoring
  void initialize() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Check if there is any network connection
      final isConnected =
          results.any((result) => result != ConnectivityResult.none);

      if (isConnected) {
        _networkStatusController.add(NetworkStatus.online);
      } else {
        _networkStatusController.add(NetworkStatus.offline);
      }
    });

    // Check initial connectivity
    checkConnectivity();
  }

  // Check current connectivity status
  Future<NetworkStatus> checkConnectivity() async {
    final List<ConnectivityResult> results =
        await Connectivity().checkConnectivity();
    final isConnected =
        results.any((result) => result != ConnectivityResult.none);
    final status = isConnected ? NetworkStatus.online : NetworkStatus.offline;

    _networkStatusController.add(status);
    return status;
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
