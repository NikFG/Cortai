import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Util/util.dart';

class AgendaTela extends StatelessWidget {
  List<String> buttonList = [
    "Fernando",
    "Mateus",
    "Ana",
    "Julia",
    "Marcus",
    "Celmo",
  ];
  List<String> horarioList = ["16:30", "19:30", "10:00", "15:00"];
  List<String> dataList = [
    '13/06/2020',
    '14/06/2020',
    '15/06/2020',
    '16/06/2020'
  ];
  List<String> paymentList = ["Dinheiro", "Cartão"];
  String dropdownValue = '13/06/2020';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Marcar"),
          centerTitle: true,
          leading: Util.leadingScaffold(context)),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 30),
                      child: Container(
                          child: GFAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                              ),
                              shape: GFAvatarShape.standard)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Container(
                                  child: Text(
                                    "Corte Topster",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Flexible(
                                    child: Text(
                                      "Breve descrição,",
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 13),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Selecione o Profissional :",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: CustomRadioButton(
                        buttonLables: buttonList,
                        buttonValues: buttonList,
                        radioButtonValue: (value) => print(value),
                        horizontal: true,
                        enableShape: true,
                        buttonSpace: 1,
                        buttonColor: Colors.white,
                        selectedColor: Theme.of(context).accentColor,
                        //buttonWidth: 90,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Quando seria melhor para você ?",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
               /* Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Em qual dia ?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),

                  // dropdown below..
                  child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: SizedBox(),
                        onChanged: (String newValue) {},
                        items: <String>[
                          '13/06/2020',
                          '14/06/2020',
                          '15/06/2020',
                          '16/06/2020'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                  )),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Qual horario?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1),
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: CustomRadioButton(
                        buttonLables: horarioList,
                        buttonValues: horarioList,
                        radioButtonValue: (value) => print(value),
                        horizontal: true,
                        enableShape: false,
                        buttonSpace: 0,
                        buttonColor: Colors.white,
                        selectedColor: Theme.of(context).accentColor,
                        buttonWidth: 190,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Você tem um código de desconto?',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/1.1,
                  height: 45,
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ]),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '7C845AB',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Como você gostaria de pagar?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: CustomRadioButton(
                        buttonLables: paymentList,
                        buttonValues: paymentList,
                        radioButtonValue: (value) => print(value),
                        horizontal: true,
                        enableShape: false,
                        buttonSpace: 0,
                        buttonColor: Colors.white,
                        selectedColor: Colors.lightBlueAccent[700],
                        buttonWidth: 190,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).accentColor),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: FlatButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AgendaTela())),
                            child: Center(
                                child: Text(
                              'Confirmar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
