import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Telas/marcar_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final SalaoDados dados;

  HomeTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MarcarTela(dados.id))),
        child:Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                        image: NetworkImage(dados.imagem), fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dados.nome,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "4.0", //TODO Select com média de avaliações
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.black38, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(200)",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre RS 15.00 ~ RS 100.00",
                              //TODO min e max preços de serviços
                              style:
                              TextStyle(fontSize: 9, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),

                  Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.bottomCenter,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => MarcarTela(dados.id))),
                      ),
                      ButtonTheme(
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minWidth: 0,
                          height: 0,
                          child: FlatButton(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            onPressed: () => _dialogDados(context),
                            child: Text(
                              'Saiba mais',
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor),
                            ),
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),),
    );
  }

  _dialogDados(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Mais informações"),
            content: Text("${dados.endereco}"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  Util.LigacaoTelefonica("tel:" + dados.telefone);
                },
                child: Text("Ligar para salão"),
              ),
            ],
          );
        });
  }
}
