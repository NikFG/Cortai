import 'package:cloud_firestore/cloud_firestore.dart';

class PrecoDados {
  String id;
  String descricao;
  double valor;
  String imagemUrl;

  void setValor(String valor){
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
  }

  Map<String, dynamic> toMap() {
    return {
      "descricao": descricao,
      "valor": valor,
      "imagemUrl": imagemUrl
    };
  }
  Future precoFuture(String cabelereiro_id) async{
    return await Firestore.instance
        .collection("usuarios")
        .document(cabelereiro_id)
        .collection("precos")
        .getDocuments();
  }
}
