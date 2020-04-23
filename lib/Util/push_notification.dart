import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  PushNotification();

  bool iniciado = false;

  Future<String> servico(String usuario_id) async {
    _fcm.autoInitEnabled();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
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
          .document(usuario_id)
          .updateData({'token': token});
      iniciado = true;
    });
  }
}
