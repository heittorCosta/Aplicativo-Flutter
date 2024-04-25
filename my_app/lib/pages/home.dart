import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 166, 235),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Página Principal", style: TextStyle(color: Colors.white), ),
      ),
      body: Container(
        child: Text("Olá"),
      ),
    );
  }
}