class Cabeleireiro {
  int id;
  String nome;
  int salaoId;

  Cabeleireiro();

  Cabeleireiro.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    salaoId = map['salao_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "salao": salaoId,
    };
  }

  @override
  bool operator ==(dados) {
    return dados is Cabeleireiro && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
