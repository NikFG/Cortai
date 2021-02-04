import "package:cortai/Dados/cabeleireiro.dart";

class Servico {
  int id;
  String descricao;
  double _valor;
  String imagem;
  List<int> cabeleireiros;
  List<Cabeleireiro> cabeleireirosApi;
  int salaoId;
  String observacao;
  bool ativo;

  Servico();

  double get valor => _valor;

  String valorFormatado() {
    return "R\$${valor.toStringAsFixed(2).replaceAll(".", ",")}";
  }

  void setValor(String valor) {
    valor = valor.replaceAll("R\$", "");
    valor = valor.replaceAll(".", "");
    valor = valor.replaceAll(",", ".");
    this._valor = double.parse(valor);
  }

  Servico.fromJsonApi(Map<String, dynamic> servico) {
    id = servico["id"];
    descricao = servico.containsKey("pivot")
        ? servico["pivot"]["descricao"]
        : servico["nome"];
    _valor = servico.containsKey("pivot")
        ? (servico["pivot"]["valor"] as num).toDouble()
        : (servico["valor"] as num).toDouble();
    imagem = servico["imagem"];
    observacao = servico["observacao"] ?? "";
    cabeleireirosApi = servico["cabeleireiros"] != null
        ? List.from(servico["cabeleireiros"])
            .map((e) => Cabeleireiro.fromJson(e))
            .toList()
        : null;
    ativo = servico["deleted_at"] == null;
    salaoId = servico["salao_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": descricao,
      "valor": _valor,
      "salao_id": salaoId,
      "cabeleireiros": cabeleireiros,
      "observacao": observacao,
      "ativo": ativo,
    };
  }
}
