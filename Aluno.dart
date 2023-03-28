import 'package:flutter/material.dart';
import 'models/AlunoModel.dart';
import 'models/CardModelPessoa.dart';
import 'dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'models/Pessoa.dart';

class Aluno extends StatefulWidget {
  @override
  State<Aluno> createState() => _AlunoState();
}

class _AlunoState extends State<Aluno> {

  List alunosListados = [];

  @override
  void initState() {
    super.initState();
    ApiSql().init();
  }

  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadAlunos(){
    return FutureBuilder(
      future: ApiSql().fetchAlunos(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> alunos) {
        if(alunos.hasData){
          // Garantindo que os novos adicionados continuem com a matrícula correta
          if(alunos.data!.length > 0){
            AlunoModel.matriculaNova = alunos.data?.last.matricula;
          }
          return listaAlunos(alunos.data);
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
                      ApiSql().deleteAluno(aluno.matricula);
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
        title: Text("Alunos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/add-pessoa');
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 20),
                loadAlunos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
