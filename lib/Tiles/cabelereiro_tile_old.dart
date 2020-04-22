import 'package:agendacabelo/Telas/preco_tela_old.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CabelereiroTileOld extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const CabelereiroTileOld(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.content_cut),
      title: Text(snapshot.data['nome']),
      trailing: Icon(FontAwesome.chevron_right),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PrecoTelaOld(snapshot)));
      },
    );
  }
}
