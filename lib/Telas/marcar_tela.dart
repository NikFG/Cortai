import 'package:agendacabelo/Dados/cabeleireiro_dados.dart';
import 'package:agendacabelo/Tiles/marcar_tile.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MarcarTela extends StatelessWidget {
  final String salao_id;

  MarcarTela(this.salao_id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmar horário e serviço"),
        centerTitle: true,
        leading: Util.leadingScaffold(context)
      ),
      body: Material(
        child: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("usuarios")
              .where("salao", isEqualTo: salao_id)
              .where("cabeleireiro", isEqualTo: true)
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.all(4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.3),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                CabeleireiroDados dados = CabeleireiroDados.fromDocument(
                    snapshot.data.documents[index]);
                return MarcarTile(dados);
              },
            );
          },
        ),
      ),
    );
  }
}
