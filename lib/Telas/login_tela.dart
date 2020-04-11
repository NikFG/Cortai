import 'package:agendacabelo/login_service.dart';
import 'package:flutter/material.dart';

import 'home_tela.dart';

class LoginTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
