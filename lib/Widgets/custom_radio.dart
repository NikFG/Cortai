import 'package:agendacabelo/Controle/forma_pagamento_controle.dart';
import 'package:agendacabelo/Dados/forma_pagamento_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final ValueChanged<String> idPagamento;

  CustomRadio({@required this.idPagamento});

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  List<RadioModel> lista = List<RadioModel>();

  @override
  void initState() {
    super.initState();
    teste();
  }

  teste() async {
    var query = await FormaPagamentoControle.get().getDocuments();
    lista = query.documents
        .map((doc) => RadioModel(FormaPagamentoDados.fromDocument(doc), false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.8, mainAxisSpacing: 3),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 60,
              maxWidth: 60,
            ),
            child: InkWell(
              splashColor: Colors.orange,
              onTap: () {
                setState(() {
                  lista.forEach((e) => e.isSelected = false);
                  lista[index].isSelected = true;
                });
                widget.idPagamento(lista[index].dados.id);
              },
              child: RadioItem(lista[index]),
            ),
          );
        });
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel radioModel;

  RadioItem(this.radioModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: radioModel.isSelected
              ? Theme.of(context).accentColor
              : Colors.transparent,
          child: Image.network(
            radioModel.dados.icone,
            width: 50,
            height: 50,
          ),
        ),
        Text(radioModel.dados.descricao)
      ],
    );
  }
}

class RadioModel {
  final FormaPagamentoDados dados;
  bool isSelected;

  RadioModel(this.dados, this.isSelected);
}