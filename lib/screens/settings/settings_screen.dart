
import 'package:flutter/material.dart';
import 'package:myapp/screens/settings/manage_categories.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
