import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_tela.dart';

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
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Login"),
            centerTitle: true,
            leading: model.isLogado()
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : Container(),
          ),
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor
                        ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                        bottomRight: Radius.circular(90))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
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
                        child: TextField(
                          decoration: InputDecoration(
                              /*  icon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),*/
                              hintText: 'Email'),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: TextField(
                          decoration: InputDecoration(
                              /* icon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),*/
                              hintText: 'Senha'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900]),
                        child: Center(
                          child: FlatButton(
                            onPressed: () {
                              print("Teste");
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
                        height: 20,
                      ),
                      Container(
                        width: 40,
                        height: 40,
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
                        //textStyle: TextStyle(color: Colors.blueAccent),
                        onPressed: () {
                          model.googleSignIn();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => HomeTela()));
                        },
                        borderRadius: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height / 1.25,
                  left: MediaQuery.of(context).size.width / 15,
                  child: Container(
                    width: 200,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, "testee");
                        },
                        child: Text(
                          "Não tem cadastro ? cadastre-se",
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                 top: MediaQuery.of(context).size.height / 1.25,
                  left: MediaQuery.of(context).size.width / 1.70,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, "teste");
                  },
                  child: Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 8,
                left: MediaQuery.of(context).size.width / 2.9,
                child: Text(
                  'Agenda Hair',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSuccess() async {
    await _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário logado com sucesso"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 1)).then((_) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao logar"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 5),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomeTela()));
    });
  }
}
