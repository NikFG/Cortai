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
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("cabelereiros").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    Firestore.instance.collection('cabelereiros').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new HorarioTela(snapshot.data.documents[1])));
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Column(
                          children: createChildren(snapshot),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  createChildren(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Row(children: [
              Text(
                doc['apelido'],
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                doc['idade'].toString(),
              )
            ]))
        .toList();
  }
}
