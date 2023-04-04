import 'package:escolaflutter/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'models/DisciplinaModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Validar.dart';

class AddEditDisciplina extends StatefulWidget {
  @override
  State<AddEditDisciplina> createState() => _AddEditDisciplina();
}

class _AddEditDisciplina extends State<AddEditDisciplina> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAPICallProcess = false;
  DisciplinaModel? model;
  bool isEditMode = false;
  String route = "";
  String? selected;
  String profAtual = "Professores";

  // Carrega do banco de dados os alunos em uma lista alunos
  Widget loadProfessores(){ // MODULARIZAR ESTA FUNÇÃO
    return FutureBuilder(
      future: ApiSql().fetchPessoas("professores"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> professores) {
        if(professores.hasData){
          return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                  title: Text(profAtual),
                  enabled: true,
                  trailing: const Icon(Icons.arrow_drop_down),
                  shape: const OutlineInputBorder(),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Escolha um professor"),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: CupertinoScrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: professores.data?.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      professores.data![index].nome,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onTap: () {
                                      model!.prof_matricula = professores.data![index].matricula;
                                      setState(() {
                                        profAtual = professores.data![index].nome;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }),
                          ),
                        ),
                      ),
                    );
                  }));
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
          backgroundColor: Colors.white,
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

        model = arguments["model"] != null ? arguments["model"] : DisciplinaModel();
        route = arguments["route"] != null ? arguments["route"] : null;
        if(rotaAtual == "/edit-pessoa" || rotaAtual == "/edit-disciplina"){
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
                "Nome da Disciplina",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo nome não pode ser vazio";
                  }
                  else if(temNumeros(onValidateVal)){
                    return "O campo nome não pode ter números";
                  }
                  if(onValidateVal.length < 3){
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
                "codigo",
                "Código da Disciplina",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo código não pode ser vazio";
                  }
                  return null;
                },
                    (onSavedVal) {
                  model!.codigo = onSavedVal;
                },
                initialValue: model!.codigo == null ? "" : model!.codigo.toString(),
                // Abaixo configurações das cores do formulário
                borderColor: isEditMode ? Colors.grey : Colors.black,
                borderFocusColor: isEditMode ? Colors.grey : Colors.black,
                textColor: isEditMode ? Colors.grey : Colors.black,
                hintColor: Colors.black.withOpacity(.7),
                isReadonly: isEditMode ? true : false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "semestre",
                "Semestre da Disciplina",
                    (onValidateVal) {
                  if(onValidateVal.isEmpty){
                    return "O campo Sexo não pode ser vazio";
                  }
                  return null;
                },
                    (onSavedVal) {
                  model!.semestre = onSavedVal;
                },
                initialValue: model!.semestre == null ? "" : model!.semestre.toString(),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: loadProfessores(),
            ),
            Divider(
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(model!.codigo == null ? "Adicionar" : "Atualizar", () {
                if(validateAndSave()){
                  if(isEditMode){
                    ApiSql().updateDisciplina(model!.codigo, model!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Disciplina Atualizada"),
                    ));
                  }
                  else{
                    ApiSql().addDisciplina(model!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Disciplina Adicionada"),
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
