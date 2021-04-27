import 'dart:io';

import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class AdicionarGaleriaTela extends StatefulWidget {
  final Horario horario;
  final ValueChanged<int>? confirmadoChanged;

  AdicionarGaleriaTela(this.horario, {this.confirmadoChanged});

  @override
  _AdicionarGaleriaTelaState createState() => _AdicionarGaleriaTelaState();
}

class _AdicionarGaleriaTelaState extends State<AdicionarGaleriaTela> {
  @override
  File? _imagem;
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);

    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
              title: Text(
                "Adicionar a Galeria",
              ),
              centerTitle: true,
              leading: Util.leadingScaffold(context)),
          body: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(deviceInfo.size.width * 5 / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.horario.servicos!.first.descricao}",
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.w700)),
                    Text("Código do agendamento: ",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                        )),
                    ListTile(
                      leading: Text(
                          "Cabeleireiro: ${widget.horario.cabeleireiro!.nome}"),
                    ),
                    ListTile(
                      leading:
                          Text("Cliente: ${widget.horario.cliente!.nome} "),
                    ),
                    Center(
                      child: Container(
                          width: deviceInfo.size.width,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {
                                  getImagem(true);
                                },
                              ),
                              TextButton(
                                  onPressed: () {
                                    getImagem(false);
                                  },
                                  child: Text("Alterar ou Adicionar imagem")),
                            ],
                          )),
                    ),
                    Container(
                      width: 0,
                      height: 0,
                    ),
                    SizedBox(
                      height: deviceInfo.size.height * 3 / 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Null> getImagem(bool camera) async {
    var picker = ImagePicker();
    var imagem = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (imagem != null) {
        _imagem = File(imagem.path);
      }
    });
  }

  void onSuccess() async {}

  void onFail() async {}
}
