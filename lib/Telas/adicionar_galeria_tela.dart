import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cortai/Controle/galeria_controle.dart';
import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Util/share_redes_sociais.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import 'index_tela.dart';

class AdicionarGaleriaTela extends StatefulWidget {
  final Horario horario;

  AdicionarGaleriaTela(this.horario);

  @override
  _AdicionarGaleriaTelaState createState() => _AdicionarGaleriaTelaState();
}

class _AdicionarGaleriaTelaState extends State<AdicionarGaleriaTela> {
  File? _imagem;
  late String nomeSalao;
  final _formKey = GlobalKey<FormState>();
  var _descricaoController = TextEditingController();
  bool compartilhar = false;
  bool _botaoHabilitado = true;

  @override
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
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(deviceInfo.size.width * 5 / 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                            "${widget.horario.servicos!.first.descricao}",
                            style: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.w700)),
                      ),
                      ListTile(
                        leading: Text(
                          "Cabeleireiro: ",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        title: Text("${widget.horario.cabeleireiro!.nome}"),
                      ),
                      ListTile(
                        leading: Text("Cliente:",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        title: Text("${widget.horario.cliente!.nome}"),
                      ),
                      TextFormField(
                        controller: _descricaoController,
                        textCapitalization: TextCapitalization.words,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: 'Descrição',
                            hintStyle: TextStyle(fontSize: 12)),
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
                      _imagem == null
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Image.file(_imagem!),
                      Container(
                        width: deviceInfo.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Compartilhar em outras Redes sociais ?",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Switch(
                              value: compartilhar,
                              onChanged: (value) {
                                setState(() {
                                  compartilhar = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: ButtonCustom(
                          textoBotao: "Confirmar",
                          botaoHabilitado: _botaoHabilitado,
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _imagem != null) {
                              setState(() {
                                _botaoHabilitado = false;
                              });

                              Galeria galeria = Galeria();
                              galeria.cabeleireiro =
                                  widget.horario.cabeleireiro!;
                              var response = await http.get(
                                  SalaoControle.show(model.dados!.salaoId!),
                                  headers: Util.token(model.token));
                              galeria.salao = Salao.fromJsonApiDados(
                                  jsonDecode(response.body));
                              galeria.descricao = _descricaoController.text;
                              galeria.servico = widget.horario.servicos!.first;
                              galeria.cliente = widget.horario.cliente;
                              nomeSalao = galeria.salao.nome!;
                              GaleriaControle.store(
                                  dados: galeria,
                                  imagem: _imagem!,
                                  token: model.token,
                                  onSuccess: onSuccess,
                                  onFail: onFail);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  void onSuccess() async {
    if (compartilhar) {
      ShareRedesSociais().compartilharGeral(_imagem!,
          comentario:
              "Corte feito no Cortaí por ${widget.horario.cabeleireiro!.nome} no salão $nomeSalao");
    }
    await FlushbarHelper.createSuccess(
            message: "Adicionado a galeria com sucesso")
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(
      message: error,
      title: "Houve um erro ao adicionar a imagem",
      duration: Duration(seconds: 5),
    ).show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
