import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._registerBloc) : super(null);

  final RegisterBloc _registerBloc;

  Future<void> init(BuildContext context) async {
    // Simulate a 2-second delay
    await Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        // Navigate to the Onboarding Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _registerBloc,
              child: const RegisterView(),
            ),
          ),
        );
      }
    });
  }
}
