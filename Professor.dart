import 'package:flutter/material.dart';
import 'models/CardModelPessoa.dart';
import 'dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/Pessoa.dart';

class Professor extends StatefulWidget {
  @override
  State<Professor> createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {

  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadProfessores(){ // MODULARIZAR ESTA FUNÇÃO
    return FutureBuilder(
      future: ApiSql().fetchAlunos(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> professores) {
        if(professores.hasData){
          return listaAlunos(professores.data);
        }
        return const Center(
          child: SpinKitRing(
            color: Colors.blue,
            size: 60,
          ),
        );
      },
    );
  }

  Widget listaAlunos(professores){
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
                      ApiSql().deleteAluno(professor.matricula);
                      setState(() {});
                    },
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
      ),
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
        onPressed: (){
          Navigator.pushNamed(context, '/add-pessoa');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
