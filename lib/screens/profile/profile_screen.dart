
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: user.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                      onChanged: (value) {
                        setState(() => _name = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _auth.updateUserName(_name);
                          if(mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated successfully')),
                            );
                          }
                        }
                      },
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 20),
                     Text(
                      'Email: ${user.email}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
