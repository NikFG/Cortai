import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesControle {
  static SharedPreferences _prefs;

  SharedPreferencesControle() {
    try {
      _getInstace();
    }
    catch (e) {
      print(e);
    }
  }

  _getInstace() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setEndereco(String endereco) async {
    return await _prefs.setString('endereco', endereco);
  }

  static String getEndereco() {
    print(_prefs);
    String endereco;
    try {
      endereco = _prefs.getString('endereco');
      return endereco;
    } catch (e) {
      print(e);
      return '';
    }
  }
}
