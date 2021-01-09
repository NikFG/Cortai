import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('saloes');
  }

  static void store(Salao dados,
      {@required Login usuario,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    Map<String, dynamic> map = dados.toMap();
    if (imagem != null)
      map["imagem"] = await MultipartFile.fromFile(imagem.path,
          filename: imagem.path.split('/').last);
    FormData formData = FormData.fromMap(map);

    try {
      var response = await dio.post(
        _url + "store",
        data: formData,
        options: Options(headers: Util.token(token)),
      );
      usuario.salaoId = -1;
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
