import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/provider/auth_notifier.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  const RegisterScreen({super.key, required this.toggleView});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create an Account',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Join us to get started',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 32.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      if (authNotifier.state == AuthState.loading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authNotifier.register(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      if (authNotifier.state == AuthState.error &&
                          authNotifier.failure != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            authNotifier.failure!.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () => widget.toggleView(),
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
