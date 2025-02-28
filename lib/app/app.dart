import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/core/network/bloc/network_bloc.dart';
import 'package:revive_reads/core/network/bloc/network_event.dart';
import 'package:revive_reads/core/theme/app_theme.dart';
import 'package:revive_reads/features/account/presentation/view_model/account_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_bloc.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_bloc.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_cubit.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_bloc.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_bloc.dart';
import 'package:revive_reads/features/single_book/presentation/view_model/book_detail_bloc.dart';
import 'package:revive_reads/features/splash/presentation/view/splash_view.dart';
import 'package:revive_reads/features/splash/presentation/view_model/splash_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkBloc>(
          create: (_) => getIt<NetworkBloc>()..add(NetworkObserveEvent()),
        ),
        BlocProvider<SplashCubit>(create: (_) => getIt<SplashCubit>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<RegisterBloc>(create: (_) => getIt<RegisterBloc>()),
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<AccountBloc>(create: (_) => getIt<AccountBloc>()),
        BlocProvider<BookBloc>(
          create: (_) {
            final bloc = getIt<BookBloc>();
            bloc.add(FetchBooksEvent()); // Dispatch event after creation
            return bloc;
          },
        ),
        BlocProvider<BookDetailBloc>(create: (_) => getIt<BookDetailBloc>()),
        BlocProvider<PostBookBloc>(create: (_) => getIt<PostBookBloc>()),
        BlocProvider<NotificationBloc>(
            create: (_) => getIt<NotificationBloc>()),
        BlocProvider<MessageBloc>(
          create: (context) => getIt<MessageBloc>(),
        ),
        BlocProvider<EditBookBloc>(
          create: (context) => getIt<EditBookBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Revive Reads',
        theme: getApplicationTheme(),
        home: const SplashView(),
      ),
    );
  }
}
