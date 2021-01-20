import 'package:json_annotation/json_annotation.dart';

part 'cabeleireiro.g.dart';

@JsonSerializable()
class Cabeleireiro {
  int id;
  String nome;
  @JsonKey(name: 'salao_id')
  int salaoId;

  Cabeleireiro();

  factory Cabeleireiro.fromJson(Map<String, dynamic> json) =>
      _$CabeleireiroFromJson(json);

  Cabeleireiro.fromJson2(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    salaoId = map['salao_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "salao": salaoId,
    };
  }

  @override
  bool operator ==(dados) {
    return dados is Cabeleireiro && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
