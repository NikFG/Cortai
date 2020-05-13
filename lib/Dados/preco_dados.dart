import 'package:cloud_firestore/cloud_firestore.dart';

class PrecoDados {
  String id;
  String descricao;
  double valor;
  String imagemUrl;
  List<String> cabeleireiros;
  String salao;

  void setValor(String valor) {
    valor = valor.replaceAll("R\$", "");
    valor = valor.replaceAll(".", "");
    valor = valor.replaceAll(",", ".");
    this.valor = double.parse(valor);
  }

  PrecoDados();

  PrecoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    descricao = snapshot.data["descricao"];
    valor = snapshot.data["valor"];
    imagemUrl = snapshot.data["imagemUrl"];
    cabeleireiros = List.from(snapshot.data['cabeleireiros']);
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": valor,
      "imagemUrl": imagemUrl,
      'salao': salao,
      'cabeleireiros': cabeleireiros,
    };
  }


}
