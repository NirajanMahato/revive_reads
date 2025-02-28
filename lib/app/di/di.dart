import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/network/api_service.dart';
import 'package:revive_reads/core/network/bloc/network_bloc.dart';
import 'package:revive_reads/core/network/hive_service.dart';
import 'package:revive_reads/core/network/network_connectivity.dart';
import 'package:revive_reads/core/repository/network_repository.dart';
import 'package:revive_reads/features/account/data/data_source/account_data_source.dart';
import 'package:revive_reads/features/account/data/data_source/remote_data_source/account_remote_data_source.dart';
import 'package:revive_reads/features/account/data/repositories/account_remote_repository.dart';
import 'package:revive_reads/features/account/domain/repository/account_repository.dart';
import 'package:revive_reads/features/account/domain/use_case/get_account_usecase.dart';
import 'package:revive_reads/features/account/domain/use_case/logout_usecase.dart';
import 'package:revive_reads/features/account/presentation/view_model/account_bloc.dart';
import 'package:revive_reads/features/auth/data/data_source/local_datasource/local_datasource.dart';
import 'package:revive_reads/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:revive_reads/features/auth/data/repositories/user_local_repository.dart';
import 'package:revive_reads/features/auth/data/repositories/user_remote_repository.dart';
import 'package:revive_reads/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:revive_reads/features/auth/domain/use_case/login_usecase.dart';
import 'package:revive_reads/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:revive_reads/features/dashboard/data/data_source/remote_datasource/book_remote_datasource.dart';
import 'package:revive_reads/features/dashboard/data/data_source/remote_datasource/favorite_remote_data_source.dart';
import 'package:revive_reads/features/dashboard/data/repositories/book_remote_repository.dart';
import 'package:revive_reads/features/dashboard/data/repositories/favorite_remote_repository.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/favorite_usecase.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/get_books_usecase.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/search_books_usecase.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_bloc.dart';
import 'package:revive_reads/features/edit_book/data/data_source/edit_book_datasource.dart';
import 'package:revive_reads/features/edit_book/data/data_source/remote_data_source/edit_book_remote_datasource.dart';
import 'package:revive_reads/features/edit_book/data/repositories/edit_remote_book_repository.dart';
import 'package:revive_reads/features/edit_book/domain/repository/edit_book_repository.dart';
import 'package:revive_reads/features/edit_book/domain/use_case/update_book_usecase.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_bloc.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_cubit.dart';
import 'package:revive_reads/features/message/data/data_source/message_data_source.dart';
import 'package:revive_reads/features/message/data/data_source/remote_data_source/message_remote_data_source.dart';
import 'package:revive_reads/features/message/data/data_source/remote_data_source/socket_service.dart';
import 'package:revive_reads/features/message/data/repositories/message_remote_repository.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';
import 'package:revive_reads/features/message/domain/use_case/get_messages_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/get_unread_message_count_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/init_socket_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/send_message_usecase.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_bloc.dart';
import 'package:revive_reads/features/my_ads/data/data_source/my_ads_data_source.dart';
import 'package:revive_reads/features/my_ads/data/data_source/remote_data_source/my_ads_remote_data_source.dart';
import 'package:revive_reads/features/my_ads/data/repositories/my_ads_remote_repository.dart';
import 'package:revive_reads/features/my_ads/domain/repository/my_ads_repository.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/delete_book_usecase.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/get_user_books_usecase.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/mark_as_sold_usecase.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_bloc.dart';
import 'package:revive_reads/features/notification/data/data_source/notification_data_source.dart';
import 'package:revive_reads/features/notification/data/data_source/remote_data_source/notification_remote_data_source.dart';
import 'package:revive_reads/features/notification/data/repositories/notification_remote_repository.dart';
import 'package:revive_reads/features/notification/domain/repositiry/notification_repository.dart';
import 'package:revive_reads/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:revive_reads/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:revive_reads/features/onBoarding/presentation/view_model/onboarding_cubit.dart';
import 'package:revive_reads/features/post_book/data/data_source/remote_data_source/post_book_remote_data_source.dart';
import 'package:revive_reads/features/post_book/data/repositories/post_book_remote_repository.dart';
import 'package:revive_reads/features/post_book/domain/use_case/post_book_usecase.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_bloc.dart';
import 'package:revive_reads/features/single_book/data/data_source/book_detail_datasource.dart';
import 'package:revive_reads/features/single_book/data/data_source/remote_datasource/book_detail_remote_data_source.dart';
import 'package:revive_reads/features/single_book/data/repositories/book_detail_remote_repository.dart';
import 'package:revive_reads/features/single_book/domain/repository/book_detail_repository.dart';
import 'package:revive_reads/features/single_book/domain/use_case/get_book_detail_use_case.dart';
import 'package:revive_reads/features/single_book/presentation/view_model/book_detail_bloc.dart';
import 'package:revive_reads/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  initNetworkDependencies();
  await _initSharedPreferences();
  await _initHiveService();
  await _initApiService();

  await _initHomeDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initBookDependencies();
  await _initMessageFeature();
  await _initMyAdsFeature();
  await _initNotificationFeature();
  _initPostBookFeatureDependencies();
  _initEditBookFeature();
  _initBookDetailFeatureDependencies();
  _initAccountDependencies();

  await _initOnBoardingScreenDependencies();
  await _initSplashScreenDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initHiveService() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

void initNetworkDependencies() {
  final networkConnectivity = NetworkConnectivity();
  networkConnectivity.initialize();
  getIt.registerLazySingleton<NetworkConnectivity>(() => networkConnectivity);

  // NetworkRepository before NetworkBloc
  getIt.registerLazySingleton<NetworkRepository>(
    () => NetworkRepository(getIt<NetworkConnectivity>()),
  );

  // NetworkBloc
  getIt.registerSingleton<NetworkBloc>(
    NetworkBloc(getIt<NetworkRepository>()),
  );
}

_initRegisterDependencies() async {
  // Local Data Source
  getIt
      .registerFactory<UserLocalDataSource>(() => UserLocalDataSource(getIt()));

  // Remote Data Source
  getIt.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSource(getIt<Dio>()));

  // Local Repository
  getIt.registerLazySingleton<UserLocalRepository>(() =>
      UserLocalRepository(userLocalDataSource: getIt<UserLocalDataSource>()));

  // Remote Repository
  getIt.registerLazySingleton<UserRemoteRepository>(
      () => UserRemoteRepository(getIt<UserRemoteDataSource>()));

  // Usecases
  getIt.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(userRepository: getIt<UserRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(
      getIt<UserRemoteRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      createUserUsecase: getIt<CreateUserUsecase>(),
      uploadImageUsecase: getIt<UploadImageUsecase>(),
    ),
  );
}

_initOnBoardingScreenDependencies() async {
  getIt.registerFactory(
    () => OnboardingCubit(getIt<LoginBloc>()),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

void _initAccountDependencies() {
  // Data Sources
  getIt.registerLazySingleton<IAccountDataSource>(
    () => AccountRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<IAccountRepository>(
    () => AccountRemoteRepository(
      getIt<IAccountDataSource>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetAccountUseCase>(
    () => GetAccountUseCase(getIt<IAccountRepository>()),
  );

  // LogoutUseCase
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<TokenSharedPrefs>()),
  );

  // Bloc
  getIt.registerFactory<AccountBloc>(
    () => AccountBloc(
      getAccountUseCase: getIt<GetAccountUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
}

_initLoginDependencies() async {
  // =========================== Token Shared Preferences ===========================
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(
      getIt<UserRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUsecase: getIt<LoginUsecase>(),
    ),
  );
}

void _initPostBookFeatureDependencies() {
  getIt.registerLazySingleton<PostBookRemoteDataSource>(
      () => PostBookRemoteDataSource(getIt<Dio>()));

  getIt.registerLazySingleton<PostBookRemoteRepository>(
      () => PostBookRemoteRepository(getIt<PostBookRemoteDataSource>()));

  getIt.registerLazySingleton<PostBookUseCase>(
      () => PostBookUseCase(getIt<PostBookRemoteRepository>()));

  getIt.registerFactory<PostBookBloc>(
    () => PostBookBloc(
      getIt<PostBookUseCase>(),
      getIt<TokenSharedPrefs>(),
    ),
  );
}

void _initEditBookFeature() {
  // Data Source
  getIt.registerLazySingleton<IEditBookDataSource>(
    () => EditBookRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<IEditBookRepository>(
    () => EditBookRepository(getIt<IEditBookDataSource>()),
  );

  // Use Case
  getIt.registerLazySingleton<UpdateBookUseCase>(
    () => UpdateBookUseCase(getIt<IEditBookRepository>()),
  );

  // Bloc
  getIt.registerFactory<EditBookBloc>(
    () => EditBookBloc(
      updateBookUseCase: getIt<UpdateBookUseCase>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );
}

Future<void> _initBookDependencies() async {
  // Remote Data Sources
  getIt.registerFactory<BookRemoteDataSource>(
    () => BookRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerFactory<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSource(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<BookRemoteRepository>(
    () => BookRemoteRepository(getIt<BookRemoteDataSource>()),
  );

  getIt.registerLazySingleton<FavoriteRemoteRepository>(
    () => FavoriteRemoteRepository(getIt<FavoriteRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetBooksUseCase>(
    () => GetBooksUseCase(getIt<BookRemoteRepository>()),
  );

  getIt.registerLazySingleton<SearchBooksUseCase>(
    () => SearchBooksUseCase(getIt<BookRemoteRepository>()),
  );

  // Add Favorite Use Cases
  getIt.registerLazySingleton<AddToFavoritesUseCase>(
    () => AddToFavoritesUseCase(getIt<FavoriteRemoteRepository>()),
  );

  getIt.registerLazySingleton<RemoveFromFavoritesUseCase>(
    () => RemoveFromFavoritesUseCase(getIt<FavoriteRemoteRepository>()),
  );

  // Bloc
  getIt.registerFactory<BookBloc>(
    () => BookBloc(
      getBooksUseCase: getIt<GetBooksUseCase>(),
      addToFavoritesUseCase: getIt<AddToFavoritesUseCase>(),
      removeFromFavoritesUseCase: getIt<RemoveFromFavoritesUseCase>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );
}

Future<void> _initMessageFeature() async {
  // Register socket service as singleton
  getIt.registerLazySingleton<SocketService>(() => SocketService());

  // Data Source
  getIt.registerLazySingleton<IMessageDataSource>(
    () => MessageRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<IMessageRepository>(
    () => MessageRemoteRepository(
      getIt<IMessageDataSource>(),
      getIt<TokenSharedPrefs>(),
      getIt<SocketService>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(getIt<IMessageRepository>()),
  );

  getIt.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(getIt<IMessageRepository>()),
  );

  getIt.registerLazySingleton<GetUnreadMessageCountUseCase>(
    () => GetUnreadMessageCountUseCase(getIt<IMessageRepository>()),
  );

  getIt.registerLazySingleton<InitSocketUseCase>(
    () => InitSocketUseCase(getIt<IMessageRepository>()),
  );

  // Bloc
  getIt.registerFactory<MessageBloc>(
    () => MessageBloc(
      getMessagesUseCase: getIt<GetMessagesUseCase>(),
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      getUnreadMessageCountUseCase: getIt<GetUnreadMessageCountUseCase>(),
      initSocketUseCase: getIt<InitSocketUseCase>(),
      messageRepository: getIt<IMessageRepository>(),
    ),
  );
}

Future<void> _initMyAdsFeature() async {
  // Data Sources
  getIt.registerLazySingleton<IMyAdsDataSource>(
    () => MyAdsRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<IMyAdsRepository>(
    () => MyAdsRemoteRepository(
      getIt<IMyAdsDataSource>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
      () => GetUserBooksUseCase(getIt<IMyAdsRepository>()));
  getIt.registerLazySingleton(
      () => DeleteBookUseCase(getIt<IMyAdsRepository>()));
  getIt.registerLazySingleton(
      () => MarkAsSoldUseCase(getIt<IMyAdsRepository>()));

  // Bloc
  getIt.registerFactory(
    () => MyAdsBloc(
      getUserBooksUseCase: getIt<GetUserBooksUseCase>(),
      deleteBookUseCase: getIt<DeleteBookUseCase>(),
      markAsSoldUseCase: getIt<MarkAsSoldUseCase>(),
    ),
  );
}

Future<void> _initNotificationFeature() async {
  // Data Sources
  getIt.registerLazySingleton<INotificationDataSource>(
    () => NotificationRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<INotificationRepository>(
    () => NotificationRemoteRepository(
      getIt<INotificationDataSource>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetNotificationsUseCase(getIt<INotificationRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkAsReadUseCase(getIt<INotificationRepository>()),
  );

  // Bloc
  getIt.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      markAsReadUseCase: getIt<MarkAsReadUseCase>(),
    ),
  );
}

void _initBookDetailFeatureDependencies() {
  getIt.registerLazySingleton<IBookDetailDataSource>(
      () => BookDetailRemoteDataSource(getIt<Dio>()));

  getIt.registerLazySingleton<IBookDetailRepository>(
      () => BookDetailRemoteRepository(getIt<IBookDetailDataSource>()));

  getIt.registerLazySingleton<GetBookDetailUseCase>(
      () => GetBookDetailUseCase(getIt<IBookDetailRepository>()));

  getIt.registerFactory<BookDetailBloc>(
      () => BookDetailBloc(getIt<GetBookDetailUseCase>()));
}

_initSplashScreenDependencies() async {
  getIt.registerFactory(
    () => SplashCubit(getIt<OnboardingCubit>()),
  );
}
