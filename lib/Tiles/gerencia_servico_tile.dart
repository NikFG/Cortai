import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Telas/criar_servico_tela.dart';
import 'package:agendacabelo/Widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class GerenciaServicoTile extends StatelessWidget {
  final Servico dados;

  GerenciaServicoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
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
            color: Colors.black, fontSize: 20.0, fontFamily: 'Poppins'),
      ),
      subtitle: Text(
        dados.observacao,
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
        maxLines: 3,
      ),
      trailing: Text(
        "R\$${dados.valor.toStringAsFixed(2).replaceAll('.', ',')}",
        style: TextStyle(
            fontSize: 14, color: Colors.black87, fontFamily: 'Poppins'),
      ),
    );
  }
}
