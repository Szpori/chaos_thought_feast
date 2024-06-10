import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/fire_db_auth_service.dart';
import '../../services/language_manager.dart';
import '../../services/language_notifier.dart';
import '../../utils/StringUtils.dart';

class ProfileScreen extends StatefulWidget {
  final LanguageNotifier languageNotifier;

  ProfileScreen({Key? key, required this.languageNotifier}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = AuthService().getCurrentUser();

  Future<void> signOut(BuildContext context) async {
    try {
      await AuthService().signOut();
      Navigator.of(context).pop();
    } catch (e) {
      // Handle error
    }
  }

  Widget _title() {
    return const Text('Your Profile');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      child: const Text('Sign Out'),
    );
  }

  Widget _languageSwitch() {
    return ValueListenableBuilder<String>(
      valueListenable: widget.languageNotifier,
      builder: (context, value, child) {
        return DropdownButton<String>(
          value: value,
          onChanged: (String? newValue) {
            if (newValue != null) {
              widget.languageNotifier.setLanguage(newValue);
            }
          },
          items: <String>['English', 'Polish'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            const SizedBox(height: 20),
            _languageSwitch(),
            const SizedBox(height: 20),
            _signOutButton(context),
          ],
        ),
      ),
    );
  }
}