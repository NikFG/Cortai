import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Util/util.dart';

class Servico {
  int id;
  String descricao;
  double _valor;
  String imagemUrl;
  List<String> cabeleireiros;
  List<Cabeleireiro> cabeleireiros_api;
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

  Servico.fromJson(Map<String, dynamic> servico) {
    id = servico['id'];
    descricao = servico["nome"];
    _valor = servico["valor"];
    imagemUrl = Util.storage_url + servico["imagem"];
    cabeleireiros_api = List.from(servico['cabeleireiros'])
        .map((e) => Cabeleireiro.fromJson(e))
        .toList();
    observacao = servico['observacao'];
    ativo = servico['ativo'];
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
    this.id = id as num;
    descricao = map["descricao"];
    _valor = (map["valor"] as num).toDouble();
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
