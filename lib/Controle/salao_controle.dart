import 'dart:io';

import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static Firestore _firestore = Firestore.instance;
  static final _url = Util.url + "saloes/";

  static String getNew() {
    return _url + "home";
  }

  static CollectionReference get() {
    return _firestore.collection("saloes");
  }

  static void store(Salao dados,
      {@required Login usuario,
        @required File imagem,
        @required String token,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail}) async {
    Dio dio = Dio();
    Map<String, dynamic> map = dados.toMap();
    map["imagem"] = await MultipartFile.fromFile(imagem.path,
        filename: imagem.path
            .split('/')
            .last);
    FormData formData = FormData.fromMap(map);

    try {
      var response = await dio.post(
          _url + "store", data: formData, options: Options(headers: {"Authorization": "Bearer $token"}),);
      print(response.data);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static void storeOld(Salao dados,
      {@required Login usuario,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail}) async {
    await _firestore.collection('saloes').add(dados.toMap()).then((value) {
      print(value);
      Firestore.instance
          .collection('usuarios')
          .document(usuario.id.toString())
          .updateData({'salao': value.documentID, 'cabeleireiro': true});
      usuario.isCabeleireiro = true;
      usuario.isDonoSalao = true;
      usuario.salao = value.documentID;
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(Salao dados,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
        .document(dados.id)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }
}
