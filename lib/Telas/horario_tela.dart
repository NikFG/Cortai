import 'package:agendacabelo/Dados/disponibilidade_dados.dart';
import 'package:agendacabelo/Tiles/horario_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorarioTela extends StatelessWidget {
  final String cabelereiro_id;

  const HorarioTela(this.cabelereiro_id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Horários"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("usuarios")
            .document(this.cabelereiro_id)
            .collection('disponibilidade')
            .where('ocupado',isEqualTo: false)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return  GridView.builder(
                padding: EdgeInsets.all(4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 2.1),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DisponibilidadeDados dados =
                  DisponibilidadeDados.fromDocument(snapshot.data.documents[index]);
                  return HorarioTile(dados,this.cabelereiro_id);
                });
          }
        },
      ),
    );
  }
}
