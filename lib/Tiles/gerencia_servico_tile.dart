import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Telas/criar_servico_tela.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class GerenciaServicoTile extends StatelessWidget {
  final Servico dados;
  final bool isDonoSalao;
  final String id;

  GerenciaServicoTile(
      {@required this.dados, @required this.isDonoSalao, @required this.id});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      color: dados.ativo ? Theme.of(context).cardColor : Colors.grey[300],
      onTap: () {
        if (this.isDonoSalao || dados.cabeleireiros.contains(id))
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CriarServicoTela(
                    dados: dados,
                    titulo: "Editar Serviço",
                  )));
        else {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => AlertDialog(
                    content:  Text(
                        "Peça permissão ao gerente para poder acessar este corte e editá-lo"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"),
                      ),
                    ],
                  ));
        }
      },
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
