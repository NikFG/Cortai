import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Telas/criar_servico_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarServicoTela extends StatelessWidget {
  final String salao;

  EditarServicoTela(this.salao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar serviço"),
          leading: Util.leadingScaffold(context),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection('servicos')
              .where('salao', isEqualTo: salao)
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List widgets = snapshot.data.documents.map((doc) {
                PrecoDados dados = PrecoDados.fromDocument(doc);
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text("Editar serviço"),
                            centerTitle: true,
                            leading: Util.leadingScaffold(context),
                          ),
                          body: CriarServicoTela(
                            precoDados: dados,
                          )))),
                  child: ListTile(
                    title: Text(dados.descricao),
                  ),
                );
              }).toList();
              return ListView(children: widgets);
            }
          },
        ));
  }
}
