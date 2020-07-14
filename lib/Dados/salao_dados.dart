import 'package:cloud_firestore/cloud_firestore.dart';

class SalaoDados {
  String id;
  String nome;
  String endereco;
  String telefone;
  String imagem;
  String cidade;
  double latitude;
  double longitude;
  double menorValorServico;
  double maiorValorServico;
  int quantidadeAvaliacao;
  double totalAvaliacao;

  SalaoDados();

  SalaoDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    nome = snapshot.data['nome'];
    endereco = snapshot.data['endereco'];
    telefone = snapshot.data['telefone'];
    imagem = snapshot.data['imagem'];
    latitude = snapshot.data['latitude'];
    longitude = snapshot.data['longitude'];
    cidade = snapshot.data['cidade'];
    menorValorServico = snapshot.data['menorValorServico'];
    maiorValorServico = snapshot.data['maiorValorServico'];
    quantidadeAvaliacao = snapshot.data['quantidadeAvaliacao'];
    totalAvaliacao = snapshot.data['totalAvaliacao'];
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "imagem": imagem,
      "latitude": latitude,
      "longitude": longitude,
      "cidade": cidade,
      'menorValorServico': menorValorServico,
      "maiorValorServico": maiorValorServico,
      "quantidadeAvaliacao": quantidadeAvaliacao,
      "totalAvaliacao": totalAvaliacao,
    };
  }

  SalaoDados.fromJson(Map<String, dynamic> json) {
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
    quantidadeAvaliacao = json['data']['quantidadeAvaliacao'];
    totalAvaliacao = json['data']['totalAvaliacao'] != null
        ? (json['data']['totalAvaliacao'] as num).toDouble()
        : 0;
  }

  @override
  String toString() {
    return 'SalaoDados{id: $id, nome: $nome, endereco: $endereco, telefone: $telefone, imagem: $imagem, cidade: $cidade, latitude: $latitude, longitude: $longitude}';
  }
}
