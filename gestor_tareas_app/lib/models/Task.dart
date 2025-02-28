// lib/models/Task.dart
import 'package:floor/floor.dart';

// Entidad que representa una tarea en la aplicación.

@entity
class Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String titulo;
  final String descripcion;

  // Constructor
  Task({
    this.id,
    required this.titulo,
    required this.descripcion,
  });

  // Crea una copia de la tarea con valores actualizados.
  // Se usa para actualizar una tarea existente manteniendo los valores que no han cambiado.
  Task actualizarTarea({
    int? id,
    String? title,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: title ?? this.titulo,
      descripcion: description ?? this.descripcion,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $titulo, description: $descripcion)';
  }
}