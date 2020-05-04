import 'dart:async';
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
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
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
}
