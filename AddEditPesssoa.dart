import 'package:escolaflutter/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'models/Pessoa.dart';
import 'Validar.dart';
import 'nightmode.dart';

class AddEditPessoa extends StatefulWidget {
  @override
  State<AddEditPessoa> createState() => _AddEditPessoaState();
}

class _AddEditPessoaState extends State<AddEditPessoa> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool? checkF = true;
  bool? checkM = false;
  bool? checkI = false;
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
            backgroundColor: mainColor,
          ),
          backgroundColor: bgColor,
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

        if(model!.sexo != null) {
          if(model!.sexo == "Masculino"){
            checkF = false;
            checkM = true;
          }
          else if(model!.sexo == "Intersexo"){
            checkI = true;
            checkF = false;
          }
        }
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
                  else if(temNumeros(onValidateVal)){
                    return "O campo nome não pode ter números";
                  }
                  if(onValidateVal.toString().length < 3){
                    return "O campo nome deve ter no mínimo 3 letras";
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
                  if(temCaracteres(onValidateVal) == true){
                    return "CPF com apenas números";
                  }
                  if(onValidateVal.length != 11){
                    return "CPF deve ter 11 números";
                  }
                  if(digitosVerificadores(onValidateVal) == false){
                    return "CPF Inválido";
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          value: checkF,
                          onChanged: (value){
                            setState(() {
                              checkF = value;
                              checkM = false;
                              checkI = false;
                            });
                          }),
                      Text("Feminino"),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          value: checkM,
                          onChanged: (value){
                            setState(() {
                              checkM = value;
                              checkF = false;
                              checkI = false;
                            });
                          }),
                      Text("Masculino"),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          value: checkI,
                          onChanged: (value){
                            setState(() {
                              checkI = value;
                              checkM = false;
                              checkF = false;
                            });
                          }),
                      Text("Intersexo"),
                    ],
                  ),
                ],
              )
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

                  if(checkF == true){
                    model!.sexo = "Feminino";
                  }
                  else if(checkM == true){
                    model!.sexo = "Masculino";
                  }
                  else{
                    model!.sexo = "Intersexo";
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
}
