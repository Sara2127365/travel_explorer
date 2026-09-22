import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_explorer/core/networking/dio_factory.dart';
import 'package:travel_explorer/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:travel_explorer/feature/auth/data/repo/auth_repo.dart';
import 'package:travel_explorer/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_explorer/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:travel_explorer/feature/home/data/datasource/image_remote_data_source.dart';
import 'package:travel_explorer/feature/home/data/repo/home_repo.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_cubit.dart';

GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio
  DioFactory dioFactory = DioFactory();

  dioFactory.init();

  getIt.registerLazySingleton<Dio>(
    () => dioFactory.dio,
  );

  // Firebase 
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
getIt.registerLazySingleton<FirebaseFirestore>(
  () => FirebaseFirestore.instance,
);
  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt(),getIt()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt()),
  );

  // Images
  getIt.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt()),
  );
}