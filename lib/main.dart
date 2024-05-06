import 'package:chaos_thought_feast/constants/strings.dart';
import 'package:chaos_thought_feast/presentation/widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainMenuApp());
}

class MainMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.chaosThoughtFeast,
      navigatorKey: navigationService.navigatorKey,
      home: const WidgetTree(),
    );
  }
}