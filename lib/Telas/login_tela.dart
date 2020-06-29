import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
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
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    Util.corPrimariaStatusBar(context);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.isCarregando) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white70,
            ),
          );
        } else {
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
                                Icons.assignment,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Cortaí',
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
                        padding: EdgeInsets.only(top: 62),
                        child: Column(
                          children: <Widget>[
                            CustomFormField(
                                hint: "Email",
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                inputType: TextInputType.emailAddress,
                                controller: _emailControlador,
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "O email não pode estar em branco";
                                  }
                                  if (!EmailValidator.validate(text)) {
                                    return "O email digitado está incorreto";
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            CustomFormField(
                              controller: _senhaControlador,
                              inputType: TextInputType.visiblePassword,
                              icon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey,
                              ),
                              hint: "Senha",
                              isSenha: true,
                              validator: (text) {
                                if (text.isEmpty || text.length < 6) {
                                  return "Senha inválida";
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, right: 32),
                                child: ButtonTheme(
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minWidth: 0,
                                  height: 0,
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (_emailControlador.text.isNotEmpty) {
                                        bool result =
                                            await model.recuperarSenha(
                                                _emailControlador.text);
                                        if (result) {
                                          await FlushbarHelper.createInformation(
                                                  message:
                                                      "Verifique seu email para recuperar a senha!")
                                              .show(context);
                                        } else {
                                          await FlushbarHelper.createError(
                                                  message:
                                                      "Houve algum erro ao recuperar sua senha, digite seu email novamente!")
                                              .show(context);
                                        }
                                      }
                                    },
                                    child: Text('Esqueceu a senha ?',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFf45d27),
                                      Color(0xFFf5851f)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: FlatButton(
                                  onPressed: _botaoHabilitado
                                      ? () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              _botaoHabilitado = false;
                                            });
                                            model.emailSignIn(
                                                email: _emailControlador.text,
                                                senha: _senhaControlador.text,
                                                onSuccess: onSuccess,
                                                onFail: onFail);
                                          }
                                        }
                                      : null,
                                  child: _botaoHabilitado
                                      ? Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
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
                              height: 5,
                            ),
                            GoogleSignInButton(
                              darkMode: false,
                              text: "Entre com o Google",
                              onPressed: _botaoHabilitado
                                  ? () {
                                      setState(() {
                                        _botaoHabilitado = false;
                                      });
                                      model
                                          .googleSignIn()
                                          .then((value) => onSuccess())
                                          .catchError((e) {
                                        print(e);
                                        onFail();
                                      });
                                    }
                                  : null,
                              borderRadius: 50,
                            ),
                            Container(
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
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(message: "Login realizado com sucesso")
        .show(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Erro ao realizar o login, teste novamente!")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
