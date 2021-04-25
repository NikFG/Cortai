import 'package:cortai/Util/conversao.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avaliacao.g.dart';

@JsonSerializable()
class Avaliacao {
  int? id;
  @JsonKey(fromJson: Conversao.strToDouble)
  late double valor;
  @JsonKey(defaultValue: "")
  String? observacao;
  @JsonKey(toJson: _dataToJson)
  late String data;
  @JsonKey(name: 'horario_id')
  late int horarioId;

  Avaliacao();

  factory Avaliacao.fromJson(Map<String, dynamic> json) =>
      _$AvaliacaoFromJson(json);

  Map<String, dynamic> toJson() => _$AvaliacaoToJson(this);

  static String _dataToJson(String? data) => data!.replaceAll("/", "-");
}
