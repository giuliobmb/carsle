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
        .transform(utf8.decoder)
        .transform(const CsvToListConverter()) 
        .toList();


    final cars = fields.skip(1).where((row) => row.length >= 10).map((row) {
      return Car(
        key: row[0].toString(),
        code: row[1].toString(),
        brand: row[2].toString(),
        model: row[3].toString(),
        type: row[4].toString(),
        seats: _parseSeatsOrDoors(row[5].toString()),
        doors: _parseSeatsOrDoors(row[6].toString()),
        acceleration: _parseAcceleration(row[7].toString()),
        image: row[8].toString(),
        tag: row[9].toString(),
      );
    }).toList();

    return cars;
  }

  Future<void> init() async {
    this.cars = await parseCars();
  }


  double _parseAcceleration(String accelerationString) {
    try {
      
      final numericString = RegExp(r'\d+(\.\d+)?').stringMatch(accelerationString);
      if (numericString != null) {
        return double.parse(numericString); 
      } else {
        return 0.0;
      }
    } catch (e) {
      print('Errore durante la conversione dell\'accelerazione: $e');
      return 0.0; 
    }
  }

  int _parseSeatsOrDoors(String value) {
    try {
      if (value.contains('-')) {
        final parts = value.split('-').map((e) => int.parse(e)).toList();
        return 5; 
      }
      if (value.contains('2/3')) {
        final parts = value.split('/').map((e) => int.parse(e)).toList();
        return 3; // 
      }
      if (value.contains('3/5')) {
        final parts = value.split('/').map((e) => int.parse(e)).toList();
        return 5; 
      }
      return int.parse(value); 
    } catch (e) {
      print('Errore durante il parsing di $value: $e');
      return 0; 
    }
  }