import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HorarioDados {
  String id;
  String horario;
  bool ocupado;

  HorarioDados.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    horario = _TimestampToString(snapshot.data["horario"]);
    ocupado = snapshot.data["ocupado"];
  }

  Map<String, dynamic> toMap() {
    return {
      "horario": horario,
      "ocupado": ocupado,
    };
  }

  String _TimestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }
}
