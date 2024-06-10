import 'package:chaos_thought_feast/constants/strings.dart';
import 'package:chaos_thought_feast/presentation/screens/profile_screen.dart';
import 'package:chaos_thought_feast/presentation/widgets/main_menu_screen.dart';
import 'package:chaos_thought_feast/presentation/widgets/widget_tree.dart';
import 'package:chaos_thought_feast/services/fire_db_auth_service.dart';
import 'package:chaos_thought_feast/services/fire_db_service.dart';
import 'package:chaos_thought_feast/services/language_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chaos_thought_feast/services/navigation_service.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  runApp(MyApp(
    navigationService: locator<NavigationService>(),
    languageNotifier: locator<LanguageNotifier>(),
  ));
}

class MyApp extends StatelessWidget {
  final NavigationService navigationService;
  final LanguageNotifier languageNotifier;

  MyApp({
    required this.navigationService,
    required this.languageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigationService.navigatorKey,
      home: WidgetTree(),
    );
  }
}