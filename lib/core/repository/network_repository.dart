import 'package:revive_reads/core/network/network_connectivity.dart';

class NetworkRepository {
  final NetworkConnectivity _networkConnectivity;

  NetworkRepository(this._networkConnectivity);

  Stream<NetworkStatus> get networkStatus => _networkConnectivity.networkStatus;

  Future<bool> isConnected() async {
    final status = await _networkConnectivity.checkConnectivity();
    return status == NetworkStatus.online;
  }
}