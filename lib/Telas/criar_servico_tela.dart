import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Controle/servico_controle.dart';
import 'package:cortai/Dados/cabeleireiro.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:cortai/Widgets/hero_custom.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarServicoTela extends StatefulWidget {
  final Servico? dados;
  final String titulo;

  CriarServicoTela({this.dados, required this.titulo});

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
  File? _imagem;
  List<Cabeleireiro> selecionados = [];
  bool _botaoHabilitado = true;
  final pasta = 'Imagens servicos';

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
                FormFieldCustom(
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
                ),
                SizedBox(
                  height: 25,
                ),
                FormFieldCustom(
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
                model.dados!.isDonoSalao
                    ? GestureDetector(
                        onTap: () async {
                          var response = await http.get(
                              SalaoControle.getCabeleireiros(),
                              headers: Util.token(model.token));
                          print(response.body);
                          print(json.decode(response.body));
                          List<Cabeleireiro> dados = json
                              .decode(response.body)
                              .map<Cabeleireiro>(
                                  (c) => Cabeleireiro.fromJson(c))
                              .toList();
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => _MyDialog(
                                    dados: dados,
                                    selecionados: selecionados,
                                    onSelectedDadosChanged: (dados) {
                                      selecionados = dados;
                                      selecionados.sort(
                                          (a, b) => a.nome.compareTo(b.nome));
                                      _cabeleireirosControlador.text = "";
                                      for (int i = 0;
                                          i < selecionados.length;
                                          i++) {
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
                          child: FormFieldCustom(
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
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
                SizedBox(
                  height: 10,
                ),
                FormFieldCustom(
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
                    TextButton(
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
                                      HeroCustom(imagemFile: _imagem!)));
                        },
                        child: Image.file(_imagem!))
                    : widget.dados != null
                        ? widget.dados!.imagem == null
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
                                              imagemMemory:
                                                  widget.dados!.imagem!)));
                                },
                                child: CachedNetworkImage(
                                    imageUrl: widget.dados!.imagem!))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                SizedBox(
                  height: 25,
                ),
                ButtonCustom(
                  textoBotao: "Confirmar",
                  botaoHabilitado: _botaoHabilitado,
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _botaoHabilitado = false;
                        });
                        Servico dados =
                            widget.dados != null ? widget.dados! : Servico();
                        dados.descricao = _nomeControlador.text;
                        dados.setValor(_precoControlador.text);
                        dados.salaoId = model.dados!.salaoId;
                        dados.observacao = _observacaoControlador.text;
                        dados.ativo = ativo;
                        if (!model.dados!.isDonoSalao) {
                          selecionados.add(
                              Cabeleireiro.fromJson(model.dados!.toJson()));
                        }
                        dados.cabeleireirosApi = selecionados;

                        if (widget.dados != null) {
                          dados.id = widget.dados!.id;
                          ServicoControle.update(
                              dados: dados,
                              token: model.token,
                              imagem: _imagem,
                              onSuccess: onUpdateSuccess,
                              onFail: onFail);
                        } else {
                          //Caso seja apenas um cabeleireiro irá adicionar o serviço apenas para si

                          ServicoControle.store(
                              dados: dados,
                              token: model.token,
                              imagem: _imagem,
                              onSuccess: onSuccess,
                              onFail: onFail);
                        }
                      }
                    } catch (e) {
                      print(e);
                      onFail();
                    }
                  },
                ),
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
    _nomeControlador.text = widget.dados!.descricao!;
    _precoControlador.text = widget.dados!.valor.toStringAsFixed(2);
    _observacaoControlador.text = widget.dados!.observacao!;
    ativo = widget.dados!.ativo!;

    selecionados = widget.dados!.cabeleireirosApi!;

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
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
  }

  onUpdateSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Serviço alterado com sucesso",
            duration: Duration(milliseconds: 1200))
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => IndexTela()));
  }

  onFail() async {
    await FlushbarHelper.createError(
            message: "Houve erro ao enviar os dados",
            duration: Duration(milliseconds: 1200))
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
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
      if (widget.dados!.imagem == null) {
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
      {required this.dados,
      required this.selecionados,
      required this.onSelectedDadosChanged});

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
                      if (value!) {
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
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
