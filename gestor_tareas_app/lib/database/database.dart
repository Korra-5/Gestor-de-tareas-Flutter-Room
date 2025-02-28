// lib/database/database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/task_dao.dart';
import '../models/Task.dart';

// Este archivo se genera automáticamente por Floor, contiene la implementación
// concreta de la base de datos.
part 'database.g.dart';

// Funcion encargada de gestionar la conexion con la base de datos
@Database(version: 1, entities: [Task])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
  static AppDatabase? _instance;
  static Future<AppDatabase> getInstance() async {
    _instance ??= await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return _instance!;
  }
}