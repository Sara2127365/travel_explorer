import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/feature/auth/presentation/ui/forget_password_screen.dart';
import 'package:travel_explorer/feature/auth/presentation/ui/login_screen.dart';
import 'package:travel_explorer/feature/auth/presentation/ui/sign_up_screen.dart';
import 'package:travel_explorer/feature/fav/presentation/cubit/fav_cubit.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_cubit.dart';
import 'package:travel_explorer/feature/home/presentation/ui/home_screen.dart';
import 'package:travel_explorer/feature/mainnavigation/presentation/ui/main_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.forgetpasswordScreen:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
        );

      case AppRoutes.mainScreen:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>(
                create: (_) => getIt<HomeCubit>()..getPLaces(),
              ),
              BlocProvider<FavoritesCubit>(
                create: (_) => getIt<FavoritesCubit>()..loadFavorites(),
              ),
            ],
            child: const HomeScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}