import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'car.dart';

class GameService {
  final String FILEPATH = 'assets/cars/cars.csv';
  List<Car> cars = [];

  GameService() {
    init();
  }

  Future<List<Car>> parseCars() async {
    final input = File(FILEPATH).openRead();
    final fields = await input
        .transform(utf8.decoder) // Decodifica il file in formato UTF-8
        .transform(const CsvToListConverter()) // Converte il CSV in una lista
        .toList();

    // Rimuovi l'intestazione (se esiste) prima di mappare i dati
    final cars = fields.skip(1).map((row) {
      return Car(
        key: row[0].toString(),
        code: row[1].toString(),
        brand: row[2].toString(),
        model: row[3].toString(),
        type: row[4].toString(),
        seats: int.parse(row[5].toString()),
        doors: int.parse(row[6].toString()),
        acceleration: _parseAcceleration(row[7].toString()),
        image: row[8].toString(),
        tag: row[9].toString(),
      );
    }).toList();

    return cars;
  }

  Future<void> init() async {
    this.cars = await parseCars(); // Chiamata alla funzione asincrona
    print('Auto caricate: $cars');
  }

// Funzione di utilità per convertire l'accelerazione in double, estraendo solo il numero
  double _parseAcceleration(String accelerationString) {
    try {
      // Usa una espressione regolare per estrarre solo la parte numerica
      final numericString =
          RegExp(r'\d+(\.\d+)?').stringMatch(accelerationString);
      if (numericString != null) {
        return double.parse(
            numericString); // Converte la stringa numerica in double
      } else {
        return 0.0; // Restituisce un valore predefinito se non ci sono numeri
      }
    } catch (e) {
      print('Errore durante la conversione dell\'accelerazione: $e');
      return 0.0; // Valore predefinito in caso di errore
    }
  }
}
