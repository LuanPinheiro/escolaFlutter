import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Escola"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/alunos");
                },
                child: Text("Aluno")
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/professores");
                  },
                  child: Text("Professores")
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/disciplinas");
                  },
                  child: Text("Disciplinas")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
