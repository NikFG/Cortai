class Cliente {
  int id;
  String nome;

  Cliente();

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }
}
