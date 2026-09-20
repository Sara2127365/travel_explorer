import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_explorer/core/networking/dio_factory.dart';
import 'package:travel_explorer/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:travel_explorer/feature/auth/data/repo/auth_repo.dart';
import 'package:travel_explorer/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_explorer/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:travel_explorer/feature/home/data/repo/home_repo.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_cubit.dart';

GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  DioFactory dioFactory = DioFactory();

  dioFactory.init();

  getIt.registerLazySingleton<Dio>(() => dioFactory.dio);
  

  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
  () => AuthRepo(getIt<AuthRemoteDataSource>()),
);

getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );

   getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(getIt()),
  );
  getIt.registerFactory<HomeCubit>(
  () => HomeCubit(getIt()),
);
}
