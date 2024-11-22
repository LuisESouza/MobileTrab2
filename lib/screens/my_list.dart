import 'package:flutter/material.dart';

class MyListPage extends StatelessWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Minha Lista tela',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}