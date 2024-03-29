import "package:json_annotation/json_annotation.dart";

part "cabeleireiro.g.dart";

@JsonSerializable()
class Cabeleireiro {
  late int id;
  late String nome;
  @JsonKey(name: "salao_id")
  late int salaoId;

  Cabeleireiro();

  factory Cabeleireiro.fromJson(Map<String, dynamic> json) =>
      _$CabeleireiroFromJson(json);

  Map<String, dynamic> toJson() => _$CabeleireiroToJson(this);

  @override
  bool operator ==(dados) {
    return dados is Cabeleireiro && dados.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
