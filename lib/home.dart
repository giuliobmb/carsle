// ignore_for_file: prefer_const_constructors

import 'package:carsle/game.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black, // Imposta lo sfondo nero
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
              'assets/images/landing.webp', // Percorso dell'immagine
              height: 200, // Altezza dell'immagine
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter, // Centra il primo testo in alto
                child: Text(
                  'Carsle',
                  style: TextStyle(
                    color: Colors.white, // Testo bianco
                    fontSize: 34,
                    fontWeight: FontWeight.bold, // Testo più grande
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),           
            const Align(
              alignment: Alignment.bottomCenter, // Posiziona il secondo testo in basso
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Text(
                  'Guess between over 1000 car models',
                  style: TextStyle(
                    color: Colors.white, // Testo bianco
                    fontSize: 16, // Testo più piccolo
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () { //azione eseguita quando si preme push
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage(title: 'Carsle',)), // Naviga verso la SecondPage
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Dimensione del bottone
              ),
              child: const Text(
                'Play',
                style: TextStyle(
                  color: Colors.black, // Colore del testo nel bottone (nero per contrasto)
                  fontSize: 25, // Dimensione del testo nel bottone
                ),
              ),
            ),
            const SizedBox(height:50),
            IntrinsicWidth(
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 300,
                        child: AlertDialog(
                          title: const Text('How to play', style: TextStyle(fontSize: 34)),
                          // ignore: prefer_const_constructors
                          content: SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: const Text('Guess the car model by typing the name in the text field. If you are correct, the car model will be displayed. If you are wrong, the correct car model will be displayed.', style: TextStyle(fontSize: 24)),
                            )),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }, // Trigger la funzione quando il testo viene cliccato
                child: const Align(
                  alignment: Alignment.topCenter, // Centra anche il secondo testo
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'how to play',
                      style: TextStyle(
                        color: Colors.white, // Testo bianco
                        fontSize: 16, // Testo più piccolo
                        decoration: TextDecoration.underline, // Sottolinea il testo per far capire che è cliccabile
                      ),
                    ),
                  ),
                ),
              ),
            ),
           ],
        ),
      );
  }
}
