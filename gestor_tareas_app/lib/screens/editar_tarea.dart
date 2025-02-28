// lib/screens/edit_task_screen.dart
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/Task.dart';

// Pantalla para editar o eliminar una tarea existente.

class EditTaskScreen extends StatefulWidget {
  // Tarea a editar.
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // Verificacion para el campo de título. (Hay que usar los controladores de texto)
  late TextEditingController _verificarTitulo;

  // Verificacion para el campo de descripción.
  late TextEditingController _verificarDescripcion;

  bool guardado = false;

  @override
  void initState() {
    super.initState();
    _verificarTitulo = TextEditingController(text: widget.task.titulo);
    _verificarDescripcion = TextEditingController(text: widget.task.descripcion);
  }

  // Liberar recursos
  @override
  dispose() {
    _verificarTitulo.dispose();
    _verificarDescripcion.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
        actions: [
          // Botón para eliminar
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
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
            // Botón para actualizar la tarea con barra de carga
            ElevatedButton(
              onPressed: guardado ? null : _updateTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: guardado
                  ? const CircularProgressIndicator()
                  : const Text('ACTUALIZAR TAREA'),
            ),
          ],
        ),
      ),
    );
  }

  // Actualiza la tarea con los nuevos valores
  Future<void> _updateTask() async {

    // Validación de nulables
    final titulo = _verificarTitulo.text.trim();
    final descripcion = _verificarDescripcion.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un título')),
      );
      return;
    }

    if (descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce una descripción')),
      );
      return;
    }

    try {
      setState(() {
        guardado = true;
      });

      final updatedTask = widget.task.actualizarTarea(
        title: titulo,
        description: descripcion,
      );

      final database = await AppDatabase.getInstance();
      await database.taskDao.updateTask(updatedTask);

      //Mounted verifica que este en uso el widget
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea actualizada correctamente')) );
        Navigator.pop(context);
      }
    } catch (e){
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la tarea: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          guardado = false;
        });
      }
    }
  }

  // Elimina la tarea actual asegurando al usuario con un dialog
  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que quieres eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      try {
        setState(() {
          guardado = true;
        });

        final database = await AppDatabase.getInstance();
        await database.taskDao.deleteTask(widget.task);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarea eliminada correctamente')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la tarea: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            guardado = false;
          });
        }
      }
    }
  }
}