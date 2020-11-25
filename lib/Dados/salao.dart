import 'dart:io';

import 'package:cortai/Util/util.dart';

class Salao {
  int id;
  String nome;
  String endereco;
  String telefone;
  String imagem;
  File img;
  String cidade;
  double latitude;
  double longitude;
  double menorValorServico;
  double maiorValorServico;
  int quantidadeAvaliacao;
  double mediaAvaliacao;
  double distancia;

  Salao();

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "latitude": latitude,
      "longitude": longitude,
      "cidade": cidade,
    };
  }

  Salao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    imagem = json['imagem'] != null ? Util.storage_url + json['imagem'] : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    cidade = json['cidade'];
    menorValorServico = (json['menor_valor'] as num).toDouble();
    maiorValorServico = (json['maior_valor'] as num).toDouble();
    quantidadeAvaliacao = json['qtd_avaliacao'];
    mediaAvaliacao = (json['media'] as num).toDouble();
    distancia = double.parse(json['distancia']);
  }

  Salao.fromJsonApiDados(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    imagem = json['imagem'] != null ? Util.storage_url + json['imagem'] : null;
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
}
