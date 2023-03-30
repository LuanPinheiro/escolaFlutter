import 'package:escolaflutter/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'models/Pessoa.dart';

class AddEditPessoa extends StatefulWidget {
  @override
  State<AddEditPessoa> createState() => _AddEditPessoaState();
}

class _AddEditPessoaState extends State<AddEditPessoa> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAPICallProcess = false;
  Pessoa? model;
  bool isEditMode = false;
  String route = "";


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // Scaffold de página de adicionar nova pessoa
          appBar: AppBar(
            title: const Text("Adicionar/Editar"),
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: Colors.grey,
          body: ProgressHUD(
            child: Form(
              key: globalKey,
              child: pessoaForm(),
            ),
            inAsyncCall: isAPICallProcess,
            opacity: .3,
            key: UniqueKey(),
          ),
        )
    );
  }

  @override
  void initState(){
    super.initState();

    Future.delayed(Duration.zero, () {
      if(ModalRoute.of(context)?.settings.arguments != null){
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        final rotaAtual = ModalRoute.of(context)!.settings.name;

        model = arguments["model"] != null ? arguments["model"] : Pessoa();
        route = arguments["route"] != null ? arguments["route"] : null;
        if(rotaAtual == "/edit-pessoa"){
          isEditMode = true;
        }
        setState(() {});
      }
    });
  }

  Widget pessoaForm() {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caixa de entrada de nome
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "nome",
                "Nome da Pessoa",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo nome não pode ser vazio";
                  }
                  return null;
                },
                    (onSavedVal) => {
                  model!.nome = onSavedVal,
                },
                initialValue: model!.nome == null ? "" : model!.nome.toString(),
                // Abaixo configurações das cores do formulário
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(.7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "cpf",
                "CPF da Pessoa",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo CPF não pode ser vazio";
                  }
                  return null;
                },
                    (onSavedVal) {
                  model!.cpf = onSavedVal;
                },
                initialValue: model!.cpf == null ? "" : model!.cpf.toString(),
                // Abaixo configurações das cores do formulário
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(.7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "sexo",
                "Sexo da Pessoa",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo Sexo não pode ser vazio";
                  }
                  return null;
                },
                    (onSavedVal) {
                  model!.sexo = onSavedVal;
                },
                initialValue: model!.sexo == null ? "" : model!.sexo.toString(),
                // Abaixo configurações das cores do formulário
                borderColor: Colors.black,
                borderFocusColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(.7),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(model!.matricula == null ? "Adicionar" : "Atualizar", () {
                if(validateAndSave()){
                  String table = "";
                  String output = "";
                  if(route == "/alunos"){
                    table = "alunos";
                    output = "Aluno";
                  }
                  else{
                    table = "professores";
                    output = "Professor";
                  }

                  if(isEditMode){
                    ApiSql().updatePessoa(model!.matricula, model!, table);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("$output Atualizado"),
                    ));
                  }
                  else{
                    ApiSql().addPessoa(model!, table);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("$output Adicionado"),
                    ));
                  }
                  Navigator.pushNamedAndRemoveUntil(context, route!, ModalRoute.withName('/'));
                }
              },
              btnColor: Colors.red,
              ),
            )
          ]
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }

    return false;
  }

  // Widget que mostra um texto confirmando o salvamento
  Widget textSave(){
    return Center(
      child: Text("Salvo"),
    );
  }
}
