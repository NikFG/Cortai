import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HorarioTela extends StatefulWidget {
  @override
  _HorarioTelaState createState() => _HorarioTelaState();
}

class _HorarioTelaState extends State<HorarioTela> {
  int _radioValue = -1;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Horários"),
        centerTitle: true,
      ),
      body: GridView.count(
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
                        "01/05/2020 15:30",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Disponível",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 10.0,
                        indent: 5.0,
                        thickness: 3,
                        color: Colors.black87,
                      ),
                      Text(
                        "Contato: 37 99999-9999",
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
      ),
    );
  }

  String TimestampToString(Timestamp timestamp) {
    var formatter = new DateFormat('dd/MM/yyyy, H:mm');
    String formatted = formatter
        .format(DateTime.parse(timestamp.toDate().toLocal().toString()));
    return formatted;
  }
}
