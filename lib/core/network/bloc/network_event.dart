// lib/core/network/bloc/network_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:revive_reads/core/network/network_connectivity.dart';

// Events
abstract class NetworkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkObserveEvent extends NetworkEvent {}

class NetworkStatusChangedEvent extends NetworkEvent {
  final NetworkStatus status;

  NetworkStatusChangedEvent(this.status);

  @override
  List<Object?> get props => [status];
}
