import 'dart:convert';
import 'package:flutter/material.dart';
import 'profile_screen.dart'; 
import '../app_colors.dart'; 
import '../services/local_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

// Модель для гри
class Game {
  final String title;
  final String description;
  final String imageUrl;

  Game({required this.title, required this.description, required this.imageUrl});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  static Game fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();

  // Завантаження ігор із API
  Future<List<Game>> fetchGames() async {
    try {
      final response = await http.get(Uri.parse('https://run.mocky.io/v3/a87dce96-8637-4d7c-ab41-5f33cb80c4af')); 

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((gameJson) => Game.fromJson(gameJson)).toList();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      print('Error fetching games: $e');
      rethrow;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _localStorageService.saveUserData('', '', '');
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _listenToConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are offline. Some features may be limited.')),
        );
      }
    });
  }

  // Перехід до екрану з деталями гри
  void _viewGameDetails(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Casino Games', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 44, 63, 57), 
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.whiteColor), 
            onPressed: () => _showLogoutDialog(context), 
          ),
        ],
      ),
      body: FutureBuilder<List<Game>>(
        future: fetchGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No games available.'));
          } else {
            List<Game> games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(games[index].title),
                  leading: Image.network(games[index].imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  subtitle: Text(games[index].description),
                  onTap: () => _viewGameDetails(context, games[index]),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        child: Icon(Icons.person),
        tooltip: 'Go to Profile',
      ),
    );
  }
}

class GameDetailsScreen extends StatelessWidget {
  final Game game;

  GameDetailsScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title, style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 50, 71, 66),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(game.imageUrl),
            SizedBox(height: 16),
            Text(
              game.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              game.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You have selected this game!')),
                );
              },
              child: Text('Play Now', style: TextStyle(color: AppColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(94, 46, 73, 75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
