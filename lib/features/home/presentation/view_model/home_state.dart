import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:revive_reads/features/account/presentation/view/account_view.dart';
import 'package:revive_reads/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:revive_reads/features/message/presentation/view/message_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        Center(
          child: DashboardView(),
        ),
        const Center(
          child: MessageView(),
        ),
        const Center(
          child: Text('Sell'),
        ),
        const Center(
          child: Text('My Ads'),
        ),
        const Center(
          child: AccountView(),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
