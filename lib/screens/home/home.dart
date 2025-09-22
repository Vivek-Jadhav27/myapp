
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/screens/analysis/analysis_screen.dart';
import 'package:myapp/screens/calendar/calendar_screen.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const CalendarScreen(),
    const AnalysisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Finance Tracker' : 'Spending Analysis'),
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
        ],
      ),
    );
  }
}
