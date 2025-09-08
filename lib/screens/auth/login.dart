import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/services/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({super.key, required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Register'),
            onPressed: () => widget.toggleView(),
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Sign in to your account',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: !_isPasswordVisible,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter a password';
                    }
                    if (val.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    if (!val.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain an uppercase letter';
                    }
                    if (!val.contains(RegExp(r'[a-z]'))) {
                      return 'Password must contain a lowercase letter';
                    }
                    if (!val.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain a number';
                    }
                    if (!val.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                      return 'Password must contain a special character';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                authProvider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        child: const Text('Sign In'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.signIn(email, password);
                          }
                        },
                      ),
                const SizedBox(height: 12.0),
                Text(
                  authProvider.error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
