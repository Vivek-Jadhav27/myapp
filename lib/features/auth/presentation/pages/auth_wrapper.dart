import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/pages/login_screen.dart';
import 'package:myapp/features/auth/presentation/pages/register_screen.dart';
import 'package:myapp/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:myapp/features/auth/presentation/provider/auth_notifier.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    // return either the Home or Authenticate widget
    if (authNotifier.user == null) {
      if (showSignIn) {
        return LoginScreen(toggleView: toggleView);
      } else {
        return RegisterScreen(toggleView: toggleView);
      }
    } else {
      return const TransactionsScreen();
    }
  }
}
