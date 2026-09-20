import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/routes/app_router.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mahjrsdfodssvftazlhu.supabase.co',
    publishableKey: 'sb_publishable_izeIyPrWereHiVXoXWYcOg_ADlikzNg',
  );

  await setupGetIt();

  runApp(const TravelExplor());
}

class TravelExplor extends StatelessWidget {
  const TravelExplor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: AppRoutes.registerScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}