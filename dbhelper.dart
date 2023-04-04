import 'package:escolaflutter/models/MatriculadosModel.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'models/Pessoa.dart';
import 'models/DisciplinaModel.dart';
import 'dart:io';
import 'dart:async';

// Classe que contém os métodos para interagir com o banco de dados
class ApiSql{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"escola.db"); //create path to database

    // PARA DEBUG
    // databaseFactory.deleteDatabase(path);

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db, int version) async{
          await db.execute("""
            CREATE TABLE IF NOT EXISTS alunos (
            nome TEXT,
            cpf TEXT,
            matricula INTEGER PRIMARY KEY AUTOINCREMENT,
            sexo TEXT
          )""");
          await db.execute("""
            CREATE TABLE IF NOT EXISTS professores(
            nome TEXT,
            cpf TEXT,
            matricula INTEGER PRIMARY KEY AUTOINCREMENT,
            sexo TEXT
          )""");
          await db.execute("""
            CREATE TABLE IF NOT EXISTS disciplinas(
            nome TEXT,
            codigo TEXT,
            semestre TEXT,
            prof_matricula INTEGER,
            foreign key (prof_matricula) REFERENCES professores(matricula)
          )""");
          await db.execute("""
            CREATE TABLE IF NOT EXISTS matriculados(
            matricula_aluno INTEGER,
            codigo_disciplina TEXT,
            foreign key (matricula_aluno) REFERENCES alunos(matricula),
            foreign key (codigo_disciplina) REFERENCES disciplinas(codigo),
            PRIMARY KEY (matricula_aluno, codigo_disciplina)
          )""");
          // Problemas com o autoincrement iniciando em um numero diferente de 1
          // await db.execute("""
          // UPDATE SQLITE_SEQUENCE SET seq = 1000 WHERE name = 'Alunos';
          // """
          // );
        });
  }

  // Insert
  Future<int> addPessoa(Pessoa item, String table) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    print(item.matricula);
    return db.insert(table, item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }
  // Insert
  Future<int> addDisciplina(DisciplinaModel item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    if(item.prof_matricula == null){
      item.prof_matricula = -1;
    }

    return db.insert("disciplinas", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }
  // Insert
  Future<int> addAlunoEmDisciplina(MatriculadosModel matriculado) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    return db.insert("matriculados", matriculado.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  // Read
  Future<List<Pessoa>> fetchPessoas(String table) async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query(table); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Pessoa(
        nome: maps[i]['nome'].toString(),
        cpf: maps[i]['cpf'].toString(),
        sexo: maps[i]['sexo'].toString(),
        matricula: int.parse(maps[i]["matricula"].toString()),
      );
    });
  }
  // Read
  Future<List<DisciplinaModel>> fetchDisciplinas() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("disciplinas"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return DisciplinaModel(
        nome: maps[i]['nome'].toString(),
        codigo: maps[i]['codigo'].toString(),
        semestre: maps[i]['semestre'].toString(),
        prof_matricula: int.parse(maps[i]["prof_matricula"].toString()),
      );
    });
  }
  // Read
  Future<List<MatriculadosModel>> fetchMatriculados() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("matriculados"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return MatriculadosModel(
        matricula_aluno: int.parse(maps[i]["matricula_aluno"].toString()),
        codigo_disciplina: maps[i]['codigo_disciplina'].toString(),
      );
    });
  }

  // Delete
  Future<int> deletePessoa(int? matricula, String table) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        table, //table name
        where: "matricula = ?",
        whereArgs: [matricula] // use whereArgs to avoid SQL injection
    );

    return result;
  }
  // Delete
  Future<int> deleteDisciplina(String? codigo) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "disciplinas", //table name
        where: "codigo = ?",
        whereArgs: [codigo] // use whereArgs to avoid SQL injection
    );

    return result;
  }
  // Delete
  Future<int> deleteAlunoEmDisciplina(int? matricula, String table) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "matriculados", //table name
        where: "matricula = ?, codigo = ?",
        whereArgs: [matricula, codigo], // use whereArgs to avoid SQL injection
    );

    return result;
  }

  // Update
  Future<int> updatePessoa(int? matricula, Pessoa item, String table) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        table,
        item.toMap(),
        where: "matricula = ?",
        whereArgs: [matricula]
    );
    return result;
  }
  // Update
  Future<int> updateDisciplina(String? codigo, DisciplinaModel item) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "disciplinas",
        item.toMap(),
        where: "codigo = ?",
        whereArgs: [codigo]
    );
    return result;
  }
}