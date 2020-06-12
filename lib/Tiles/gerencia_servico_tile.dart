import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Telas/criar_servico_tela.dart';
import 'package:flutter/material.dart';

class GerenciaServicoTile extends StatelessWidget {
  final ServicoDados dados;

  GerenciaServicoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CriarServicoTela(
                dados: dados,
            titulo: "Editar Serviço",
              ))),
      leading: CircleAvatar(
        child: Image.network(dados.imagemUrl),
      ),
      title: Text(dados.descricao),
      subtitle: Text(dados.valor.toStringAsFixed(2)),
    );
  }
}
