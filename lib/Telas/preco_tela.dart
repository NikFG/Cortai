import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Tiles/preco_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrecoTela extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PrecoTela(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Horários de " + this.snapshot.data['apelido']),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlushbarHelper.createSuccess(
                    message: "Aguarde confirmação do cabelereiro!!",
                    title: "Agendamento feito")
                .show(context);
          },
          child: Icon(Icons.schedule),
          backgroundColor: Colors.blueAccent[500],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("cabelereiros")
              .document(this.snapshot.documentID)
              .collection("precos")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.builder(
                  padding: EdgeInsets.all(4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1.5),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    PrecoDados dados =
                        PrecoDados.fromDocument(snapshot.data.documents[index]);
                    return PrecoTile(dados);
                  });
            }
          },
        )

        /*GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("01/05/2020 15:30",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center),
                          Text(
                            "Disponível",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            height: 10.0,
                            indent: 5.0,
                            thickness: 3,
                            color: Colors.black87,
                          ),
                          Text(
                            "Contato:\n(37) 99999-9999",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Preço: R\$15,00",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Celminho",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 10.0,
                            indent: 5.0,
                            thickness: 3,
                            color: Colors.black87,
                          ),
                          Text(
                            "01/05/2020 14:30",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Ocupado",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Text("teste"),
          Radio(
            value: 2,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text("teste"),
        ],
      ),*/
        );
  }
}
