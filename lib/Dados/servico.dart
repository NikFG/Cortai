import "package:cortai/Dados/cabeleireiro.dart";
import 'package:json_annotation/json_annotation.dart';

part 'servico.g.dart';

@JsonSerializable(createFactory: false)
class Servico {
  int? id;
  @JsonKey(name: 'nome')
  String? descricao;
  @JsonKey(name: 'valor')
  late double _valor;
  String? imagem;
  @JsonKey(ignore: true)
  List<int>? cabeleireiros;
  @JsonKey(name: "cabeleireiros", toJson: _cabeleireiroToJson)
  List<Cabeleireiro>? cabeleireirosApi;
  @JsonKey(name: 'salao_id')
  int? salaoId;
  String? observacao;

  bool? ativo;

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

  Map<String, dynamic> toJson() => _$ServicoToJson(this);

  Map<String, dynamic> toJsonGaleria() {
    return {
      "id": id,
      "nome": descricao,
      "valor": _valor,
      "salao_id": salaoId,
      "observacao": observacao,
      "ativo": ativo,
    };
  }

  static _cabeleireiroToJson(List<Cabeleireiro>? cabeleireiros) =>
      cabeleireiros!.map((e) => e.toJson()).toList();
}
