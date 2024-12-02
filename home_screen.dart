import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Імпорт сторінки профілю

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Казино',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(context); // Викликаємо вікно підтвердження виходу
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCasinoBanner(),
              SizedBox(height: 20),
              _buildMainButtons(),
              SizedBox(height: 20),
              _buildCasinoGamesSection(context), // Додаємо контекст для переходу
              SizedBox(height: 20),
              _buildCasinoInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCasinoBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.yellow.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage('assets/casino_banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Ласкаво просимо до Казино!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black,
                offset: Offset(3, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCasinoButton(
          label: 'Ігри',
          icon: Icons.gamepad,
          onPressed: () {
            // Перехід до розділу з іграми
          },
        ),
        _buildCasinoButton(
          label: 'Розіграш',
          icon: Icons.card_giftcard,
          onPressed: () {
            // Перехід до розіграшу
          },
        ),
      ],
    );
  }

  Widget _buildCasinoButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildCasinoGamesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Популярні Ігри',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildGameTile(context, 'Рулетка'),
          _buildGameTile(context, 'Блекджек'),
          _buildGameTile(context, 'Слот-ігри'),
        ],
      ),
    );
  }

  Widget _buildGameTile(BuildContext context, String gameName) {
    return ListTile(
      title: Text(gameName),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Перехід до сторінки гри
      },
    );
  }

  Widget _buildCasinoInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Про нас',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Ми надаємо найкращі ігри для азартних гравців. Насолоджуйтеся безліччю варіантів і вигравайте великі призи!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Вийти з акаунту?'),
        content: Text('Ви дійсно хочете вийти з акаунту?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              // Вихід з акаунту
              _logout(context);
            },
            child: Text('Вийти'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Очистка збережених даних
    Navigator.pushReplacementNamed(context, '/login'); // Перехід на екран входу
  }
}
