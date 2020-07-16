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
