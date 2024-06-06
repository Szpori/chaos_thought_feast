import 'package:chaos_thought_feast/constants/strings.dart';
import 'package:chaos_thought_feast/presentation/widgets/widget_tree.dart';
import 'package:chaos_thought_feast/services/fire_db_auth_service.dart';
import 'package:chaos_thought_feast/services/fire_db_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chaos_thought_feast/services/navigation_service.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up the service locator
  setupLocator();

  runApp(MainMenuApp());
}

class MainMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.chaosThoughtFeast,
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: const WidgetTree(),
    );
  }
}