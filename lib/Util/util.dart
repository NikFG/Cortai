import 'dart:io';

import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  static DateFormat timeFormat = DateFormat("HH:mm");

  static const url = "http://192.168.0.108:8000/api/"; //Local
  // static const url = "http://18.230.188.111/api/"; //AWS

  static Map<String, String> token(String token) {
    return {"Authorization": "Bearer $token}"};
  }

  static ligacaoTelefonica(String telefone) async {
    telefone = "tel:" + telefone;
    if (await canLaunch(telefone)) {
      await launch(telefone);
    } else {
      throw 'Could not launch $telefone';
    }
  }

  static String weekdayToString(DateTime data) {
    switch (data.weekday) {
      case 1:
        return 'SEG';

      case 2:
        return 'TER';

      case 3:
        return 'QUA';

      case 4:
        return 'QUI';

      case 5:
        return 'SEX';

      case 6:
        return 'SAB';

      case 7:
        return 'DOM';

      default:
        return '';
    }
  }

  static int? ordenarDiasSemana(String dia) {
    switch (dia) {
      case 'DOM':
        return 0;
      case 'SEG':
        return 1;
      case 'TER':
        return 2;
      case 'QUA':
        return 3;
      case 'QUI':
        return 4;
      case 'SEX':
        return 5;
      case 'SAB':
        return 6;
      default:
        return null;
    }
  }

  static Widget leadingScaffold(BuildContext context,
      {Color color = Colors.white}) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Platform.isAndroid
          ? Icon(Icons.arrow_back)
          : Icon(Icons.arrow_back_ios),
      color: color,
    );
  }

  static corPrimariaStatusBar(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor));
  }

  static setLocalizacao() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    String cidade = await placemarkFromCoordinates(
            position.latitude, position.longitude)
        .then((List<Placemark> value) => value.first.subAdministrativeArea!);

    String endereco = await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(position.latitude, position.longitude))
        .then((List<Address> value) => value.first.addressLine!);
    await SharedPreferencesControle.setCidade(cidade);
    await SharedPreferencesControle.setPosition(position);
    await SharedPreferencesControle.setEndereco(endereco);
  }
}
