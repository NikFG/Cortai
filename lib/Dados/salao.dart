import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';

class Salao {
  String id;
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
  double totalAvaliacao;
  double mediaAvaliacao;
  double distancia;

  Salao();

/*  Salao.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data['nome'];
    endereco = snapshot.data['endereco'];
    telefone = snapshot.data['telefone'];
    imagem = snapshot.data['imagem'];
    latitude = snapshot.data['latitude'];
    longitude = snapshot.data['longitude'];
    cidade = snapshot.data['cidade'];
    menorValorServico = (snapshot.data['menorValorServico'] as num).toDouble();
    maiorValorServico = (snapshot.data['maiorValorServico'] as num).toDouble();
    quantidadeAvaliacao = snapshot.data['quantidadeAvaliacao'] as num;
    totalAvaliacao = (snapshot.data['totalAvaliacao'] as num).toDouble();
  }*/
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
    print(json);
    id = json['id'];
    nome = json['data']['nome'];
    endereco = json['data']['endereco'];
    telefone = json['data']['telefone'];
    imagem = json['data']['imagem'];
    latitude = json['data']['latitude'];
    longitude = json['data']['longitude'];
    cidade = json['data']['cidade'];
    menorValorServico = (json['data']['menorValorServico'] as num).toDouble();
    maiorValorServico = (json['data']['maiorValorServico'] as num).toDouble();
    quantidadeAvaliacao = json['data']['quantidadeAvaliacao'] as num;
    totalAvaliacao = (json['data']['totalAvaliacao'] as num).toDouble();
  }

  Salao.fromJsonApi(Map<String, dynamic> json) {
    id = json['id'].toString();
    nome = json['nome'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    imagem = json['imagem'] != null ? Util.storage_url + json['imagem'] : null;
    print(imagem);
    latitude = json['latitude'];
    longitude = json['longitude'];
    cidade = json['cidade'];
    menorValorServico = (json['menor_valor'] as num).toDouble();
    maiorValorServico = (json['maior_valor'] as num).toDouble();
    quantidadeAvaliacao = json['qtd_avaliacao'];
    mediaAvaliacao = (json['media'] as num).toDouble();
    distancia = double.parse(json['distancia']);
  }

  @override
  String toString() {
    return 'SalaoDados{id: $id, nome: $nome, endereco: $endereco, '
        'telefone: $telefone, imagem: $imagem, cidade: $cidade, '
        'latitude: $latitude, longitude: $longitude}';
  }
}
