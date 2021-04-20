import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HorarioControle {
  static String _url = Util.url + "horarios/";

  static Uri getNew(String tipo, int pago) {
    return Uri.parse(_url + "$tipo/${pago.toString()}");
  }

  static Uri getCalendario() {
    return Uri.parse(_url + "cabeleireiro/false");
  }

  static Uri getData(String data, int cabeleireiroId) {
    data = data.replaceAll("/", "-");
    return Uri.parse(
        _url + "cabeleireiro/${cabeleireiroId.toString()}/data/$data");
  }

  static Uri getCabeleireiroAux() {
    return Uri.parse(_url + "cabeleireiro");
  }

  static Uri getQuantidade(int id) {
    return Uri.parse(_url + "count/${id.toString()}");
  }

  static Future<void> store(
      {required Horario horario,
      required String token,
      required void Function() onSuccess,
      required void onFail(String error)}) async {
    try {
      Api api = Api();
      await api.store(_url, horario.toJson(), token);
      onSuccess();
    } catch (e) {
      onFail(e.toString());
    }
  }

  static void update(Horario dados,
      {required VoidCallback onSuccess(context),
      required VoidCallback onFail(context),
      required context}) async {}

  static delete(String id,
      {required VoidCallback onSuccess, required VoidCallback onFail}) {}

  static confirmaAgendamento(int id, String token,
      {required VoidCallback onSuccess,
      required VoidCallback onFail,
      required BuildContext context}) async {
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
      {required VoidCallback onSuccess,
      required VoidCallback onFail,
      bool clienteCancelou = false}) async {
    try {
      Dio dio = Dio(); //TODO Falta tratar caso cliente cancele
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
      {required VoidCallback onSuccess, required VoidCallback onFail}) async {
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
