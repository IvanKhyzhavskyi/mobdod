import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> items = [
    'Елемент 52',
    'Елемент OG Bubnyk',
    'Елемент 609a',
    'Елемент 64',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            leading: Icon(Icons.star),
            onTap: () {
              // Дія при натисканні на елемент
            },
          );
        },
      ),
    );
  }
}
