import 'package:cloud_firestore/cloud_firestore.dart';

class Servico {
  String id;
  String descricao;
  double _valor;
  String imagemUrl;
  List<String> cabeleireiros;
  String salao;
  String observacao;

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
  }

  Servico.fromHorarioJson(Map<String, dynamic> json) {
    if (json['servico'] != null) {
      id = json['data']['servico'];
      descricao = json['servico']["descricao"];
      _valor = (json['servico']["valor"] as num).toDouble();
      imagemUrl = json['servico']["imagemUrl"];
      cabeleireiros = List.from(json['servico']['cabeleireiros']);
      salao = json['servico']['salao'];
      observacao = json['servico']['observacao'] != null
          ? json['servico']['observacao']
          : '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": _valor,
      "imagemUrl": imagemUrl,
      'salao': salao,
      'cabeleireiros': cabeleireiros,
      'observacao': observacao,
    };
  }
}
