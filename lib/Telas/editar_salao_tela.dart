import 'dart:io';
import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/maps_tela.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class EditarSalaoTela extends StatefulWidget {
  final Salao salao;
  final String usuario;

  EditarSalaoTela(this.usuario, {this.salao});

  @override
  _EditarSalaoTelaState createState() => _EditarSalaoTelaState();
}

class _EditarSalaoTelaState extends State<EditarSalaoTela> {
  final _formKey = GlobalKey<FormState>();
  final pasta = 'Imagens saloes';
  var _nomeController = TextEditingController();
  var _enderecoController = TextEditingController();
  var _telefoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  var latlng = LatLng(0, 0);
  Salao dados;
  File _imagem;
  bool _botaoHabilitado = true;
  String _cidade;

  @override
  void initState() {
    super.initState();
    verificaSalao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.salao != null ? Text("Editar salão") : Text("Criar salão"),
        leading: Util.leadingScaffold(context),
      ),
      body: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          if (model != null) {
            return Form(
              key: _formKey,
              child: IgnorePointer(
                ignoring: !_botaoHabilitado,
                child: ListView(
                  padding: EdgeInsets.all(30),
                  children: <Widget>[
                    TextFormField(
                      controller: _nomeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          hintText: 'Nome', hintStyle: TextStyle(fontSize: 12)),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.salao != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapsTela(
                                    endereco: widget.salao.endereco,
                                    lat: widget.salao.latitude,
                                    lng: widget.salao.longitude,
                                    enderecoChanged: (value) {
                                      _enderecoController.text = value;
                                    },
                                    latLngChanged: (value) {
                                      latlng = value;
                                    },
                                    cidadeChanged: (value) {
                                      _cidade = value;
                                    },
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapsTela(
                                    enderecoChanged: (value) {
                                      _enderecoController.text = value;
                                    },
                                    latLngChanged: (value) {
                                      latlng = value;
                                    },
                                    cidadeChanged: (value) {
                                      _cidade = value;
                                      print(value);
                                      print(_cidade);
                                    },
                                  )));
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _enderecoController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Endereço completo',
                              hintStyle: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Telefone',
                          hintStyle: TextStyle(fontSize: 12)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 40,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: () {
                                getImagem(true);
                              },
                            ),
                            FlatButton(
                              onPressed: () {
                                getImagem(false);
                              },
                              child: _verificaImagemNula(),
                            ),
                          ],
                        )),
                    _imagem != null
                        ? Image.file(_imagem)
                        : widget.salao == null
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : widget.salao.imagem != null
                                ? Image.network(widget.salao.imagem)
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      width: 20,
                      child: RaisedButton(
                        padding: EdgeInsets.all(8),
                        onPressed: _botaoHabilitado
                            ? () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _botaoHabilitado = false;
                                  });

                                  dados.latitude = latlng.latitude;
                                  dados.longitude = latlng.longitude;
                                  dados.nome = _nomeController.text;
                                  dados.endereco = _enderecoController.text;
                                  dados.telefone = _telefoneController.text;
                                  dados.cidade = _cidade;
                                  if (widget.salao == null) {
                                    dados.menorValorServico = 0;
                                    dados.maiorValorServico = 0;
                                    dados.quantidadeAvaliacao = 0;
                                    dados.totalAvaliacao = 0;

                                    if (_imagem != null) {
                                      dados.imagem = await Util.enviaImagem(
                                          widget.usuario, _imagem, pasta);
                                    }
                                    SalaoControle.store(dados,
                                        usuario: model.dados,
                                        onSuccess: onSuccess,
                                        onFail: onFail);
                                  } else {
                                    if (_imagem != null) {
                                      if (dados.imagem != null)
                                        await Util.deletaImagem(dados.imagem);
                                      dados.imagem = await Util.enviaImagem(
                                          widget.usuario, _imagem, pasta);
                                    }
                                    SalaoControle.update(dados,
                                        onSuccess: onSuccessEditar,
                                        onFail: onFailEditar);
                                  }
                                }
                              }
                            : null,
                        child: _botaoHabilitado
                            ? Text(
                                "Confirmar",
                                style: TextStyle(fontSize: 18),
                              )
                            : CircularProgressIndicator(),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center();
          }
        },
      ),
    );
  }

  verificaSalao() {
    if (widget.salao != null) {
      this.dados = widget.salao;
      _nomeController.text = dados.nome;
      _enderecoController.text = dados.endereco;
      _telefoneController.text = dados.telefone;
      latlng = LatLng(this.dados.latitude, this.dados.longitude);
      _cidade = this.dados.cidade;
    } else {
      dados = Salao();
    }
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

  Widget _verificaImagemNula() {
    String texto = '';

    if (widget.salao == null) {
      if (_imagem == null) {
        texto = "Selecione uma imagem";
      } else {
        texto = "Altere a imagem caso necessário";
      }
    } else {
      if (widget.salao.imagem == null) {
        if (_imagem == null) {
          texto = "Selecione uma imagem";
        } else {
          texto = "Altere a imagem caso necessário";
        }
      } else {
        texto = "Altere a imagem caso necessário";
      }
    }
    return Text(
      texto,
      style: TextStyle(fontSize: 13),
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
      message: "Salão criado com sucesso",
    ).show(context);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail() async {
    FlushbarHelper.createError(
            message: 'Houve algum erro ao criar o salão\nTente novamente!!')
        .show(context);
  }

  void onSuccessEditar() async {
    await FlushbarHelper.createSuccess(
      message: "Salão modificado com sucesso",
    ).show(context);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFailEditar() async {
    FlushbarHelper.createError(
            message: 'Houve algum erro ao modificar o salão\nTente novamente!!')
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
