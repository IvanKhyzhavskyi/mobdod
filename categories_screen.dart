import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  List<String> get games => [
    'Blackjack',
    'Roulette',
    'Poker',
    'Baccarat',
    'Slots',
  ];

  // Функція для показу діалогу виходу
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          // Кнопка скасування, просто закриває діалог
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          // Кнопка логування, додається логіка виходу
          TextButton(
            onPressed: () {
              // Логіка для очищення даних перед виходом
              // Наприклад, використання SharedPreferences або інших сервісів
              Navigator.of(context).pop(); // Закриває діалог
              Navigator.of(context).pop(); // Повертає назад на попередній екран
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  // Слухач для перевірки підключення до мережі
  void _listenToConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are offline. Some features may be limited.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are back online.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Casino Games', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 207, 22, 81),
        actions: [
          // Кнопка для показу діалогу виходу
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.whiteColor),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(games[index]),
            leading: const Icon(Icons.casino),
            onTap: () {
              // Тут можна додати навігацію до ігор
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        tooltip: 'Go to Profile',
        child: Icon(Icons.account_circle),
      ),
    );
  }
}
