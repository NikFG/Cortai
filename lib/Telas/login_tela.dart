import 'package:agendacabelo/login_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'home_tela.dart';

class LoginTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          //Criar tela de email e senha
          padding: EdgeInsets.only(bottom: 50),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GoogleSignInButton(
                onPressed: () async {
                  await LoginService().googleSignIn();
                  
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeTela()));
                },
                darkMode: true,
                text: "Entre com o Google",
              ),
              FacebookSignInButton(
                onPressed: () {
                  LoginService().signOut();
                },
                text: "Entre com o Facebook",
              ),
            ],
          ),
        ));
    /* return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              LoginService().googleSignIn();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeTela()));
            },
            child: Text("Sign in"),
            color: Colors.green,
          ),
          MaterialButton(
            onPressed: () {
              LoginService().signOut();
            },
            child: Text("Sign out"),
            color: Colors.red,
          )
        ],
      ),
    );*/
  }
}
