import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class ConfirmarTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const ConfirmarTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.error,
        color: Colors.yellow,
      ),
      title: Text(_TimestampToString(snapshot.data['horario'])),
      subtitle: Text(
        "Confirmar",
        style: TextStyle(color: Theme.of(context).primaryColor),
        textAlign: TextAlign.start,
      ),
      trailing: Icon(FontAwesome.chevron_right),
      onTap: () async {
        await Firestore.instance
            .collection("cabelereiros")
            .document("GMy6pGj4ryDJLCZvnjoy")
            .collection("horarios")
            .document(snapshot.documentID)
            .updateData({
          "confirmado": true,
        });
//        Navigator.of(context).push(MaterialPageRoute(
//            builder: (context) => PrecoTela(snapshot)));
      },
    );
  }

  String _TimestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }
}
