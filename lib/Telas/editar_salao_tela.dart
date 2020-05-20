import 'dart:io';

import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditarSalaoTela extends StatefulWidget {
  final SalaoDados salao;
  final String usuario;

  EditarSalaoTela(this.usuario, {this.salao});

  @override
  _EditarSalaoTelaState createState() => _EditarSalaoTelaState();
}

class _EditarSalaoTelaState extends State<EditarSalaoTela> {
  //TODO REFAZER VERIFICA SALÃO
  final _formKey = GlobalKey<FormState>();
  var _nomeController = TextEditingController();
  var _enderecoController = TextEditingController();
  var _telefoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  int cont = 0;
  SalaoDados dados;
  File _imagem;
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    verificaSalao();
    return Scaffold(
      appBar: AppBar(
        title: widget.salao.id != null
            ? Text("Editar salão")
            : Text("Criar salão"),
        leading: Util.leadingScaffold(context),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  hintText: 'Nome', hintStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              controller: _enderecoController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              decoration: InputDecoration(
                  hintText: 'Endereço completo',
                  hintStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              controller: _telefoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Telefone', hintStyle: TextStyle(fontSize: 12)),
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
                      child: _imagem == null && widget.salao == null
                          ? Text("Imagem de fundo para o salão")
                          : Text("Altere a imagem caso necessário"),
                    ),
                  ],
                )),
            _imagem != null
                ? Image.file(_imagem)
                : dados.imagem != null
                    ? Image.network(dados.imagem)
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
                          dados.nome = _nomeController.text;
                          dados.endereco = _enderecoController.text;
                          dados.telefone = _telefoneController.text;
                          LatLng latlng =
                              await getLatitudeLongitude(dados.endereco);
                          dados.latitude = latlng.latitude;
                          dados.longitude = latlng.longitude;

                          if (dados.id == null) {
                            dados.imagem =
                                await Util.enviaImagem(widget.usuario, _imagem);
                            await Firestore.instance
                                .collection('saloes')
                                .add(dados.toMap())
                                .then((doc) async {
                              await FlushbarHelper.createSuccess(
                                message: "Salão criado com sucesso",
                              ).show(context);
                              Firestore.instance
                                  .collection('usuarios')
                                  .document(widget.usuario)
                                  .updateData({'salao': widget.salao});
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeTela()));
                            }).catchError((e) {
                              FlushbarHelper.createError(
                                      message:
                                          'Houve algum erro ao criar o salão\nTente novamente!!')
                                  .show(context);
                            });
                          } else {
                            if (_imagem != null) {
                              await Util.deletaImagem(dados.imagem);
                              dados.imagem = await Util.enviaImagem(
                                  widget.usuario, _imagem);
                            }
                            await Firestore.instance
                                .collection('saloes')
                                .document(dados.id)
                                .updateData(dados.toMap())
                                .then((doc) async {
                              await FlushbarHelper.createSuccess(
                                message: "Salão modificado com sucesso",
                              ).show(context);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeTela()));
                            }).catchError((e) {
                              FlushbarHelper.createError(
                                      message:
                                          'Houve algum erro ao editar o salão\nTente novamente!!')
                                  .show(context);
                            });
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
  }

  Future<Null> verificaSalao() {
    if (widget.salao != null && cont == 0) {
      dados = widget.salao;
      _nomeController.text = dados.nome;
      _enderecoController.text = dados.endereco;
      _telefoneController.text = dados.telefone;
      cont++;
    } else {
      dados = SalaoDados();
    }
  }

  Future<Null> getImagem(bool camera) async {
    var imagem = await ImagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (imagem != null) {
        _imagem = imagem;
      }
    });
  }

  Future<LatLng> getLatitudeLongitude(String endereco) async {
    var geopoint = await Geocoder.local.findAddressesFromQuery(endereco);
    return LatLng(geopoint.first.coordinates.latitude,
        geopoint.first.coordinates.longitude);
  }
}
