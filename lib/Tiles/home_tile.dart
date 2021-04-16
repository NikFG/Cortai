import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Telas/servico_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/hero_custom.dart';
import 'package:cortai/Widgets/list_tile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomeTile extends StatefulWidget {
  final Salao dados;

  HomeTile(this.dados);

  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  late double _media = 0;

  late String _distancia;

  @override
  void initState() {
    super.initState();
    _distancia =
        '${widget.dados.distancia!.toStringAsFixed(1)}km'.replaceAll('.', ',');
    _media = widget.dados.mediaAvaliacao!;
  }

  @override
  Widget build(BuildContext context) {
    return ListTileCustom(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ServicoTela(salao: widget.dados, distancia: _distancia))),
      leading: GestureDetector(
          onTap: () {
            if (widget.dados.imagem != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HeroCustom(
                        imagemMemory: widget.dados.imagem,
                        descricao: widget.dados.nome,
                      )));
            }
          },
          // child: GFAvatar(
          //   shape: GFAvatarShape.circle,
          //   radius: 30,
          //   backgroundColor: Colors.transparent,
          //   backgroundImage: widget.dados.imagem != null
          //       ? MemoryImage(base64Decode(widget.dados.imagem))
          //       : AssetImage("assets/images/shop.png"),
          // ),
          child: Container(width: 0, height: 0)),
      onLongPress: () {
        _dialogDados(context);
      },
      title: Text(
        widget.dados.nome!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        softWrap: false,
        style: TextStyle(
          fontSize: 20.0,
            fontWeight: FontWeight.w100,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _media.toStringAsFixed(1),
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(width: 2.0),
              Icon(Icons.star, color: Colors.amber, size: 12.0),
              SizedBox(width: 5.0),
              Text(
                "(${widget.dados.quantidadeAvaliacao.toString()})",
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(width: 3.0),
              Text(
                _distancia,
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Entre R\$${widget.dados.menorValorServico!.toStringAsFixed(2)} ~ R\$${widget.dados.maiorValorServico!.toStringAsFixed(2)} ",
                style: TextStyle(fontSize: 15),
              )),
        ],
      ),
    );
  }

  _dialogDados(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mais informações"),
            content: TextButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(widget.dados.latitude!,
                    widget.dados.longitude!, widget.dados.nome);
              },
              child: Text("${widget.dados.endereco}"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Util.ligacaoTelefonica(widget.dados.telefone!);
                },
                child: Text("Ligar para salão"),
              ),
            ],
          );
        });
  }
}
