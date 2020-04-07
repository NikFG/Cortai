import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HorarioTela extends StatelessWidget {
  final DocumentSnapshot _snapshot;

  const HorarioTela(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Horários"),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("cabelereiros")
              .document(_snapshot.documentID)
              .collection("disponibilidade")
              .getDocuments(),
          builder: (context, snapshot) {
            /*  if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {*/
            return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("cabelereiros")
                  .document(_snapshot.documentID)
                  .collection("disponibilidade")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
            // }
          },
        ));
  }

  createChildren(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      return Row(children: [
        Text(
          TimestampToString(doc['horario']),
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          doc['ocupado'].toString(),
          style: TextStyle(fontSize: 20),
        ),
        VerticalDivider(color: Colors.red,),
      ]);
    }).toList();
  }

  String TimestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }
}
