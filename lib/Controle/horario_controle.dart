import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HorarioControle {
  static String _url = Util.url + "horarios/";

  static String getNew(String tipo, int pago) {
    return _url + "$tipo/${pago.toString()}";
  }

  static String getData(String data, int cabeleireiroId) {
    data = data.replaceAll("/", "-");
    return _url + "cabeleireiro/${cabeleireiroId.toString()}/data/$data";
  }

  static String getCabeleireiro(String tipo, int confirmado) {
    return _url + "$tipo/${confirmado.toString()}";
  }

  static String getCabeleireiroAux() {
    return _url + "cabeleireiro";
  }

  static String getQuantidade(int id) {
    return _url + "count/${id.toString()}";
  }

  static void store(
      {@required Horario horario,
      @required String token,
      @required VoidCallback onSuccess,
      @required Function onFail(String error)}) async {
    try {
      Api api = Api();
      api.store(_url, horario.toMap(), token);
      onSuccess();
    } catch (e) {
      String error = "";
      e.forEach((k, v) {
        error +=
            v.toString().replaceFirst('[', '').replaceFirst(']', '') + "\n";
      });
      onFail(error);
    }
  }

  static void update(Horario dados,
      {@required VoidCallback onSuccess(context),
      @required VoidCallback onFail(context),
      @required context}) async {}

  static delete(String id,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) {}

  static confirmaAgendamento(int id, String token,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required BuildContext context}) async {
    try {
      Dio dio = Dio();
      var response = await dio.put(_url + "confirma/${id.toString()}",
          options: Options(headers: Util.token(token)));
      if (response.statusCode == 200) {
        onSuccess();
      } else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static cancelaAgendamento(int id, String token,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      bool clienteCancelou = false}) async {
    try {
      Dio dio = Dio(); //Falta tratar caso cliente cancele
      var response = await dio.put(_url + "cancela/${id.toString()}",
          options: Options(headers: Util.token(token)));
      if (response.statusCode == 200) {
        onSuccess();
      } else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static confirmaPagamento(int id, String token,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();
      var response = await dio.put(_url + "paga/${id.toString()}",
          options: Options(headers: Util.token(token)));
      if (response.statusCode == 200) {
        onSuccess();
      } else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
