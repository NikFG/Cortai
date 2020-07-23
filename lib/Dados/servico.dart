import 'package:cloud_firestore/cloud_firestore.dart';

class Servico {
  String id;
  String descricao;
  double _valor;
  String imagemUrl;
  List<String> cabeleireiros;
  String salao;
  String observacao;
  bool ativo;

  Servico();

  double get valor => _valor;

  String valorFormatado() {
    return "R\$${valor.toStringAsFixed(2).replaceAll('.', ',')}";
  }

  void setValor(String valor) {
    valor = valor.replaceAll("R\$", "");
    valor = valor.replaceAll(".", "");
    valor = valor.replaceAll(",", ".");
    this._valor = double.parse(valor);
  }

  Servico.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    descricao = snapshot.data["descricao"];
    _valor = snapshot.data["valor"];
    imagemUrl = snapshot.data["imagemUrl"];
    cabeleireiros = List.from(snapshot.data['cabeleireiros']);
    salao = snapshot.data['salao'];
    observacao =
        snapshot.data['observacao'] != null ? snapshot.data['observacao'] : '';
    ativo = snapshot.data['ativo'];
  }

  Servico.fromHorarioJson(Map<String, dynamic> json) {
    if (json['data']['servico'] != null &&
        json['data']['servico_map'] != null) {
      id = json['data']['servico'];
      descricao = json['data']['servico_map']["descricao"];
      _valor = (json['data']['servico_map']["valor"] as num).toDouble();
      imagemUrl = json['data']['servico_map']["imagemUrl"];
      cabeleireiros = List.from(json['data']['servico_map']['cabeleireiros']);
      salao = json['data']['servico_map']['salao'];
      observacao = json['data']['servico_map']['observacao'] != null
          ? json['data']['servico_map']['observacao']
          : '';
      ativo = json['data']['servico_map']['ativo'];
    }
  }

  Servico.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    descricao = map["descricao"];
    _valor = map["valor"];
    imagemUrl = map["imagemUrl"];
    salao = map['salao'];
    observacao = map['observacao'] != null ? map['observacao'] : '';
    ativo = map['ativo'];
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": _valor,
      "imagemUrl": imagemUrl,
      'salao': salao,
      'cabeleireiros': cabeleireiros,
      'observacao': observacao,
      'ativo': ativo,
    };
  }
}
