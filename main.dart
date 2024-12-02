import 'package:flutter/material.dart';
import 'package:project2/screens/login_screen.dart';
import 'package:project2/screens/registration_screen.dart';
import 'package:project2/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(
          onUserRegistered: (userData) async {
            // Збереження даних після реєстрації
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', userData['email']!);
            await prefs.setString('password', userData['password']!);
            await prefs.setString('name', userData['name']!);
            await prefs.setString('phone', userData['phone']!);
          },
        ),
        '/home': (context) => HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
