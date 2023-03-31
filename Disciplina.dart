import 'package:escolaflutter/models/CardModelDisciplina.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/DisciplinaModel.dart';

class Disciplina extends StatefulWidget {
  @override
  State<Disciplina> createState() => _DisciplinaState();
}

class _DisciplinaState extends State<Disciplina> {

  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadDisciplinas(){
    return FutureBuilder(
      future: ApiSql().fetchDisciplinas(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> disciplinas) {
        if(disciplinas.hasData){
          return listaDisciplinas(disciplinas.data);
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

  Widget listaDisciplinas(disciplinas){
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
                itemCount: disciplinas.length,
                itemBuilder: (context, index) {
                  return CardModelDisciplina(
                    model: disciplinas[index],
                    onDelete: (DisciplinaModel disciplina) {
                      ApiSql().deleteDisciplina(disciplina.codigo);
                      setState(() {});
                    },
                    route: "/disciplinas",
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
        title: Text("Disciplinas"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: [
                loadDisciplinas(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/add-disciplina', arguments: {
            "route": "/disciplinas",
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
