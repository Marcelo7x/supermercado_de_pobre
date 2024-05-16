
import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';

import 'controllers/main_controller.dart';
import 'pages/home.dart';

final AUTOINJECTOR = AutoInjector();

void main() {
  AUTOINJECTOR.addSingleton(MainController.new);
  AUTOINJECTOR.commit();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermercado de Pobre',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            secondary: Colors.blue[400],
            primary: Colors.deepOrange,
            background: Colors.blueGrey[50],
            surface: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
