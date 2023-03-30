class DisciplinaModel {
  late String? nome;
  late String? codigo;
  late String? semestre;

  DisciplinaModel({
    this.nome,
    this.codigo,
    this.semestre,
  });

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "nome" : nome,
      "codigo" : codigo,
      "semestre" : semestre,
    };
  }
}