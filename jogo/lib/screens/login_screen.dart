import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'modules_screen.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;


// For MVP we do a local mock login — no backend.
  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(Duration(milliseconds: 600));
    Navigator.pushReplacementNamed(context, ModulesScreen.routeName);
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loc.translate('login_title'), style: TextStyle(fontSize: 22)) ,
              SizedBox(height: 12),
              TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: loc.translate('email'))),
              SizedBox(height: 8),
              TextField(controller: _passCtrl, obscureText: true, decoration: InputDecoration(labelText: loc.translate('password'))),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _loading ? null : _login, child: Text(loc.translate('login'))),
            ],
          ),
        ),
      ),
    );
  }
}