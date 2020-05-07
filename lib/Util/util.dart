import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static String TimestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }

  static Timestamp StringToTimestamp(String horario) {
    horario =horario.substring(5);
    horario = horario.replaceAll("/", "-");
    horario = horario.replaceAll(",", "");
    DateFormat format = new DateFormat('dd-MM-yyyy H:m');
    return Timestamp.fromDate(format.parse(horario));
  }
  static DateTimeofDayToDateTime(DateTime dt, TimeOfDay time) {
    return new DateTime(dt.year, dt.month, dt.day, time.hour, time.minute);
  }
  static LligacaoTelefone(String telefone) async {
    if (await canLaunch(telefone)) {
      await launch(telefone);
    } else {
      throw 'Could not launch $telefone';
    }
  }
}
