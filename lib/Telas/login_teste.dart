import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: LoginPage(),
    //material app
  )
);

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900],
              Colors.orange[800],
              Colors.orange[400],
            ]
          )
        ),
      )
      )
  }
}

   child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    SizedBox(height:80,),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight: Radius.circular(60))),
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Text("Login",style: TextStyle(color: Colors.white,fontSize: 40),),
                          SizedBox(height: 30,),
                          Text("Bem Vindo!",style: TextStyle(color: Colors.white, fontSize: 20),),
                        ]

                      )
                    )),
                ],
                ),