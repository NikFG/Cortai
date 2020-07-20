import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/cadastro_funcionamento_tela.dart';
import 'package:agendacabelo/Telas/checkin_tela.dart';
import 'package:agendacabelo/Telas/editar_perfil.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/Telas/solicitacao_cabeleireiro_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

class PerfilTela extends StatefulWidget {
  @override
  _PerfilTelaState createState() => _PerfilTelaState();
}

class _PerfilTelaState extends State<PerfilTela> {
  File _imagem;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null)
          return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      model.dados.nome,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    subtitle: InkWell(
                        child: Text(
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditarPerfilTela(model.dados)));
                        }),
                    leading: GestureDetector(
                      onTap: () async {
                        await getImagem();
                        if (_imagem != null) {
                          String url =
                              await Util.enviaImagem(model.dados.id, _imagem);
                          Firestore.instance
                              .collection('usuarios')
                              .document(model.dados.id)
                              .updateData({'fotoURL': url});
                          model.dados.imagemUrl = url;
                          setState(() {});
                        }
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          model.dados.imagemUrl != null
                              ? model.dados.imagemUrl
                              : "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CadastroFuncionamentoTela(model.dados.salao)));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesome.clock_o,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Horário de funcionamento",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () async {
                        var salaoDados = await SalaoControle.get()
                            .document(model.dados.salao)
                            .get()
                            .then((doc) {
                          return Salao.fromDocument(doc);
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditarSalaoTela(
                                model.dados.id,
                                salao: salaoDados)));
                      },
                      child: model.dados.salao != null
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesome.address_book_o,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Editar salão",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesome.address_book_o,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Criar salão",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckinTela()));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.bar_chart,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Relatórios",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SolicitacaoCabeleireiroTela(
                                model.dados.salao)));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.users,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Cadastrar cabeleireiros",
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationName: "Cortaí",
                            applicationVersion: "1.0",
                            applicationIcon: Image.asset(
                              "assets/icons/icon_white.png",
                              width: 100,
                              height: 100,
                            ));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.info_circle,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Sobre",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationName: "Cortaí",
                            applicationVersion: "1.0",
                            applicationIcon: Image.asset(
                              "assets/icons/icon_white.png",
                              width: 100,
                              height: 100,
                            ));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.info_circle,
                            color: Colors.black54,
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black45,
                  ),
                  FlatButton(
                      onPressed: () async {
                        await model.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginTela()));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.power_off,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ))
                ],
              ));
        else
          return Center();
      },
    );
  }

  Future<Null> getImagem() async {
    var picker = ImagePicker();
    var imagem = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagem != null) {
        _imagem = File(imagem.path);
      }
    });
  }
}
