
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/screens/calendar/calendar_screen.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: const CalendarScreen(),
    );
  }
}
