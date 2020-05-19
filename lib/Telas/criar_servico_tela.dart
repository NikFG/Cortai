import 'dart:io';
import 'package:agendacabelo/Dados/cabeleireiro_dados.dart';
import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarServicoTela extends StatefulWidget {
  final PrecoDados precoDados;

  CriarServicoTela({this.precoDados});

  @override
  _CriarServicoTelaState createState() => _CriarServicoTelaState();
}

class _CriarServicoTelaState extends State<CriarServicoTela> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoControlador = TextEditingController();
  final _cabeleireirosControlador = TextEditingController();
  final _precoControlador = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  File _imagem;
  List<CabeleireiroDados> selecionados = [];
  int cont = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child:
          ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
        if (widget.precoDados != null && cont == 0) {
          _verificaEditar();
          cont++;
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _descricaoControlador,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: "Nome do serviço"),
                validator: (text) {
                  if (text.isEmpty) {
                    return "Nome inválido";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _precoControlador,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Preço do serviço"),
                validator: (text) {
                  if (text.isEmpty) {
                    return "Preço inválido";
                  }
                  if (text == "R\$0,00") {
                    return "Preço não pode ser zero";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var snapshots = await Firestore.instance
                      .collection('usuarios')
                      .where('salao', isEqualTo: model.getSalao())
                      .getDocuments();
                  List<CabeleireiroDados> dados = snapshots.documents
                      .map((e) => CabeleireiroDados.fromDocument(e))
                      .toList();

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => _MyDialog(
                            dados: dados,
                            selecionados: selecionados,
                            onSelectedDadosChanged: (dados) {
                              selecionados = dados;
                              _cabeleireirosControlador.text = "";
                              for (int i = 0; i < selecionados.length; i++) {
                                i != selecionados.length - 1
                                    ? _cabeleireirosControlador.text +=
                                        selecionados[i].nome + ", "
                                    : _cabeleireirosControlador.text +=
                                        selecionados[i].nome;
                              }
                            },
                          ));
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _cabeleireirosControlador,
                    decoration: InputDecoration(hintText: "Cabeleireiros"),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                  alignment: Alignment.centerLeft,
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
                        child: _imagem == null && widget.precoDados == null
                            ? Text("Selecione uma imagem para o serviço")
                            : Text("Altere a imagem caso necessário"),
                      ),
                    ],
                  )),
              _imagem != null
                  ? Image.file(_imagem)
                  : widget.precoDados != null
                      ? Image.network(widget.precoDados.imagemUrl)
                      : Container(
                          width: 0,
                          height: 0,
                        ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(fontSize: 18),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      PrecoDados dados = PrecoDados();
                      dados.descricao = _descricaoControlador.text;
                      dados.setValor(_precoControlador.text);
                      dados.salao = model.getSalao();
                      dados.cabeleireiros =
                          selecionados.map((e) => e.id).toList();
                      if (widget.precoDados != null) {
                        if (_imagem != null) {
                          await Util.deletaImagem(widget.precoDados.imagemUrl);
                          dados.imagemUrl = await Util.enviaImagem(
                              model.dados['uid'], _imagem);
                        } else {
                          dados.imagemUrl = widget.precoDados.imagemUrl;
                        }
                      }
                      if (widget.precoDados == null) {
                        dados.imagemUrl =
                            await Util.enviaImagem(model.dados['uid'], _imagem);
                        await Firestore.instance
                            .collection("servicos")
                            .add(dados.toMap())
                            .then((value) async {
                          await FlushbarHelper.createSuccess(
                                  message: "Serviço criado com sucesso",
                                  duration: Duration(milliseconds: 1200))
                              .show(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => HomeTela()));
                        });
                      } else {
                        dados.id = widget.precoDados.id;
                        await Firestore.instance
                            .collection("servicos")
                            .document(dados.id)
                            .updateData(dados.toMap())
                            .then((value) async {
                          await FlushbarHelper.createSuccess(
                                  message: "Serviço alterado com sucesso",
                                  duration: Duration(milliseconds: 1200))
                              .show(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => HomeTela()));
                        });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
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

  Future<Null> _verificaEditar() async {
    _descricaoControlador.text = widget.precoDados.descricao;
    _precoControlador.text = widget.precoDados.valor.toStringAsFixed(2);

    var documents = await Firestore.instance
        .collection('usuarios')
        .where('uid', whereIn: widget.precoDados.cabeleireiros)
        .getDocuments();
    selecionados = documents.documents
        .map((e) => CabeleireiroDados.fromDocument(e))
        .toList();
    _cabeleireirosControlador.text = "";
    for (int i = 0; i < selecionados.length; i++) {
      if (i != selecionados.length - 1)
        _cabeleireirosControlador.text += selecionados[i].nome + ", ";
      else
        _cabeleireirosControlador.text += selecionados[i].nome;
    }
  }
}

class _MyDialog extends StatefulWidget {
  final List<CabeleireiroDados> dados;
  final List<CabeleireiroDados> selecionados;
  final ValueChanged<List<CabeleireiroDados>> onSelectedDadosChanged;

  const _MyDialog(
      {@required this.dados,
      @required this.selecionados,
      @required this.onSelectedDadosChanged});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  @override
  Widget build(BuildContext context) {
    List<CabeleireiroDados> _tempSelecionados = widget.selecionados;
    return Dialog(
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Cabeleireiros para o serviço',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )),
          Divider(
            color: Colors.black87,
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.dados.length,
              itemBuilder: (context, index) {
                final nome = widget.dados[index].nome;
                final id = widget.dados[index].id;
                return Container(
                  child: CheckboxListTile(
                    title: Text(nome),
                    value: _tempSelecionados.contains(widget.dados[index]),
                    onChanged: (value) {
                      if (value) {
                        if (!_tempSelecionados.contains(widget.dados[index])) {
                          setState(() {
                            _tempSelecionados.add(widget.dados[index]);
                          });
                        }
                      } else {
                        if (_tempSelecionados.contains(widget.dados[index])) {
                          setState(() {
                            _tempSelecionados
                                .removeWhere((element) => element.id == id);
                          });
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.black87,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
              ),
              FlatButton(
                onPressed: () {
                  widget.onSelectedDadosChanged(_tempSelecionados);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Confirmar",
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
