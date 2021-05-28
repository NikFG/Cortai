import 'dart:convert';

import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';

class FormaPagamentoControle {
  static String _url = Util.url + "formaPagamento/";

  static String getBySalao(int salaoId) {
    return _url + salaoId.toString();
  }

  static Uri get() {
    return Uri.parse(_url);
  }

  static Future<void> store(List<int> pagamentos, String token,
      {required Function onSuccess, required Function onFail}) async {
    try {
      Api api = Api();
      await api.store(_url, {"pagamentos": jsonEncode(pagamentos)}, token);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
