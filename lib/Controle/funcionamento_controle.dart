import 'package:cortai/Dados/funcionamento.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FuncionamentoControle {
  static String _url = Util.url + 'funcionamento/';

  static String get(int salao) {
    return _url + "${salao.toString()}";
  }

  static String getDiaSemana(String diaSemana, int salao) {
    return _url + "$diaSemana/${salao.toString()}";
  }

  static void update(Funcionamento dados, String token,
      {@required VoidCallback onSuccess,
      @required void onFail(String error)}) async {
    try {
      Api api = Api();
      await api.update(_url, dados.toJson(), token, dados.id);
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }

  static void updateAll(List<Funcionamento> dados, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Api api = Api();
      dados.forEach((element) async {
        await api.store(_url, element.toJson(), token);
      });
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  static Future<void> delete(int id, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Api api = Api();
      await api.delete(_url, token, id);
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
      onFail();
    }
  }
}
