class DisciplinaModel {
  late String? nome;
  late String? codigo;
  late String? semestre;
  late int? prof_matricula;

  DisciplinaModel({
    this.nome,
    this.codigo,
    this.semestre,
    this.prof_matricula,
  });

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "nome" : nome,
      "codigo" : codigo,
      "semestre" : semestre,
      "prof_matricula" : prof_matricula,
    };
  }
}