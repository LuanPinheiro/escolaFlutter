import 'Pessoa.dart';

class AlunoModel extends Pessoa{
  static int matriculaNova = 1000;

  @override
  addMatricula(){
    matriculaNova++;
    return matriculaNova;
  }
}