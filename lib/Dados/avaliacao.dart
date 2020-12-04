class Avaliacao {
  int id;
  double valor;
  String observacao;
  String data;
  int horarioId;

  Avaliacao();

  Avaliacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valor = (json['valor'] as num).toDouble();
    observacao = json['observacao'] != null ? json['observacao'] : '';
    data = json['data'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "valor": valor,
      "descricao": observacao,
      "data": data.replaceAll("/", '-'),
      "horario_id": horarioId,
    };
  }
}
