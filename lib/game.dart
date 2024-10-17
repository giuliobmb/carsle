// Necessario per usare l'effetto blur
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
                  bottom: 10, // Per riempire l'altezza disponibile
                  child: ListView(
                    children: [
                      // Prima carta con informazioni dell'auto
                      buildCarCard(),
                      const SizedBox(height: 20),
                      // Seconda carta con le stesse informazioni
                      buildCarCard(),
                    ],
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

  // Funzione per creare i riquadri delle informazioni con colore opaco personalizzabile e testo nero
  Widget buildInfoBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5), // Colore personalizzato con opacità
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16), // Testo nero
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16), // Testo nero
          ),
        ],
      ),
    );
  }

  // Funzione per costruire la carta con i dati dell'auto, sfondo grigio e ombra
  Widget buildCarCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3), // Grigio trasparente
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Colore dell'ombra
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4), // Posizione dell'ombra
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine dell'auto
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/giulia.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Informazioni dell'auto con riquadri colorati e testo nero
            buildInfoBox('Marca', 'Alfa Romeo', Colors.redAccent),
            const SizedBox(height: 10),
            buildInfoBox('Modello', 'Giulia', Colors.blueAccent),
            const SizedBox(height: 10),
            buildInfoBox('Anno', '2021', Colors.greenAccent),
            const SizedBox(height: 10),
            buildInfoBox('Tipologia', 'Berlina', Colors.purpleAccent),
            const SizedBox(height: 10),
            buildInfoBox('0-100 km/h', '5.7 secondi', Colors.orangeAccent),
            const SizedBox(height: 10),
            buildInfoBox('Paese del marchio', 'Italia', Colors.tealAccent),
          ],
        ),
      ),
    );
  }
}
