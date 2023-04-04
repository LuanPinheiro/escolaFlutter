class MatriculadosModel {
  late String? codigo_disciplina;
  late int? matricula_aluno;

  MatriculadosModelArgs(
    codigo_disciplina,
    matricula_aluno,
  ){
    this.codigo_disciplina = codigo_disciplina;
    this.matricula_aluno = matricula_aluno;
  }

  MatriculadosModel({
    this.codigo_disciplina,
    this.matricula_aluno,
  });

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "codigo_disciplina" : codigo_disciplina,
      "matricula_aluno" : matricula_aluno,
    };
  }
}