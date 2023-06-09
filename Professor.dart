import 'package:flutter/material.dart';
import 'models/CardModelPessoa.dart';
import 'dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/Pessoa.dart';
import 'nightmode.dart';

class Professor extends StatefulWidget {
  @override
  State<Professor> createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {

  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadProfessores(){ // MODULARIZAR ESTA FUNÇÃO
    return FutureBuilder(
      future: ApiSql().fetchPessoas("professores"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> professores) {
        if(professores.hasData){
          return listaProfessores(professores.data);
        }

        return const Center(
          child: SpinKitRing(
            color: Colors.black,
            size: 60,
          ),
        );
      },
    );
  }

  Widget listaProfessores(professores){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: professores.length,
                itemBuilder: (context, index) {
                  return CardModelPessoa(
                    model: professores[index],
                    onDelete: (Pessoa professor) {
                      ApiSql().deletePessoa(professor.matricula, "professores");
                      ApiSql().retiraProfDisciplinas(professor.matricula);
                      setState(() {});
                    },
                    route: "/professores",
                    output: "Professor",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Professores"),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                loadProfessores(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: (){
          Navigator.pushNamed(context, '/add-pessoa', arguments: {"route": "/professores"});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
