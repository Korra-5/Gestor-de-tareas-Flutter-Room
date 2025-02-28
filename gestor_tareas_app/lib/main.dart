// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Punto de entrada de la aplicación.
void main() async {
  // Asegura que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicia la aplicación
  runApp(const MyApp());
}

/// Widget principal de la aplicación.
///
/// Configura el tema y establece la HomeScreen como pantalla inicial.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,  // Utiliza Material Design 3
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,  // Oculta el banner de debug
    );
  }
}