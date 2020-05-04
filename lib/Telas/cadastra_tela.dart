import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastraTela extends StatefulWidget {
  @override
  _CadastraTelaState createState() => _CadastraTelaState();
}

class _CadastraTelaState extends State<CadastraTela> {
  final _formKey = GlobalKey<FormState>(); // nao mexi mas sei que ce vai usar, ate mexi mas fiz bosta... 
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();
  final _telefoneControlador = TextEditingController();
  final _usuarioControlador = TextEditingController();
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _usuarioControlador,
                                    decoration: InputDecoration(
                                        hintText: 'Nome de Usuário',
                                        hintStyle: TextStyle(fontSize: 12)),
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _emailControlador,
                                    decoration:
                                        InputDecoration(hintText: 'Email',
                                        hintStyle: TextStyle(fontSize: 12)),
                                    // ignore: missing_return
                                    validator: (text) {
                                      if (text.isEmpty || !text.contains("@")) {
                                        return "Email inválido";
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _senhaControlador,
                                    decoration: InputDecoration(
                                        hintText: 'Senha',
                                        hintStyle: TextStyle(fontSize: 12)),
                                    // ignore: missing_return
                                    validator: (text) {
                                      if (text.isEmpty || text.length < 6) {
                                        return "Senha inválida";
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _telefoneControlador,
                                    decoration: InputDecoration(
                                        hintText: 'Telefone de contato',
                                        hintStyle: TextStyle(fontSize: 12)),
                                    // ignore: missing_return
                                    validator: (text) {
                                      if (text.isEmpty || text.length < 11) {
                                        return "Numero invalido";
                                      }
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
                                      onPressed: () {},
                                      child: Text(
                                        'Cadastrar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
              ));
      },
    );
  }
}
