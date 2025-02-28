// lib/dao/task_dao.dart
import 'package:floor/floor.dart';
import '../models/Task.dart';

//Clase encagada de gestionar el CRUD de las tareas
@dao
abstract class TaskDao {

  //Get de todas las tareas
  @Query('SELECT * FROM Task')
  Stream<List<Task>> getAllTasks();

//Get de una tarea por id
  @Query('SELECT * FROM Task WHERE id = :id')
  Future<Task?> getTaskById(int id);

  // Insertar tarea
  @insert
  Future<void> insertTask(Task task);

  //Actualizar tarea
  @update
  Future<void> updateTask(Task task);

  //Eliminar tarea
  @delete
  Future<void> deleteTask(Task task);
}