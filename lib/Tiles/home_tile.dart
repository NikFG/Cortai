import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Telas/servico_tela.dart';
import 'package:cortai/Widgets/custom_list_tile.dart';
import 'package:cortai/Widgets/hero_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomeTile extends StatefulWidget {
  final Salao dados;
  final double distancia;

  HomeTile(this.dados, this.distancia);

  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  double _media = 0;

  String _distancia;

  @override
  void initState() {
    super.initState();
    _distancia =
        '${widget.distancia.toStringAsFixed(1)}km'.replaceAll('.', ',');
    _media = widget.dados.mediaAvaliacao;
    // if (widget.dados.quantidadeAvaliacao > 0)
    // _media = widget.dados.totalAvaliacao / widget.dados.quantidadeAvaliacao;
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ServicoTela(dados: widget.dados, distancia: _distancia))),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HeroCustom(
                    imagemUrl: widget.dados.imagem,
                    descricao: widget.dados.nome,
                  )));
        },
        child: GFAvatar(
          shape: GFAvatarShape.circle,
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: widget.dados.imagem != null
              ? NetworkImage(widget.dados.imagem)
              : AssetImage("assets/images/shop.png"),
        ),
      ),
      onLongPress: () {
        _dialogDados(context);
      },
      title: Text(
        widget.dados.nome,
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
                "Entre R\$${widget.dados.menorValorServico.toStringAsFixed(2)} ~ R\$${widget.dados.maiorValorServico.toStringAsFixed(2)} ",
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
            content: FlatButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(widget.dados.latitude,
                    widget.dados.longitude, widget.dados.nome);
              },
              child: Text("${widget.dados.endereco}"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Util.ligacaoTelefonica("tel:" + widget.dados.telefone);
                },
                child: Text("Ligar para salão"),
              ),
            ],
          );
        });
  }
}
