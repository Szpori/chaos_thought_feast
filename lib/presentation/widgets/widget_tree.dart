import 'package:chaos_thought_feast/presentation/screens/login_register_screen.dart';
import 'package:chaos_thought_feast/presentation/screens/main_menu_activity.dart';
import 'package:flutter/cupertino.dart';

import '../../locator.dart';
import '../../services/fire_db_auth_service.dart';
import '../../services/navigation_service.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainMenuActivity(navigationService: locator<NavigationService>());
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}