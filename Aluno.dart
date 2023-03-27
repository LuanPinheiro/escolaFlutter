import 'package:flutter/material.dart';
import 'models/AlunoModel.dart';
import 'models/CardModelPessoa.dart';

class Aluno extends StatefulWidget {
  @override
  State<Aluno> createState() => _AlunoState();
}

class _AlunoState extends State<Aluno> {

  // PARA DEBUG
  List alunos = [AlunoModel(), AlunoModel(), AlunoModel(), AlunoModel(), AlunoModel(), AlunoModel(), AlunoModel()];

  // Carrega do banco de dados os alunos em uma lista alunos
  // Widget loadAlunos(){
  //   return FutureBuilder(
  //     future: getAlunos(),
  //     builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> alunos) {
  //       if(dados.hasData){
  //         return listaAlunos(dados.data);
  //       }
  //
  //       return const Center(
  //         child: SpinKitRing(
  //           color: Colors.green,
  //           size: 60,
  //         ),
  //       );
  //     },
  //   );
  // }

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
                    onDelete: (){},
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
                listaAlunos(alunos),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
