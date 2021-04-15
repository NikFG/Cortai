import 'dart:convert';
import 'dart:io';

import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cadastro_funcionamento_tela.dart';
import 'maps_tela.dart';

class EditarSalaoTela extends StatefulWidget {
  final Salao? salao;

  EditarSalaoTela({this.salao});

  @override
  _EditarSalaoTelaState createState() => _EditarSalaoTelaState();
}

class _EditarSalaoTelaState extends State<EditarSalaoTela> {
  final _formKey = GlobalKey<FormState>();
  final pasta = 'Imagens saloes';
  var _nomeController = TextEditingController();
  var _enderecoController = TextEditingController();
  var _telefoneController = MaskedTextController(mask: '(00) 00000-0000');
  var latlng = LatLng(0, 0);
  late Salao dados;
  File? _imagem;
  bool _botaoHabilitado = true;
  late String _cidade;
  String botao = 'Confirmar';

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
                  padding: EdgeInsets.all(3.0.h),
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
                                    endereco: widget.salao!.endereco!,
                                    lat: widget.salao!.latitude!,
                                    lng: widget.salao!.longitude!,
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
                            TextButton(
                              onPressed: () {
                                getImagem(false);
                              },
                              child: _verificaImagemNula(),
                            ),
                          ],
                        )),
                    _imagem != null
                        ? Image.file(_imagem!)
                        : widget.salao == null
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : widget.salao!.imagem != null
                                ? Image.memory(
                                    base64Decode(widget.salao!.imagem!))
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                    SizedBox(
                      height: 30.0.h,
                    ),
                    ButtonCustom(
                      textoBotao: "Confirmar",
                      botaoHabilitado: _botaoHabilitado,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
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
                            SalaoControle.store(dados,
                                usuario: model.dados!,
                                imagem: _imagem,
                                token: model.token,
                                onSuccess: onSuccess,
                                onFail: onFail);
                          } else {
                            SalaoControle.update(dados,
                                token: model.token,
                                imagem: _imagem!,
                                usuario: model.dados!,
                                onSuccess: onSuccessEditar,
                                onFail: onFailEditar);
                          }
                        }
                      },
                    ),
                    /*
                    SizedBox(
                      height: 10.0.h,
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
                                    SalaoControle.store(dados,
                                        usuario: model.dados,
                                        imagem: _imagem,
                                        token: model.token,
                                        onSuccess: onSuccess,
                                        onFail: onFail);
                                  } else {
                                    SalaoControle.update(dados,
                                        token: model.token,
                                        imagem: _imagem,
                                        usuario: model.dados,
                                        onSuccess: onSuccessEditar,
                                        onFail: onFailEditar);
                                  }
                                }
                              }
                            : null,
                        child: _botaoHabilitado
                            ? Center(
                                child: Text(
                                  "Confirmar",
                                  style: TextStyle(fontSize: 16.0.sp),
                                ),
                              )
                            : CircularProgressIndicator(),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ),*/
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
      this.dados = widget.salao!;
      _nomeController.text = dados.nome!;
      _enderecoController.text = dados.endereco!;
      _telefoneController.text = dados.telefone == null ? "" : dados.telefone!;
      latlng = LatLng(this.dados.latitude!, this.dados.longitude!);
      _cidade = this.dados.cidade!;
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
      if (widget.salao!.imagem == null) {
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

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CadastroFuncionamentoTela()));
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(
            title: 'Houve algum erro ao criar o salão\nTente novamente!!',
            message: error)
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }

  void onSuccessEditar() async {
    await FlushbarHelper.createSuccess(
      message: "Salão modificado com sucesso",
    ).show(context);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
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
