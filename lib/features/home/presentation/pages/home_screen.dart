import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/provider/auth_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authNotifier.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16.0),
            if (authNotifier.user != null)
              Text(
                authNotifier.user!.name ?? "User",
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
