import 'package:cortai/Util/util.dart';

class FormaPagamentoControle {
  static String _url = Util.url + "formaPagamento/";

  static String get(int salaoId) {
    return _url;
  }
}
