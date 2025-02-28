import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/Task.dart';
import 'añadir_tarea.dart';
import 'editar_tarea.dart';

// Pantalla principal que muestra todas las tareas disponibles.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Llamada a la base de datos.
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  // Inicia la conexión a la base de datos.
  Future<void> _initDatabase() async {
    _database = await AppDatabase.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Tareas'),
      ),
      // Espera a que la base de datos esté disponible (Para evitar problemas cuando inserte o elimine tareas)
      body: FutureBuilder<AppDatabase>(
        future: AppDatabase.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Gestiona cambios en las tareas (Cuando se añaden principalmente)
          return StreamBuilder<List<Task>>(
            stream: snapshot.data!.taskDao.getAllTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('No hay tareas'));
              }

              final tasks = snapshot.data!;

              // Lista de tareas
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  // Mostrar tareas
                  return ListTile(
                    title: Text(task.titulo),
                    subtitle: Text(
                      task.descripcion,
                      maxLines: 2,

                      //Añade puntos suspensivos si el texto supera el contenedor de 2 lineas
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Navega a la pantalla de edición
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      // Botón para añadir nueva tarea
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}