// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login(
    nome: json['nome'] as String,
    salaoId: json['salao_id'] as int?,
    telefone: json['telefone'] as String?,
    email: json['email'] as String,
    imagem: json['imagem'] as String,
    isCabeleireiro: Conversao.trataBool(json['is_cabeleireiro'] as int?),
    isDonoSalao: Conversao.trataBool(json['is_dono_salao'] as int?),
    id: json['id'] as int?,
    senha: json['password'] as String,
    isGoogle: Conversao.trataBool(json['is_google'] as int?),
  );
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'salao_id': instance.salaoId,
      'telefone': instance.telefone,
      'email': instance.email,
      'imagem': instance.imagem,
      'is_cabeleireiro': instance.isCabeleireiro,
      'is_dono_salao': instance.isDonoSalao,
      'is_google': instance.isGoogle,
      'password': instance.senha,
    };
