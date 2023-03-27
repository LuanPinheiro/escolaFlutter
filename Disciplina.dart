import 'package:flutter/material.dart';

class Disciplina extends StatefulWidget {
  @override
  State<Disciplina> createState() => _DisciplinaState();
}

class _DisciplinaState extends State<Disciplina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disciplinas"),
        centerTitle: true,
      ),
    );
  }
}
