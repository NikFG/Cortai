import 'package:cortai/Util/conversao.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avaliacao.g.dart';

@JsonSerializable()
class Avaliacao {
  int id;
  @JsonKey(fromJson: Conversao.strToDouble)
  double valor;
  @JsonKey(defaultValue: "")
  String observacao;
  String data;
  @JsonKey(name: 'horario_id')
  int horarioId;

  Avaliacao();

  factory Avaliacao.fromJson(Map<String, dynamic> json) =>
      _$AvaliacaoFromJson(json);


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "valor": valor,
      "descricao": observacao,
      "data": data.replaceAll("/", '-'),
      "horario_id": horarioId,
    };
  }
}
