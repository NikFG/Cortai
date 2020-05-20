import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(250, 100),
                      bottomRight: Radius.elliptical(250, 100))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.only(top: 32),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 250,
                            child: TextFormField(
                              controller: _nomeControlador,
                              decoration: InputDecoration(
                                  hintText: 'Nome completo',
                                  hintStyle: TextStyle(fontSize: 12)),
                            ),
                          ),
                          Container(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailControlador,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(fontSize: 12)),
                              validator: (text) {
                                if (text.isEmpty ||
                                    !EmailValidator.validate(text)) {
                                  return "Email inválido";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _telefoneControlador,
                              decoration: InputDecoration(
                                  hintText: 'Telefone de contato',
                                  hintStyle: TextStyle(fontSize: 12)),
                              validator: (text) {
                                if (text.isEmpty || text.length < 11) {
                                  return "Numero invalido";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _senhaControlador,
                              obscureText: true,
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
                          Container(
                            width: 250,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _senhaConfirmaControlador,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Confirmar senha',
                                  hintStyle: TextStyle(fontSize: 12)),
                              validator: (text) {
                                if (text.isEmpty || text.length < 6) {
                                  return "Senha inválida";
                                }
                                if (text != _senhaControlador.text) {
                                  return "As senhas estão diferentes";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
                                onPressed: _botaoHabilitado
                                    ? () {
                                        if (_formKey.currentState.validate()) {
                                          LoginModelo login = LoginModelo();
                                          login.dados = {
                                            'uid': '',
                                            'email': _emailControlador.text,
                                            'nome': _nomeControlador.text,
                                            'telefone':
                                                _telefoneControlador.text,
                                            'cabeleireiro': false,
                                          };
                                          login.signUp(
                                              usuarioData: login.dados,
                                              senha: _senhaControlador.text);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginTela()));
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
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 8,
                    left: MediaQuery.of(context).size.width / 2.9,
                    child: Text(
                      'Cadastre-se',
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
        ),
      ),
    );
  }
}
