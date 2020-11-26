import 'package:cortai/Dados/horario.dart';
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

  static void store(
      {@required Horario horario,
      @required String token,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    Dio dio = Dio();
    try {
      FormData formData = FormData.fromMap(horario.toMap());
      var response = await dio.post(
        _url + "store",
        data: formData,
        options: Options(headers: Util.token(token)),
      );
      print(response.data);
      if (response.statusCode == 500) {
        onFail();
      }
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  static void update(Horario dados,
      {@required VoidCallback onSuccess(context),
      @required VoidCallback onFail(context),
      @required context}) async {}

  static delete(String id,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) {}

  static confirmaAgendamento(String id,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required BuildContext context}) async {}

  /*
  * Recria o horário na coleção de horários excluídos para depois deletar.
  * Feito para armazenar os dados e ter controle futuro após o cancelamento
  * */

  static cancelaAgendamento(Horario dados,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail,
      clienteCancelou = false}) async {}

  static confirmaPagamento(String id,
      {@required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {}
}
