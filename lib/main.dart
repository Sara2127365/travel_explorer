import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/routes/app_router.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await dotenv.load(fileName: '.env');
 
 await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
 await Hive.initFlutter();
  await Hive.openBox('favoritesBox');

  

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