import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/criar_servico_tela.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class GerenciaServicoTile extends StatelessWidget {
  final Servico dados;

  GerenciaServicoTile({required this.dados});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return ListTileCustom(
          color: dados.ativo! ? Theme.of(context).cardColor : Colors.grey[300]!,
          onTap: () {
            if (model.dados!.isDonoSalao ||
                dados.cabeleireiros!.contains(model.dados!.id))
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
                        content: Text(
                            "Peça permissão ao gerente para poder acessar este corte e editá-lo"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Ok"),
                          ),
                        ],
                      ));
            }
          },
          leading: dados.imagem != null
              ?
              // ? GFAvatar(
              //     shape: GFAvatarShape.circle,
              //     radius: 30,
              //     backgroundColor: Colors.transparent,
              //     backgroundImage: dados.imagem != null
              //         ? MemoryImage(base64Decode(dados.imagem))
              //         : AssetImage("assets/images/shop.png"),
              Center()
              : CircleAvatar(
                  radius: 30,
                ),
          title: Text(
            dados.descricao!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          subtitle: Text(
            dados.observacao!,
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
      },
    );
  }
}
