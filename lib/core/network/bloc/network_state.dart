part of 'network_bloc.dart';

// States
abstract class NetworkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {}

class NetworkDisconnected extends NetworkState {}
