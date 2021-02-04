import 'package:json_annotation/json_annotation.dart';

part 'cliente.g.dart';

@JsonSerializable()
class Cliente {
  int id;
  String nome;

  Cliente();

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);

  Map<String, dynamic> toJson() => _$ClienteToJson(this);
}
