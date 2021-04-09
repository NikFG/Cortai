// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Salao _$SalaoFromJson(Map<String, dynamic> json) {
  return Salao()
    ..id = json['id'] as int?
    ..nome = json['nome'] as String?
    ..endereco = json['endereco'] as String?
    ..telefone = json['telefone'] as String?
    ..imagem = json['imagem'] as String?
    ..cidade = json['cidade'] as String?
    ..latitude = Conversao.strToDouble(json['latitude'])
    ..longitude = Conversao.strToDouble(json['longitude'])
    ..menorValorServico = Conversao.strToDouble(json['menor_valor'])
    ..maiorValorServico = Conversao.strToDouble(json['maior_valor'])
    ..quantidadeAvaliacao = json['qtd_avaliacao'] as int?
    ..mediaAvaliacao = Conversao.strToDouble(json['media'])
    ..distancia = Conversao.intToDouble(json['distancia']);
}
