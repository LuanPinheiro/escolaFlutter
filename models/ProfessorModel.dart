import 'Pessoa.dart';

class ProfessorModel extends Pessoa{
  static int matriculaNova = 10000;

  @override
  addMatricula(){
    matriculaNova++;
    return matriculaNova;
  }
}