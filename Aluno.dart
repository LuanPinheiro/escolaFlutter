import 'package:flutter/material.dart';
import 'models/CardModelPessoa.dart';
import 'dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/Pessoa.dart';
import 'nightmode.dart';

class Aluno extends StatefulWidget {
  @override
  State<Aluno> createState() => _AlunoState();
}

class _AlunoState extends State<Aluno> {
  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadAlunos(){
    return FutureBuilder(
      future: ApiSql().fetchPessoas("alunos"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> alunos) {
        if(alunos.hasData){
          return listaAlunos(alunos.data);
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

  Widget listaAlunos(alunos){
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
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  return CardModelPessoa(
                    model: alunos[index],
                    onDelete: (Pessoa aluno) {
                      ApiSql().deletePessoa(aluno.matricula, "alunos");
                      ApiSql().deleteAlunoEmDisciplina(aluno.matricula, null);
                      setState(() {});
                    },
                    route: "/alunos",
                    output: "Aluno",
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
        title: Text("Alunos"),
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
                loadAlunos(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: (){
          Navigator.pushNamed(context, '/add-pessoa', arguments: {
            "route": "/alunos",
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
