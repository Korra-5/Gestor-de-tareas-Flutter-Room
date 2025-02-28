// lib/screens/add_task_screen.dart
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/Task.dart';

// Pantalla para añadir una nueva tarea.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Verificacion para el campo de título.
  final _verificarTitulo = TextEditingController();

  // Verificacion para el campo de descripción.
  final _verificarDescripcion = TextEditingController();

  bool guardado = false;

//Se hace esto para liberar recursos de los widget
@override
  void dispose() {
    _verificarTitulo.dispose();
    _verificarDescripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _verificarTitulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                errorText: null,
              ),
            ),
            const SizedBox(height: 16),
            // Campo para la descripción
            TextField(
              controller: _verificarDescripcion,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                errorText: null,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            // Botón para guardar con barra de carga
            ElevatedButton(
              onPressed: guardado ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: guardado
                  ? const CircularProgressIndicator()
                  : const Text('GUARDAR TAREA'),
            ),
          ],
        ),
      ),
    );
  }

  //Guarda una nueva tarea en la base de datos.
  Future<void> _saveTask() async {

    // Validación de que los campos no esten vacios
    final title = _verificarTitulo.text.trim();
    final description = _verificarDescripcion.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un título')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce una descripción')),
      );
      return;
    }

    try {
      setState(() {
        guardado = true;
      });

      // Crear la nueva tarea
      final task = Task(
        titulo: title,
        descripcion: description,
      );

      // Obtener la instancia de la base de datos
      final database = await AppDatabase.getInstance();

      // Guardar la tarea en la base de datos
      await database.taskDao.insertTask(task);

      // Mostrar mensaje de éxito
      //Mounted verifica que este en uso el widget
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea añadida correctamente')),
        );

        // Volver a la pantalla anterior
        Navigator.pop(context);
      }
    } catch (e) {
      // En caso de error, mostrar mensaje
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la tarea: ${e.toString()}')),
        );
      }
    } finally {
      // Restaurar el estado del botón
      if (mounted) {
        setState(() {
          guardado = false;
        });
      }
    }
  }
}