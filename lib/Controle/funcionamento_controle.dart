import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FuncionamentoControle {
  static String _url = Util.url + 'funcionamento/';



  static String get(int salao) {
    return _url + "${salao.toString()}";
  }

  static void update(Funcionamento dados, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();

      var formData = FormData.fromMap(dados.toMap());
      var response = await dio.post(
        _url + "edit/${dados.id.toString()}",
        data: formData,
        options: Options(headers: Util.token(token)),
      );
      if (response.statusCode != 200) {
        onFail();
        return;
      }
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static void updateAll(List<Funcionamento> dados, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();
      dados.forEach((element) async {
        var formData = FormData.fromMap(element.toMap());
        var response = await dio.post(_url + "store",
            data: formData, options: Options(headers: Util.token(token)));
        if (response.statusCode != 200) {
          onFail();
          return;
        }
      });

      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static void delete(int id, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();
      var response = await dio.delete(_url + "delete/${id.toString()}",
          options: Options(headers: Util.token(token)));
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static void deleteAll(String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();
      print(_url + "deleteAll");
      var response = await dio.delete(_url + "deleteAll",
          options: Options(headers: Util.token(token)));
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
