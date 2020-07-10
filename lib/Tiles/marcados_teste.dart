import 'package:agendacabelo/Tiles/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:agendacabelo/Util/util.dart';

class MarcadosTeste extends StatefulWidget {
  @override
  _MarcadosTesteState createState() => _MarcadosTesteState();
}

class _MarcadosTesteState extends State<MarcadosTeste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
   
              Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                    height: 120,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.grey[300], width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Align(
                          alignment: Alignment.center,
                          child: ListTile(
                            onTap: () => {
                              _bottomSheetOpcoes(context),
                            },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRaOGV7L8JsPNtp6az4ylshydD4fqqBbPGLlw&usqp=CAU"),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(
                              "Fernando",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins'),
                            ),
                            subtitle: Text(
                              "Refatoramento facial às 06.07.2020 -> 18:00",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        )),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

  void _bottomSheetOpcoes(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(
                      Icons.beenhere,
                      color: Colors.green,
                    ),
                    title: new Text('Confirmar Horário'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StartScreen(
                 // dados: widget.dados,
                 // menorValor: _menorValor,
                 // maiorValor: _maiorValor,
                 // distancia: _distancia))
          ))),),
                ListTile(
                  leading: new Icon(Icons.remove_circle, color: Colors.red),
                  title: new Text('Cancelar Horário'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text('Voltar'),
                  onTap: () => {Navigator.pop(context)},
                ),
              ],
            ),
          );
        });
  }
}
