import 'dart:io';
import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Dados/cabeleireiro.dart';
import 'package:agendacabelo/Dados/servico.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:agendacabelo/Widgets/hero_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarServicoTela extends StatefulWidget {
  final Servico dados;
  final String titulo;

  CriarServicoTela({this.dados, @required this.titulo});

  @override
  _CriarServicoTelaState createState() => _CriarServicoTelaState();
}

class _CriarServicoTelaState extends State<CriarServicoTela> {
  final _formKey = GlobalKey<FormState>();
  var _nomeControlador = TextEditingController();
  var _cabeleireirosControlador = TextEditingController();
  var _observacaoControlador = TextEditingController();
  var _precoControlador = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  var ativo = true;
  File _imagem;
  List<Cabeleireiro> selecionados = [];
  bool _botaoHabilitado = true;

  @override
  void initState() {
    super.initState();
    if (widget.dados != null) {
      _verificaEditar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        centerTitle: true,
        leading: Util.leadingScaffold(context),
      ),
      body:
          ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
        return Form(
          key: _formKey,
          child: IgnorePointer(
            ignoring: !_botaoHabilitado,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Ativo"),
                    Switch(
                      value: ativo,
                      onChanged: (value) {
                        setState(() {
                          ativo = value;
                        });
                      },
                    ),
                  ],
                ),
                CustomFormField(
                  controller: _nomeControlador,
                  inputType: TextInputType.text,
                  isFrase: true,
                  hint: "Nome do serviço",
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome inválido";
                    }
                    return null;
                  },
                  icon: null,
                ),
                SizedBox(
                  height: 25,
                ),
                CustomFormField(
                  controller: _precoControlador,
                  inputType: TextInputType.number,
                  hint: "Preço do serviço",
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Preço inválido";
                    }
                    if (text == "R\$0,00") {
                      return "Preço não pode ser zero";
                    }
                    return null;
                  },
                  icon: null,
                  isPreco: true,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    var snapshots = await Firestore.instance
                        .collection('usuarios')
                        .orderBy('nome')
                        .where('salao', isEqualTo: model.dados.salao)
                        .getDocuments();
                    List<Cabeleireiro> dados = snapshots.documents
                        .map((e) => Cabeleireiro.fromDocument(e))
                        .toList();

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => _MyDialog(
                              dados: dados,
                              selecionados: selecionados,
                              onSelectedDadosChanged: (dados) {
                                selecionados = dados;
                                selecionados
                                    .sort((a, b) => a.nome.compareTo(b.nome));
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
                    child: CustomFormField(
                      icon: null,
                      validator: (value) {
                        return null;
                      },
                      inputType: TextInputType.multiline,
                      maxLines: null,
                      controller: _cabeleireirosControlador,
                      hint: "Cabeleireiros",
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  controller: _observacaoControlador,
                  inputType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 2,
                  hint: "Breve descrição sobre o serviço",
                  icon: null,
                  isFrase: true,
                  validator: (value) {
                    return null;
                  },
                ),
                SizedBox(height: 25),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HeroCustom(imagemFile: _imagem)));
                        },
                        child: Image.file(_imagem))
                    : widget.dados != null
                        ? widget.dados.imagemUrl == null
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HeroCustom(
                                              imagemUrl:
                                                  widget.dados.imagemUrl)));
                                },
                                child: Image.network(widget.dados.imagemUrl))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  //TODO: botão padrão
                  height: 44,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: _botaoHabilitado
                        ? Text(
                            "Confirmar",
                            style: TextStyle(fontSize: 18),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                          ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: _botaoHabilitado
                        ? () async {
                            try {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _botaoHabilitado = false;
                                });
                                Servico dados = Servico();
                                dados.descricao = _nomeControlador.text;
                                dados.setValor(_precoControlador.text);
                                dados.salao = model.dados.salao;
                                dados.observacao = _observacaoControlador.text;
                                dados.ativo = ativo;
                                dados.cabeleireiros =
                                    selecionados.map((e) => e.id).toList();
                                if (widget.dados != null) {
                                  if (_imagem != null) {
                                    if (widget.dados.imagemUrl != null)
                                      await Util.deletaImagem(
                                          widget.dados.imagemUrl);
                                    dados.imagemUrl = await Util.enviaImagem(
                                        model.dados.id, _imagem);
                                  } else {
                                    dados.imagemUrl = widget.dados.imagemUrl;
                                  }
                                  dados.id = widget.dados.id;
                                  ServicoControle.update(dados,
                                      onSuccess: onUpdateSuccess,
                                      onFail: onFail);
                                } else {
                                  if (_imagem != null)
                                    dados.imagemUrl = await Util.enviaImagem(
                                        model.dados.id, _imagem);
                                  ServicoControle.store(dados,
                                      onSuccess: onSuccess, onFail: onFail);
                                }
                              }
                            } catch (e) {
                              print(e);
                              onFail();
                            }
                          }
                        : null,
                  ),
                )
              ],
            ),
          ),
        );
      }),
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

  Future<Null> _verificaEditar() async {
    _nomeControlador.text = widget.dados.descricao;
    _precoControlador.text = widget.dados.valor.toStringAsFixed(2);
    _observacaoControlador.text = widget.dados.observacao;
    ativo = widget.dados.ativo;
    var documents = await Firestore.instance
        .collection('usuarios')
        .orderBy('nome')
        .where('uid', whereIn: widget.dados.cabeleireiros)
        .getDocuments();
    selecionados =
        documents.documents.map((e) => Cabeleireiro.fromDocument(e)).toList();
    _cabeleireirosControlador.text = "";
    for (int i = 0; i < selecionados.length; i++) {
      if (i != selecionados.length - 1)
        _cabeleireirosControlador.text += selecionados[i].nome + ", ";
      else
        _cabeleireirosControlador.text += selecionados[i].nome;
    }
  }

  onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Serviço criado com sucesso",
            duration: Duration(milliseconds: 1200))
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  onUpdateSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Serviço alterado com sucesso",
            duration: Duration(milliseconds: 1200))
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  onFail() async {
    await FlushbarHelper.createError(
            message: "Houve erro ao enviar os dados",
            duration: Duration(milliseconds: 1200))
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  Widget _verificaImagemNula() {
    String texto = '';

    if (widget.dados == null) {
      if (_imagem == null) {
        texto = "Selecione uma imagem";
      } else {
        texto = "Altere a imagem caso necessário";
      }
    } else {
      if (widget.dados.imagemUrl == null) {
        if (_imagem == null) {
          texto = "Selecione uma imagem";
        } else {
          texto = "Altere a imagem caso necessário";
        }
      } else {
        texto = "Altere a imagem caso necessário";
      }
    }
    return Text(texto);
  }
}

class _MyDialog extends StatefulWidget {
  final List<Cabeleireiro> dados;
  final List<Cabeleireiro> selecionados;
  final ValueChanged<List<Cabeleireiro>> onSelectedDadosChanged;

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
    List<Cabeleireiro> _tempSelecionados = widget.selecionados;

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
