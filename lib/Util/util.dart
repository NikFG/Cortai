import 'dart:io';
import 'package:agendacabelo/Controle/shared_preferences_controle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  static DateFormat timeFormat = DateFormat("HH:mm");

  static String timestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }

  static Timestamp stringToTimestamp(String horario) {
    horario = horario.substring(5);
    horario = horario.replaceAll("/", "-");
    horario = horario.replaceAll(",", "");
    DateFormat format = new DateFormat('dd-MM-yyyy H:m');
    return Timestamp.fromDate(format.parse(horario));
  }

  static dateTimeofDayToDateTime(DateTime dt, TimeOfDay time) {
    return new DateTime(dt.year, dt.month, dt.day, time.hour, time.minute);
  }

  static ligacaoTelefonica(String telefone) async {
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
        break;
      case 2:
        return 'TER';
        break;
      case 3:
        return 'QUA';
        break;
      case 4:
        return 'QUI';
        break;
      case 5:
        return 'SEX';
        break;
      case 6:
        return 'SAB';
        break;
      case 7:
        return 'DOM';
        break;
      default:
        return '';
    }
  }

  static int ordenarDiasSemana(String dia) {
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

  static Future<String> enviaImagem(String uid, File imagem) async {
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child(uid + DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imagem);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static deletaImagem(String url) async {
    await FirebaseStorage.instance
        .getReferenceFromUrl(url)
        .then((value) => value.delete());
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
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String cidade = await Geolocator()
        .placemarkFromPosition(position)
        .then((value) => value.first.subAdministrativeArea);
    await SharedPreferencesControle.setCidade(cidade);
    await SharedPreferencesControle.setPosition(position);
  }
}
