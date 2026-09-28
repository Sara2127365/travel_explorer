
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/localization/app_localizations.dart';
import 'package:travel_explorer/core/localstorage/theme_local_data_source.dart';
import 'package:travel_explorer/core/notifications/fcm_service.dart';
import 'package:travel_explorer/core/notifications/notification_service.dart';
import 'package:travel_explorer/core/routes/app_navigator.dart';
import 'package:travel_explorer/core/routes/app_router.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/theme_cubit.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/locale_cubit.dart';
import 'package:travel_explorer/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');

  // Local notifications
  await NotificationService.init();

  // Firebase Cloud Messaging
  await FcmService.init();

  await setupGetIt();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(
            ThemeLocalDataSource(),
          ),
        ),
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
      ],
      child: const TravelExplor(),
    ),
  );
}

class TravelExplor extends StatelessWidget {
  const TravelExplor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              navigatorKey: navigatorKey,

              // Theme
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,

              // Localization
              locale: locale,

              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],

              localizationsDelegates: const [
                 AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              initialRoute: AppRoutes.registerScreen,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      },
    );
  }
}

