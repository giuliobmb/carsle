import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:carsle/backend/car.dart';
import 'package:flutter/material.dart';
import 'dart:math';
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
  List<Car> allCars = []; 
  List<Car> filteredCars = []; 
  List<Car> visibleCars = []; 
  Car? randomCar; 
  int attempts = 0; 
  int maxAttempts = 10; 
  bool gameWon = false; 
  bool gameOver = false; 
  bool carsLoaded = false; 
  String searchQuery = ''; 

  TextEditingController searchController = TextEditingController();

  /// Inizializza la pagina e carica le auto dal database
  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  /// Carica tutte le auto dal database e seleziona un'auto casuale da indovinare
  Future<void> _loadCars() async {
    GameService g = GameService();
    await g.init();

    setState(() {
      allCars = g.cars;
      carsLoaded = allCars.isNotEmpty;
      _pickRandomCar();
    });
  }

  /// Seleziona un'auto casuale da indovinare
  void _pickRandomCar() {
    final random = Random();
    randomCar = allCars[random.nextInt(allCars.length)];
    print('Auto da indovinare: ${randomCar?.brand} ${randomCar?.model}');
  }

  /// Gestisce la ricerca filtrando la lista delle auto in base alla query
  void _handleSearch(String query) {
    setState(() {
      searchQuery = query.trim();

      if (searchQuery.isNotEmpty) {
        filteredCars = allCars.where((car) {
          return car.model.toLowerCase().contains(searchQuery.toLowerCase()) || car.brand.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      } else {
        filteredCars = [];
      }
    });
  }

  /// Seleziona un'auto e verifica se è quella da indovinare
  void _selectCar(Car car) {
    setState(() {
      if (attempts < maxAttempts && !gameOver && !gameWon) {
        attempts++;

        if (!visibleCars.contains(car)) {
          visibleCars.add(car);
        }

        if (car == randomCar) {
          gameWon = true;
        } else if (attempts == maxAttempts) {
          gameOver = true;
        }

        searchController.clear();
        searchQuery = '';
        filteredCars = [];
      }
    });
  }

  /// Crea un widget colorato con frecce per indicare corrispondenze parziali
  Widget buildColoredInfoBox(String label, dynamic value, dynamic targetValue, Color defaultColor) {
    Color color = _getColor(label.toLowerCase(), value, targetValue);
    Icon? directionIcon;

    if (label.toLowerCase() == 'seats' && value != targetValue) {
      directionIcon = value < targetValue
          ? const Icon(Icons.arrow_upward, color: Colors.yellowAccent, size: 16)
          : const Icon(Icons.arrow_downward, color: Colors.yellowAccent, size: 16);
    } else if (value is num && targetValue is num && value != targetValue) {
      directionIcon = value < targetValue
          ? const Icon(Icons.arrow_upward, color: Colors.yellowAccent, size: 16)
          : const Icon(Icons.arrow_downward, color: Colors.yellowAccent, size: 16);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (label.toLowerCase() == 'seats' && value != targetValue) ? Colors.transparent : color,
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
                const SizedBox(width: 5),
                directionIcon,
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Calcola il colore da assegnare in base alla corrispondenza dei valori di campo
  Color _getColor(String field, dynamic carValue, dynamic targetValue) {
    if (field == 'doors' && ((carValue == 4 && targetValue == 5) || (carValue == 5 && targetValue == 4))) {
      return Colors.greenAccent;
    }

    if (carValue == targetValue) {
      return Colors.greenAccent;
    }

    if (field == 'model' || field == 'brand') {
      if (carValue.toLowerCase().startsWith(targetValue.toLowerCase()[0])) {
        return Colors.yellowAccent;
      }
    } else if (field == 'doors') {
      if ((carValue - targetValue).abs() <= 2) {
        return Colors.yellowAccent;
      }
    } else if (field == 'acceleration') {
      if ((carValue - targetValue).abs() <= 0.5) {
        return Colors.yellowAccent;
      }
    }

    return Colors.redAccent;
  }

  /// Resetta il gioco
  void _resetGame() {
    setState(() {
      visibleCars.clear();
      attempts = 0;
      gameWon = false;
      gameOver = false;
      _pickRandomCar();
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
                left: 50,
                child: Text(
                  'Attempt: $attempts/$maxAttempts',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              if (carsLoaded && !gameOver && !gameWon)
                Positioned(
                  top: 50,
                  left: 50,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      if (randomCar != null)
                        Text(
                          'Hint: ${randomCar!.brand}',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              Positioned(
                top: carsLoaded ? 120 : 80,
                left: 10,
                right: 10,
                bottom: 10,
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: visibleCars.length,
                      itemBuilder: (context, index) {
                        final car = visibleCars[index];
                        return Column(
                          children: [
                            buildCarCard(car),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                    if (searchQuery.isNotEmpty && filteredCars.isNotEmpty)
                      Positioned.fill(
                        child: Container(
                          color: Colors.grey[900],
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
                                  _selectCar(car);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
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
                          buildCarCard(randomCar!),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _resetGame,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            onPressed: _resetGame,
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

  /// Costruisce una carta visuale con i dettagli dell'auto
  Widget buildCarCard(Car car) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
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
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(car.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildColoredInfoBox('Brand', car.brand, randomCar!.brand, Colors.redAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('Model', car.model, randomCar!.model, Colors.blueAccent),
            const SizedBox(height: 10),
            buildColoredInfoBox('Seats', car.seats, randomCar!.seats, Colors.transparent),
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
