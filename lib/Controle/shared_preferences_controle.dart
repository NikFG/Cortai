import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesControle {
  static SharedPreferences _prefs;

  SharedPreferencesControle() {
    try {
      _getInstace();
    } catch (e) {
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
    String endereco;
    try {
      endereco = _prefs.getString('endereco');
      return endereco;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static Future<bool> setCidade(String cidade) async {
    return await _prefs.setString('cidade', cidade);
  }

  static String getCidade() {
    print(_prefs.getKeys());
    print(_prefs.getString('cidade'));
    String cidade;
    try {
      cidade = _prefs.getString('cidade');
      if (cidade == null)
        return '';
      return cidade;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static Future<bool> setPosition(Position position) async {
    return (await _prefs.setDouble('latitude', position.latitude) &&
        await _prefs.setDouble('longitude', position.longitude));
  }

  static LatLng getPosition() {
    LatLng latLng;
    try {
      latLng = LatLng(_prefs.get('latitude'), _prefs.get('longitude'));
      return latLng;
    } catch (e) {
      print(e);
      return LatLng(0, 0);
    }
  }

  static setPermissionStatus(int status) async {
    return await _prefs.setInt('status', status);
  }

  static getPermissionStatus() {
    PermissionStatus status;
    try {
      status = PermissionStatus.values[_prefs.getInt('status')];
      return status;
    } catch (e) {
      return -1;
    }
  }
}
