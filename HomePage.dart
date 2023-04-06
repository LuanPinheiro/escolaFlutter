import 'package:flutter/material.dart';

import 'nightmode.dart';

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
        backgroundColor: mainColor,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/alunos");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
                child: Text("Aluno"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/professores");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                  ),
                  child: Text("Professores")
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/disciplinas");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                  ),
                  child: Text("Disciplinas")
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: (){
          isDarkMode = !isDarkMode;
          if(isDarkMode == true){
            bgColor = Colors.grey[600]!;
            mainColor = Colors.grey[800]!;
            cardColor = Colors.grey[400]!;
            icone = Icons.nights_stay_outlined;
          }
          else{
            bgColor = Colors.white;
            mainColor = Colors.green[800]!;
            cardColor = Colors.green[200]!;
            icone = Icons.sunny;
          }
          setState(() {});
        },
        child: Icon(icone),
      ),
    );
  }
}
