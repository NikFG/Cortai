import 'package:cortai/Util/conversao.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salao.g.dart';

@JsonSerializable(createToJson: false)
class Salao {
  int? id;
  String? nome;
  String? endereco;
  String? telefone;
  String? imagem;
  String? cidade;
  @JsonKey(fromJson: Conversao.strToDouble)
  double? latitude;
  @JsonKey(fromJson: Conversao.strToDouble)
  double? longitude;
  @JsonKey(name: 'menor_valor', fromJson: Conversao.strToDouble)
  double? menorValorServico;
  @JsonKey(name: 'maior_valor', fromJson: Conversao.strToDouble)
  double? maiorValorServico;
  @JsonKey(name: 'qtd_avaliacao')
  int? quantidadeAvaliacao;
  @JsonKey(name: 'media', fromJson: Conversao.strToDouble)
  double? mediaAvaliacao;
  @JsonKey(fromJson: Conversao.intToDouble)
  double? distancia;

  Salao();

  factory Salao.fromJson(Map<String, dynamic> json) => _$SalaoFromJson(json);

  Salao.fromJsonApiDados(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    imagem = json['imagem'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cidade = json['cidade'];
  }

  @override
  String toString() {
    return 'SalaoDados{id: $id, nome: $nome, endereco: $endereco, '
        'telefone: $telefone, imagem: $imagem, cidade: $cidade, '
        'latitude: $latitude, longitude: $longitude}';
  }

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "latitude": latitude,
      "longitude": longitude,
      "cidade": cidade,
    };
  }
}
