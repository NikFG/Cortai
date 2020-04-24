import 'package:agendacabelo/Modelos/login_modelo.dart';

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
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [Color(0xFFf45d27), Color(0xFFf5851f)]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(110, 45),
                          bottomRight: Radius.elliptical(110, 45))),
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
                            print("Teste");
                            model.googleSignIn();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeTela()));
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
                        child: Text(
                          'Não tem cadastro ? Cadastre-se',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ),
                    )),
                Positioned(
                  top: MediaQuery.of(context).size.height / 8,
                  left: MediaQuery.of(context).size.width / 2.9,
                  child: Text(
                    'Agenda Hair',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],

              //  padding: EdgeInsets.only(bottom: 50),
              //  alignment: Alignment.center,
              //  child: Column(
              //    mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //    GoogleSignInButton(

              // FacebookSignInButton(
              // onPressed: () {
              // model.FacebookSignIn();
              // },
              //   text: "Entre com o Facebook",
              //   ),
              //   ],
              //   ),
            ));
      },
    );
  }
}
