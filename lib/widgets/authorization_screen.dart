import 'package:flutter/material.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthorizationScreen();

}

class _AuthorizationScreen extends State<AuthorizationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                Provider.of<UserProvider>(context, listen: false)
                    .login(username, password);
              },
            ),
          ],
        ),
      ),
    );
  }
}