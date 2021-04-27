// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'galeria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Galeria _$GaleriaFromJson(Map<String, dynamic> json) {
  return Galeria()
    ..id = json['id'] as int?
    ..descricao = json['descricao'] as String
    ..imagem = json['imagem'] as String?
    ..servico =
        Galeria._servicoFromJSon(json['servico'] as Map<String, dynamic>)
    ..salao = Galeria._salaoFromJson(json['salao'] as Map<String, dynamic>)
    ..cabeleireiro = Galeria._cabeleireiroFromJson(
        json['cabeleireiro'] as Map<String, dynamic>)
    ..cliente =
        Galeria._clienteoFromJson(json['cliente'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GaleriaToJson(Galeria instance) => <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'imagem': instance.imagem,
      'servico': Galeria._servicoToJson(instance.servico),
      'salao': Galeria._salaoToJson(instance.salao),
      'cabeleireiro': Galeria._cabeleireiroToJson(instance.cabeleireiro),
      'cliente': Galeria._clienteToJson(instance.cliente),
    };
