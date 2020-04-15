import 'package:agendacabelo/modelos/login_modelo.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_tela.dart';

class LoginTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
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
                    onPressed: () {
                      model.googleSignIn();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomeTela()));
                    },
                    darkMode: true,
                    text: "Entre com o Google",
                  ),
                  FacebookSignInButton(
                    onPressed: () {
                      model.signOut();
                    },
                    text: "Entre com o Facebook",
                  ),
                ],
              ),
            ));
      },
    );
  }
}
