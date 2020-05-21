import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_tela.dart';
import 'cadastro_tela.dart';

class LoginTela extends StatefulWidget {
  @override
  _LoginTelaState createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.isCarregando) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white70,
            ),
          );
        } else
          return Scaffold(
              key: _scaffoldKey,
              body: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).accentColor
                            ]),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(250, 100),
                            bottomRight: Radius.elliptical(250, 100))),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: MediaQuery.of(context).size.height / 5,
                          left: MediaQuery.of(context).size.width / 9,
                          child: Container(
                            width: 300,
                            height: 351,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 20)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.only(top: 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 250,
                                    child: TextFormField(
                                      controller: _emailControlador,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(fontSize: 12)),
                                      validator: (text) {
                                        if (text.isEmpty ||
                                            !text.contains("@")) {
                                          return "Email inválido";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      controller: _senhaControlador,
                                      decoration: InputDecoration(
                                          hintText: 'Senha',
                                          hintStyle: TextStyle(fontSize: 12)),
                                      validator: (text) {
                                        if (text.isEmpty || text.length < 6) {
                                          return "Senha inválida";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FlatButton(
                                      onPressed: () async {
                                        if (_emailControlador.text.isEmpty ||
                                            !EmailValidator.validate(
                                                _emailControlador.text)) {
                                          FlushbarHelper.createError(
                                                  message:
                                                      "Insira um email válido",
                                                  duration: Duration(
                                                      milliseconds: 2500))
                                              .show(context);
                                        } else {
                                          model.recuperarSenha(
                                              _emailControlador.text);
                                          FlushbarHelper.createInformation(
                                                  title: "Confira seu email!",
                                                  message:
                                                      "Caso exista uma conta ativa, foi enviado um email para recuperação de senha!",
                                                  duration:
                                                      Duration(seconds: 3))
                                              .show(context);
                                        }
                                      },
                                      child: Text(
                                        "Esqueci minha senha",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                      padding: EdgeInsets.only(right: 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: 200,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.orange[900]),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: FlatButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            model.emailSignIn(
                                                email: _emailControlador.text,
                                                senha: _senhaControlador.text,
                                                onSuccess: onSuccess,
                                                onFail: onFail);
                                          }
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey),
                                    child: Center(
                                      child: Text(
                                        'OU',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GoogleSignInButton(
                                    darkMode: false,
                                    text: "Entre com o Google",
                                    onPressed: () {
                                      model.googleSignIn();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeTela()));
                                    },
                                    borderRadius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 1.25,
                            left: MediaQuery.of(context).size.width / 9,
                            child: Container(
                              child: Center(
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CadastroTela()));
                                    },
                                    child: Text(
                                      'Não tem cadastro ? Cadastre-se',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontFamily: 'Roboto'),
                                    )),
                              ),
                            )),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 8,
                          left: MediaQuery.of(context).size.width / 3.2,
                          child: Text(
                            'AGENDA HAIR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(message: "Login realizado com sucesso")
        .show(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(message: "Erro ao realizar o login, teste novamente!").show(context);
  }
}
