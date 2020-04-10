import 'package:agendacabelo/auth.dart';
import 'package:flutter/material.dart';

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
