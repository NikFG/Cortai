import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Telas/criar_servico_tela.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class GerenciaServicoTile extends StatelessWidget {
  final Servico dados;

  GerenciaServicoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      color: dados.ativo?Theme.of(context).cardColor:Colors.grey[300],
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarServicoTela(
                dados: dados,
                titulo: "Editar Serviço",
              ))),
      leading: dados.imagemUrl != null
          ? CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(dados.imagemUrl),
            )
          : CircleAvatar(
              radius: 30,
            ),
      title: Text(
        dados.descricao,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(
        dados.observacao,
        style: TextStyle(),
        maxLines: 3,
      ),
      trailing: Text(
        "R\$${dados.valor.toStringAsFixed(2).replaceAll('.', ',')}",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
