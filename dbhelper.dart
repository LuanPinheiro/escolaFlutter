import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'models/Pessoa.dart';
import 'dart:io';
import 'dart:async';

// Classe que contém os métodos para interagir com o banco de dados
class ApiSql{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"alunos.db"); //create path to database

    // PARA DEBUG
    //databaseFactory.deleteDatabase(path);

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE alunos(
          nome TEXT,
          cpf TEXT,
          matricula INTEGER PRIMARY KEY AUTOINCREMENT,
          sexo TEXT
          );
          CREATE TABLE professores(
          nome TEXT,
          cpf TEXT,
          matricula INTEGER PRIMARY KEY AUTOINCREMENT,
          sexo TEXT
          );
          CREATE TABLE disciplinas(
          nome TEXT,
          codigo TEXT PRIMARY KEY,
          semestre TEXT,
          matricula_prof INTEGER,
          );
          CREATE TABLE alunos_disciplina(
          matricula_aluno INTEGER,
          codigo_disciplina INTEGER,
          );"""
          );
          // Problemas com o autoincrement iniciando em um numero diferente de 1
          // await db.execute("""
          // UPDATE SQLITE_SEQUENCE SET seq = 1000 WHERE name = 'Alunos';
          // """
          // );
        });
  }

  // Insert
  Future<int> addAluno(Pessoa item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    return db.insert("Alunos", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  // Read
  Future<List<Pessoa>> fetchAlunos() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Alunos"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Pessoa(
        nome: maps[i]['nome'].toString(),
        cpf: maps[i]['cpf'].toString(),
        sexo: maps[i]['sexo'].toString(),
        matricula: int.parse(maps[i]["matricula"].toString()),
      );
    });
  }

  // Delete
  Future<int> deleteAluno(int? matricula) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Alunos", //table name
        where: "matricula = ?",
        whereArgs: [matricula] // use whereArgs to avoid SQL injection
    );

    return result;
  }

  // Update
  Future<int> updateAluno(int? matricula, Pessoa item) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Alunos",
        item.toMap(),
        where: "matricula = ?",
        whereArgs: [matricula]
    );
    return result;
  }
}