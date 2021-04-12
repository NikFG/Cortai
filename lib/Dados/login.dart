import "package:cortai/Util/conversao.dart";
import "package:json_annotation/json_annotation.dart";

part "login.g.dart";

@JsonSerializable()
class Login {
  int? id;
  String nome;
  @JsonKey(name: "salao_id")
  int? salaoId;
  String? telefone;
  String email;
  String? imagem;
  @JsonKey(name: "is_cabeleireiro", fromJson: Conversao.trataBool)
  bool isCabeleireiro;
  @JsonKey(name: "is_dono_salao", fromJson: Conversao.trataBool)
  bool isDonoSalao;
  @JsonKey(name: "is_google", fromJson: Conversao.trataBool)
  bool isGoogle;
  @JsonKey(name: 'password')
  String senha;

  Login(
      {required this.nome,
      required this.salaoId,
      this.telefone,
      required this.email,
      required this.imagem,
      required this.isCabeleireiro,
      required this.isDonoSalao,
      this.id,
      required this.senha,
      this.isGoogle = false});

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  @override
  String toString() {
    return "LoginDados{id: $id, nome: $nome, telefone: $telefone, email: "
        "$email, imagemUrl: $imagem, isCabeleireiro: "
        "$isCabeleireiro, isDonoSalao: $isDonoSalao}";
  }

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
