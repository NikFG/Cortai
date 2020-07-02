import 'package:agendacabelo/Dados/login_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastroTela extends StatefulWidget {
  @override
  _CadastroTelaState createState() => _CadastroTelaState();
}

class _CadastroTelaState extends State<CadastroTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();
  final _senhaConfirmaControlador = TextEditingController();
  final _telefoneControlador = MaskedTextController(mask: '(00) 0 0000-0000');
  final _nomeControlador = TextEditingController();
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    Util.corPrimariaStatusBar(context);
    return Scaffold(
        body: Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(250, 100),
                          bottomRight: Radius.elliptical(250, 100))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xCCFFFFFF),
                            fontFamily: 'Poppins',
                            fontSize: 38,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: <Widget>[
                      CustomFormField(
                          hint: "Nome completo",
                          icon: Icon(
                            Icons.person_pin,
                            color: Colors.grey,
                          ),
                          controller: _nomeControlador,
                          isNome: true,
                          inputType: TextInputType.text,
                          validator: (text) {
                            if (text.isEmpty) {
                              return "O nome não pode estar vazio";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      CustomFormField(
                          hint: "Email",
                          inputType: TextInputType.emailAddress,
                          icon: Icon(Icons.email, color: Colors.grey),
                          controller: _emailControlador,
                          validator: (text) {
                            if (text.isEmpty ||
                                !EmailValidator.validate(text)) {
                              return "Email inválido";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      CustomFormField(
                          hint: "Telefone",
                          icon: Icon(
                            Icons.phone,
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
                      SizedBox(
                        height: 15,
                      ),
                      CustomFormField(
                          hint: "Senha",
                          icon: Icon(Icons.vpn_key, color: Colors.grey),
                          controller: _senhaControlador,
                          validator: (text) {
                            if (text.isEmpty || text.length < 6) {
                              return "Senha inválida";
                            }
                            return null;
                          },
                          inputType: TextInputType.visiblePassword,
                          isSenha: true),
                      SizedBox(
                        height: 15,
                      ),
                      CustomFormField(
                          hint: "Confirmar Senha",
                          icon: Icon(Icons.vpn_key, color: Colors.grey),
                          controller: _senhaConfirmaControlador,
                          validator: (text) {
                            if (text.isEmpty || text.length < 6) {
                              return "Senha inválida";
                            }
                            if (text != _senhaControlador.text) {
                              return "As senhas estão diferentes";
                            }
                            return null;
                          },
                          inputType: TextInputType.visiblePassword,
                          isSenha: true),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: FlatButton(
                            onPressed: _botaoHabilitado
                                ? () {
                                    if (_formKey.currentState.validate()) {
                                      LoginModelo login = LoginModelo();
                                      var loginDados = LoginDados(
                                          id: '',
                                          email: _emailControlador.text,
                                          nome: _nomeControlador.text,
                                          telefone: _telefoneControlador.text,
                                          isCabeleireiro: false,
                                          salao: null,
                                          imagemUrl: null,
                                          isDonoSalao: false);

                                      login.signUp(
                                          loginDados: loginDados,
                                          senha: _senhaControlador.text,
                                          onSuccess: onSuccess,
                                          onFail: onFail);
                                    }
                                  }
                                : null,
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
                      Container(
                        child: Center(
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginTela()));
                              },
                              child: Text(
                                'Já tem cadastro ? Faça Login',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: 'Roboto'),
                              )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Cadastro realizado com sucesso")
        .show(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Erro ao realizar o cadastro, teste novamente!")
        .show(context);
  }

  
}
