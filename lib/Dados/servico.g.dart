// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ServicoToJson(Servico instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.descricao,
      'imagem': instance.imagem,
      'cabeleireiros': Servico._cabeleireiroToJson(instance.cabeleireirosApi),
      'salao_id': instance.salaoId,
      'observacao': instance.observacao,
      'ativo': instance.ativo,
      'valor': instance.valor,
    };
