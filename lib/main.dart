import 'package:carsle/backend/gameservice.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: 9 / 16, // Imposta il rapporto 9:16
            child: Container(
              color: Colors.grey[900], // Colore di sfondo per vedere i confini
              child: const MyHomePage(title: 'Carsle'), // Usa SecondPage come contenuto
            ),
          ),
        ),
      ),
    );
  }
}
