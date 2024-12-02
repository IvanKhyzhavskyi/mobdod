import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String email;

  ProfileScreen({required this.userName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ім\'я: $userName', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: $email', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();  // Очистка збережених даних
                Navigator.pushReplacementNamed(context, '/login'); // Перехід на екран входу
              },
              child: Text('Вийти'),
            ),
          ],
        ),
      ),
    );
  }
}
