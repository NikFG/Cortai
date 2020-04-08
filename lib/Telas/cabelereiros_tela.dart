import 'dart:async';
import 'package:agendacabelo/Telas/horario_tela.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabelereirosTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Agendar"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HorarioTela())),
          child: ListView(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Celminho ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "30",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              Card(
                elevation: 2,
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Celminho",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "30",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
