class Funcionamento {
  int id;
  String diaSemana;
  String horarioAbertura;
  String horarioFechamento;
  int intervalo;
  int salaoId;

  Funcionamento();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dia_semana": diaSemana,
      "horario_abertura": horarioAbertura,
      "horario_fechamento": horarioFechamento,
      "intervalo": intervalo,
      "salao_id": salaoId
    };
  }

  Funcionamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diaSemana = json['dia_semana'];
    horarioAbertura = json['horario_abertura'];
    horarioFechamento = json['horario_fechamento'];
    intervalo = json['intervalo'];
    salaoId = json['salao_id'];
  }
}
