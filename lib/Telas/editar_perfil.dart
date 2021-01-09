import 'package:cortai/Dados/login.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Util/api.dart';

import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_form_field.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_tela.dart';

class EditarPerfilTela extends StatefulWidget {
  final Login login;

  EditarPerfilTela(this.login);

  @override
  _EditarPerfilTelaState createState() => _EditarPerfilTelaState();
}

class _EditarPerfilTelaState extends State<EditarPerfilTela> {
  var _formKey = GlobalKey<FormState>();
  final _nomeControlador = TextEditingController();
  final _telefoneControlador = MaskedTextController(mask: '(00) 00000-0000');
  bool _botaoHabilitado = true;

  @override
  void initState() {
    super.initState();
    _nomeControlador.text = widget.login.nome;
    _telefoneControlador.text = widget.login.telefone;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null)
          return Scaffold(
            appBar: AppBar(
              title: Text("Editar Perfil"),
              centerTitle: true,
              leading: Util.leadingScaffold(context),
            ),
            body: Form(
              key: _formKey,
              child: IgnorePointer(
                ignoring: !_botaoHabilitado,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nome completo",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              )),
                          SizedBox(height: 5),
                          CustomFormField(
                              hint: "Nome Completo",
                              icon: Icon(
                                FontAwesome.user,
                                color: Colors.grey,
                              ),
                              inputType: TextInputType.emailAddress,
                              controller: _nomeControlador,
                              validator: (text) {
                                return null;
                              }),
                          SizedBox(height: 5),
                          Text("Telefone",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              )),
                          SizedBox(height: 5),
                          CustomFormField(
                              hint: "(99) 99999-9999",
                              icon: Icon(
                                FontAwesome.phone,
                                color: Colors.grey,
                              ),
                              controller: _telefoneControlador,
                              inputType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty || text.length < 11) {
                                  return "Numero invalido";
                                }
                                return null;
                              }),
                          SizedBox(height: 5),
                          FlatButton(
                            onPressed: () async {
                              await model.recuperarSenha(model.dados.email);
                              await FlushbarHelper.createInformation(
                                      message:
                                          "Verifique seu email para mais sobre a alteração")
                                  .show(context);
                            },
                            child: Text("Mudar senha",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: RaisedButton(
                          color: Color(0xFFf45d27),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _botaoHabilitado = false;
                              });

                              await model.atualizaDados(
                                  telefone: _telefoneControlador.text,
                                  nome: _nomeControlador.text,
                                  token: model.token,
                                  onSucess: onSuccess,
                                  onFail: onFail);
                            }
                          },
                          child: _botaoHabilitado
                              ? Text(
                                  'Confirmar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        return Center();
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Informações de usuário atualizadas com sucesso")
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(
            message: error)
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
