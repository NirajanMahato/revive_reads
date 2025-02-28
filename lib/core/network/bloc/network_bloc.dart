import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revive_reads/core/network/bloc/network_event.dart';
import 'package:revive_reads/core/network/network_connectivity.dart';
import 'package:revive_reads/core/repository/network_repository.dart';

part 'network_state.dart';

// BLoC
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkRepository _networkRepository;
  late StreamSubscription _networkSubscription;

  NetworkBloc(this._networkRepository) : super(NetworkInitial()) {
    on<NetworkObserveEvent>(_onObserve);
    on<NetworkStatusChangedEvent>(_onStatusChanged);
  }

  void _onObserve(NetworkObserveEvent event, Emitter<NetworkState> emit) {
    _networkSubscription = _networkRepository.networkStatus.listen((status) {
      add(NetworkStatusChangedEvent(status));
    });
  }

  void _onStatusChanged(
      NetworkStatusChangedEvent event, Emitter<NetworkState> emit) {
    if (event.status == NetworkStatus.online) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }

  @override
  Future<void> close() {
    _networkSubscription.cancel();
    return super.close();
  }
}
