import 'package:flutter/material.dart';

class Professor extends StatefulWidget {
  @override
  State<Professor> createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professores"),
        centerTitle: true,
      ),
    );
  }
}
