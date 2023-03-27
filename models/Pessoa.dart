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

  Pessoa.fromJson(Map<String, dynamic> json) {
    nome = json["nome"];
    cpf = json["cpf"];
    sexo = json["sexo"];
    matricula = addMatricula();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['nome'] = nome;
    _data['cpf'] = cpf;
    _data['sexo'] = sexo;
    _data['matricula'] = matricula;

    return _data;
  }

  addMatricula(){
    matricula = 0;
  }

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "nome" : nome,
      "cpf" : cpf,
      "sexo" : sexo,
      "matricula": matricula,
    };
  }
}