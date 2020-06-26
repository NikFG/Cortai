import 'package:agendacabelo/Dados/servico_dados.dart';
import 'package:agendacabelo/Telas/agenda_tela.dart';
import 'package:agendacabelo/Widgets/hero_custom.dart';
import 'package:flutter/material.dart';

class ServicoTile extends StatelessWidget {
  final ServicoDados dados;
  final String imgPadrao =
      "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80";

  ServicoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
      height: 100,
      child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AgendaTela(this.dados))),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HeroCustom(
                            imagemUrl: dados.imagemUrl != null
                                ? dados.imagemUrl
                                : imgPadrao,
                            descricao: dados.descricao,
                          )));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  backgroundImage: NetworkImage(
                      dados.imagemUrl != null ? dados.imagemUrl : imgPadrao,
                      scale: 2.0),
                ),
              ),
              title: Text(
                dados.descricao,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black, fontSize: 20.0, fontFamily: 'Poppins'),
              ),
              subtitle: Text(
                "R\$${dados.valor.toStringAsFixed(2).replaceAll('.', ',')}",
                style: TextStyle(
                    fontSize: 14, color: Colors.black87, fontFamily: 'Poppins'),
              ),
            ),
          )),
    );
  }
}
