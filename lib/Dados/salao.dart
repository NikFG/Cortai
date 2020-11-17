import 'package:cloud_firestore/cloud_firestore.dart';

class Salao {
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
  double mediaAvaliacao;

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
    imagem = json['imagem'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cidade = json['cidade'];
    menorValorServico = json['menor'];
    maiorValorServico = json['maior'];
    quantidadeAvaliacao = json['qtd_avaliacao'];
    mediaAvaliacao = json['media'];
  }

  @override
  String toString() {
    return 'SalaoDados{id: $id, nome: $nome, endereco: $endereco, telefone: $telefone, imagem: $imagem, cidade: $cidade, latitude: $latitude, longitude: $longitude}';
  }
}
