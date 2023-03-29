class Pessoa {
  late String? nome;
  late int? matricula;
  late String? cpf;
  late String? sexo;

  Pessoa({
    this.nome,
    this.matricula,
    this.cpf,
    this.sexo,
  });

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "nome" : nome,
      "cpf" : cpf,
      "sexo" : sexo,
      "matricula": matricula,
    };
  }
}