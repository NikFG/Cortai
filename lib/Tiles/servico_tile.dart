import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Telas/agenda_tela.dart';
import 'package:agendacabelo/Widgets/hero_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServicoTile extends StatelessWidget {
  final ServicoDados dados;
  final String nomeSalao;
  final String imgPadrao =
      "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80";

  ServicoTile(this.dados, this.nomeSalao);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AgendaTela(this.dados, this.nomeSalao))),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HeroCustom(
                    imagemUrl:
                        dados.imagemUrl != null ? dados.imagemUrl : imgPadrao,
                    descricao: dados.descricao,
                  )));
        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 30,
          backgroundImage: dados.imagemUrl != null
              ? NetworkImage(dados.imagemUrl, scale: 2.0)
              : AssetImage("assets/images/barbearia.png"),
        ),
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
