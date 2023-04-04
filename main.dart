import 'package:escolaflutter/AddEditPesssoa.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Aluno.dart';
import 'Professor.dart';
import 'Disciplina.dart';
import 'AddEditDisciplina.dart';
import 'ListaAlunos.dart';

void main() => runApp(MaterialApp(
  initialRoute: "/",
  routes: {
    '/': (context) => HomePage(),
    '/alunos': (context) => Aluno(),
    '/professores': (context) => Professor(),
    '/disciplinas': (context) => Disciplina(),
    '/edit-pessoa': (context) => AddEditPessoa(),
    '/add-pessoa': (context) => AddEditPessoa(),
    '/edit-disciplina': (context) => AddEditDisciplina(),
    '/add-disciplina': (context) => AddEditDisciplina(),
    '/listar-alunos': (context) => ListaAlunos(),
  }
));