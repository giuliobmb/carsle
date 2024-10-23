import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:carsle/backend/car.dart';
import 'package:flutter/material.dart';

import 'dart:math'; // Per la funzione random
import 'package:flutter/material.dart';
import 'package:carsle/backend/gameservice.dart';
import 'package:carsle/backend/car.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Car> allCars = []; // Lista delle auto caricate dal database
  List<Car> filteredCars = []; // Lista delle auto filtrate in base alla ricerca
  List<Car> visibleCars = []; // Lista delle auto visibili (selezionate)
  Car? randomCar; // L'auto da indovinare
  int attempts = 0; // Contatore dei tentativi dell'utente
  int maxAttempts = 10; // Numero massimo di tentativi permessi
  bool gameWon = false; // Stato di vittoria
  bool gameOver = false; // Stato di sconfitta
  bool carsLoaded = false; // Variabile che indica se le auto sono state caricate
  String searchQuery = ''; // Stringa di ricerca

  TextEditingController searchController = TextEditingController(); // Controller per la barra di ricerca

  @override
  void initState() {
    super.initState();
    _loadCars(); // Carica le auto quando la pagina viene inizializzata
  }

  Future<void> _loadCars() async {
    GameService g = GameService();
    await g.init(); // Carica le auto dal database

    setState(() {
      allCars = g.cars;
      carsLoaded = allCars.isNotEmpty;
      _pickRandomCar(); // Seleziona l'auto casuale da indovinare
    });
  }

  // Funzione per selezionare un'auto casuale
  void _pickRandomCar() {
    final random = Random();
    randomCar = allCars[random.nextInt(allCars.length)];
    print('Auto da indovinare: ${randomCar?.brand} ${randomCar?.model}'); // Debug
  }

  void _handleSearch(String query) {
    setState(() {
      // Rimuovi spazi bianchi iniziali e finali dalla query
      searchQuery = query.trim();

      // Filtro solo se la query non è vuota
      if (searchQuery.isNotEmpty) {
        filteredCars = allCars.where((car) {
          return car.model.toLowerCase().contains(searchQuery.toLowerCase()) || car.brand.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      } else {
        filteredCars = [];
      }
    });
  }

  void _selectCar(Car car) {
    setState(() {
      if (attempts < maxAttempts && !gameOver && !gameWon) {
        attempts++; // Incrementa il contatore di tentativi

        // Aggiungi l'auto selezionata alla lista visibile
        if (!visibleCars.contains(car)) {
          visibleCars.add(car);
        }

        // Verifica se l'utente ha indovinato
        if (car == randomCar) {
          gameWon = true;
        } else if (attempts == maxAttempts) {
          gameOver = true;
        }

        // Pulisce la barra di ricerca
        searchController.clear();
        searchQuery = ''; // Resetta la barra di ricerca
        filteredCars = []; // Svuota la lista dei risultati dopo la selezione
      }
    });
  }

  // Funzione per colorare in base alla corrispondenza dei dati e aggiungere frecce per i numeri
  Widget buildColoredInfoBox(String label, dynamic value, dynamic targetValue, Color defaultColor) {
    Color color = _getColor(label.toLowerCase(), value, targetValue);
    Icon? directionIcon;

    // Aggiungiamo frecce solo per i valori numerici, senza colorare i sedili
    if (label.toLowerCase() == 'seats' && value != targetValue) {
      directionIcon = value < targetValue
          ? const Icon(Icons.arrow_upward, color: Colors.yellowAccent, size: 16) // Freccia in su se il valore è minore
          : const Icon(Icons.arrow_downward, color: Colors.yellowAccent, size: 16); // Freccia in giù se il valore è maggiore
    } else if (value is num && targetValue is num && value != targetValue) {
      directionIcon = value < targetValue
          ? const Icon(Icons.arrow_upward, color: Colors.yellowAccent, size: 16) // Freccia in su se il valore è minore
          : const Icon(Icons.arrow_downward, color: Colors.yellowAccent, size: 16); // Freccia in giù se il valore è maggiore
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (label.toLowerCase() == 'seats' && value != targetValue) ? Colors.transparent : color, // Nessun colore giallo per i sedili
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              if (directionIcon != null) ...[
                const SizedBox(width: 5), // Spazio tra il testo e l'icona
                directionIcon,
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Funzione per colorare in base alla corrispondenza dei dati
  Color _getColor(String field, dynamic carValue, dynamic targetValue) {
    if (field == 'doors' && ((carValue == 4 && targetValue == 5) || (carValue == 5 && targetValue == 4))) {
      return Colors.greenAccent; // Tratta 4 porte come equivalente a 5 porte
    }

    if (carValue == targetValue) {
      return Colors.greenAccent; // Perfetta corrispondenza
    }

    if (field == 'model' || field == 'brand') {
      // Somiglianza basata sulla lunghezza delle stringhe (vicinanza "approssimativa")
      if (carValue.toLowerCase().startsWith(targetValue.toLowerCase()[0])) {
        return Colors.yellowAccent;
      }
    } else if (field == 'doors') {
      // Differenza numerica di 1-2 (con eccezione per doors 4-5)
      if ((carValue - targetValue).abs() <= 2) {
        return Colors.yellowAccent;
      }
    } else if (field == 'acceleration') {
      // Vicinanza nell'accelerazione entro 0.5 secondi
      if ((carValue - targetValue).abs() <= 0.5) {
        return Colors.yellowAccent;
      }
    }

    return Colors.redAccent; // Nessuna corrispondenza
  }

  // Funzione per resettare il gioco
  void _resetGame() {
    setState(() {
      visibleCars.clear(); // Svuota le auto selezionate
      attempts = 0; // Resetta i tentativi
      gameWon = false; // Resetta lo stato di vittoria
      gameOver = false; // Resetta lo stato di sconfitta
      _pickRandomCar(); // Seleziona una nuova auto casuale
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
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

              // Counter dei tentativi in alto a sinistra
              Positioned(
                top: 10,
                left: 50,
                child: Text(
                  'Attempt: $attempts/$maxAttempts',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              // Barra di ricerca dinamica attiva quando carsLoaded è true
              if (carsLoaded && !gameOver && !gameWon)
                Positioned(
                  top: 50,
                  left: 50,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra di ricerca
                      TextField(
                        controller: searchController,
                        onChanged: _handleSearch,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Hint con il brand dell'auto da indovinare
                      if (randomCar != null)
                        Text(
                          'Hint: ${randomCar!.brand}',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      const SizedBox(height: 20), // Spazio aggiunto tra la barra e la lista di carte
                    ],
                  ),
                ),

              // Contenuto principale (lista auto)
              Positioned(
                top: carsLoaded ? 120 : 80, // Alza le carte per posizionarle più in alto
                left: 10,
                right: 10,
                bottom: 10,
                child: Stack(
                  children: [
                    // Visualizza solo le auto selezionate (visibleCars)
                    ListView.builder(
                      itemCount: visibleCars.length,
                      itemBuilder: (context, index) {
                        final car = visibleCars[index];
                        return Column(
                          children: [
                            buildCarCard(car),
                            const SizedBox(height: 20), // Spazio tra le carte
                          ],
                        );
                      },
                    ),

                    // Sovrapponi la tendina di ricerca alle carte
                    if (searchQuery.isNotEmpty && filteredCars.isNotEmpty)
                      Positioned.fill(
                        child: Container(
                          color: Colors.grey[900], // Colore senza opacity, copre le carte
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: filteredCars.length,
                            itemBuilder: (context, index) {
                              final car = filteredCars[index];
                              return ListTile(
                                title: Text(
                                  '${car.brand} ${car.model}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  _selectCar(car); // Aggiungi l'auto selezionata
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Mostra il banner "You Won" quando l'utente indovina
              if (gameWon)
                Positioned.fill(
                  child: Container(
                    color: Colors.green.withOpacity(0.9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You Won!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildCarCard(randomCar!), // Mostra la carta dell'auto indovinata
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _resetGame, // Resetta il gioco
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Mostra il banner "Game Over" quando l'utente esaurisce i tentativi
              if (gameOver)
                Positioned.fill(
                  child: Container(
                    color: Colors.red.withOpacity(0.9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Game Over!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _resetGame, // Resetta il gioco
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Funzione per costruire la carta con i dati dell'auto
  Widget buildCarCard(Car car) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey, // Nessuna opacity
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                image: DecorationImage(
                  image: NetworkImage(car.image), // Usa NetworkImage per caricare l'immagine da URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dati con colorazione dinamica
            buildColoredInfoBox('Brand', car.brand, randomCar!.brand, Colors.redAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('Model', car.model, randomCar!.model, Colors.blueAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('Seats', car.seats, randomCar!.seats, Colors.transparent), // Solo freccia per i sedili
            const SizedBox(height: 10),
            buildColoredInfoBox('Doors', car.doors, randomCar!.doors, Colors.greenAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('Type', car.type, randomCar!.type, Colors.purpleAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('0-100 km/h', car.acceleration, randomCar!.acceleration, Colors.orangeAccent),
          ],
        ),
      ),
    );
  }
}
