import 'package:agendacabelo/Controle/forma_pagamento_controle.dart';
import 'package:agendacabelo/Dados/forma_pagamento_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomPayment(),
  ));
}

class CustomPayment extends StatefulWidget {
  @override
  createState() {
    return CustomPaymentState();
  }
}

class CustomPaymentState extends State<CustomPayment> {
  List<RadioModel> lista= [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,

      child: FutureBuilder<QuerySnapshot>(
          future: FormaPagamentoControle.get().getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              lista = snapshot.data.documents.map((doc) {
                return RadioModel(false, FormaPagamentoDados.fromDocument(doc));
              }).toList();
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: lista.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    //highlightColor: Colors.red,
                    splashColor: Theme.of(context).accentColor,
                    onTap: () {
                      setState(() {
                        lista.forEach((element) => element.isSelected = false);
                        lista[index].isSelected = true;
                      });
                    },
                    child: RadioItem(lista[index]),
                  ));
                },
              );
            }
          }),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50.0,

            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(_item.formaPagamentoDados.icone),
                  backgroundColor: Colors.transparent,
                  radius: 10,
                ),
                Text(_item.formaPagamentoDados.descricao,
                    style: TextStyle(
                        color: _item.isSelected ? Colors.white : Colors.black,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18.0)),
              ],
            ),
            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Theme.of(context).accentColor
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;

  final FormaPagamentoDados formaPagamentoDados;

  RadioModel(
    this.isSelected,
    this.formaPagamentoDados,
  );
}
