// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16, // Mantieni il rapporto 9:16 anche in SecondPage
          child: Container(
            child: Stack(
              children: [
                // Freccia in alto a sinistra
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 50, // Sposta la barra di ricerca a destra della freccia
                  right: 10,
                  child: TextField(
                    onChanged: _handleSearch,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Cerca...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Contenuto principale
                Positioned(
                  top: 80, // Sotto la barra di ricerca
                  left: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        // Immagine dell'auto
                         Image.network('https://www.auto-data.net/images/f81/Alfa-Romeo-Giulia-952-facelift-2022_1.jpg', height: 200),
                        
                        const SizedBox(height: 10),
                        // Informazioni dell'auto con riquadri
                        buildInfoBox('Marca', 'Alfa Romeo'),
                        const SizedBox(height: 5),
                        buildInfoBox('Modello', 'Giulia'),
                        const SizedBox(height: 5),
                        buildInfoBox('Anno', '2021'),
                        const SizedBox(height: 5),
                        buildInfoBox('Tipologia', 'Berlina'),
                        const SizedBox(height: 5),
                        buildInfoBox('0-100 km/h', '5.7 secondi'),
                        const SizedBox(height: 5),
                        buildInfoBox('Paese del marchio', 'Italia'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSearch(String value) {
    // Implementa la ricerca
  }

  // Funzione per creare i riquadri delle informazioni
  Widget buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
