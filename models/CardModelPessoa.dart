import 'package:escolaflutter/nightmode.dart';

import 'Pessoa.dart';
import 'package:flutter/material.dart';

class CardModelPessoa extends StatelessWidget {

  final Pessoa? model;
  final Function? onDelete;
  final String? route;
  final String? output;
  const CardModelPessoa({Key? key, this.model, this.onDelete, this.route, this.output}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: cardColor,
        ),
        child: pessoaWidget(context),
      )
    );
  }

  // Widget de cada pessoa na página inicial
  Widget pessoaWidget(context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações da Pessoa que aparecerá na tela
                  Text(
                    "Nome: ${model!.nome}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                      "CPF: ${model!.cpf}",
                      style: TextStyle(
                        color: Colors.black,
                      )
                  ),
                  Text(
                      "Matricula: ${model!.matricula}",
                      style: TextStyle(
                        color: Colors.black,
                      )
                  ),
                  Text(
                      "Sexo: ${model!.sexo}",
                      style: TextStyle(
                        color: Colors.black,
                      )
                  ),
                  const SizedBox(
                    // Tamanho da caixa com as informações do container
                    height: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              // Criando um botão de editar pessoa, no container da mesma
                              child: const Icon(Icons.edit),
                              onTap: () {
                                Navigator.of(context).pushNamed('/edit-pessoa', arguments: {
                                  'model': model,
                                  'route': route,
                                });
                              },
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              // Criando um botão de deletar pessoa, no container da mesma
                              child: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                              onTap: () {
                                onDelete!(model);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("$output excluído"),
                                ));
                              },
                            ),
                          ]
                      )
                  )
                ],
              )
          )
        ]
    );
  }
}
