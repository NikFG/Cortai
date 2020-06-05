import 'dart:async';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {
  PushNotification();

  static Future<Null> servico(String usuarioId, BuildContext context) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();
    _fcm.autoInitEnabled();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("${message['notification']['title']}"),
                  content: Text("${message['notification']['body']}"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ));
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        _rotaTelaInicial(message['data']['screen'], context);
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        _rotaTelaInicial(message['data']['screen'], context);
        print("onResume: $message");
      },
    );

    await _fcm.getToken().then((String token) {
      Firestore.instance
          .collection('usuarios')
          .document(usuarioId)
          .updateData({'token': token});
    });
  }

  static _rotaTelaInicial(String nome, BuildContext context) {
    int paginaInicial = 0;
    switch (nome) {
      case "marcado_tela":
        paginaInicial = 1;
        break;
      case "confirmar_tela":
        paginaInicial = 2;
        break;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeTela(
              paginaInicial: paginaInicial,
            )));
  }
}
