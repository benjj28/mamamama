import 'package:ecommerce_app/screens/home_screen.dart'; // Ensure this is correctly linked
import 'package:ecommerce_app/screens/login_screen.dart'; // Ensure this is correctly linked
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Safety check for errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Something went wrong.\nPlease restart the app.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // User is logged in
          return const HomeScreen();
        }

        // User is not logged in
        return const LoginScreen();
      },
    );
  }
}
