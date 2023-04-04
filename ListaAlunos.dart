import 'package:escolaflutter/models/DisciplinaModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dbhelper.dart';
import 'models/MatriculadosModel.dart';

class ListaAlunos extends StatefulWidget {
  const ListaAlunos({Key? key}) : super(key: key);

  @override
  State<ListaAlunos> createState() => _ListaAlunosState();
}

class _ListaAlunosState extends State<ListaAlunos> {

  DisciplinaModel? model;

  @override
  void initState() {

    Future.delayed(Duration.zero, () {
      final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
      model = arguments["model"] != null ? arguments["model"] : DisciplinaModel();
    });
  }
  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadAlunos(){
    return FutureBuilder(
      future: ApiSql().fetchMatriculados(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> matriculados) {
        if(matriculados.hasData){
          for(int i = 0; i < matriculados.data!.length; i++){
            if(matriculados.data![i].codigo_disciplina != model!.codigo){
              matriculados.data!.remove(matriculados.data![i]);
            }
          }
          return listaAlunos(matriculados.data);
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
                  return ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Matrícula: ${alunos[index].matricula_aluno.toString()}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Divider(
                      thickness: 3,
                      height: 30,
                      color: Colors.blue,
                    ),
                    trailing: GestureDetector(
                      // Criando um botão de editar pessoa, no container da mesma
                      child: const Icon(Icons.remove_circle_rounded),
                      onTap: () async {
                        await ApiSql().deleteAlunoEmDisciplina(alunos[index].matricula_aluno, model!.codigo);
                        setState(() {});
                      },
                    ),
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
        title: Text("Lista de Alunos em Disciplina"),
      ),
      body: loadAlunos(),
    );
  }
}
