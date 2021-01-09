class FormaPagamento {
  int id;
  String icone;
  String descricao;

/*  FormaPagamento.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    icone = snapshot.data['icone'];
    descricao = snapshot.data['descricao'];
  }*/
  FormaPagamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icone = json['imagem'] != null ? json['imagem'] : '';
    descricao = json['descricao'];
  }
}
