import 'dart:convert';

import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/cadastro_funcionamento_tela.dart';
import 'package:cortai/Telas/editar_perfil.dart';
import 'package:cortai/Telas/editar_salao_tela.dart';
import 'package:cortai/Telas/login_tela.dart';
import 'package:cortai/Telas/solicitacao_cabeleireiro_tela.dart';
import 'package:cortai/Telas/web_view_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/maps_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PerfilTela extends StatefulWidget {
  @override
  _PerfilTelaState createState() => _PerfilTelaState();
}

class _PerfilTelaState extends State<PerfilTela> {
  File _imagem;
  final pasta = 'Imagens perfis';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null)
          return Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
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
                          String url = await Util.enviaImagem(
                              model.dados.id.toString(), _imagem, pasta);
                          Firestore.instance
                              .collection('usuarios')
                              .document(model.dados.id.toString())
                              .updateData({'fotoURL': url});
                          model.dados.imagemUrl = url;
                          setState(() {});
                        }
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: model.dados.imagemUrl == null
                            ? AssetImage('assets/images/user.png')
                            : NetworkImage(model.dados.imagemUrl),
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
                            builder: (context) => MapsTela(
                                  enderecoChanged: (value) {
                                    SharedPreferencesControle.setEndereco(
                                        value);
                                  },
                                  latLngChanged: (LatLng value) {
                                    SharedPreferencesControle.setPosition(
                                        Position(
                                            latitude: value.latitude,
                                            longitude: value.longitude));
                                  },
                                  cidadeChanged: (String value) {
                                    SharedPreferencesControle.setCidade(value);
                                  },
                                  endereco:
                                      SharedPreferencesControle.getEndereco(),
                                  lat: SharedPreferencesControle.getPosition()
                                      .latitude,
                                  lng: SharedPreferencesControle.getPosition()
                                      .longitude,
                                )));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.map_o,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Mudar endereço",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )),
                  Divider(
                    color: Colors.black87,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WebViewTela(
                                'https://docs.google.com/forms/d/e/1FAIpQLSdbwi9TmLX0YPW6B7TFJCHnFwuUe80lgPPbBu0mhzrvMgJSbw/viewform?usp=sf_link',
                                "Sugerir novo salão")));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesome.lightbulb_o,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Sugerir novo salão",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black87,
                  ),
                  _widgetsDonoSalao(model.dados, model),
                  FlatButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationName: "Cortaí",
                            applicationVersion: "1.0",
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTela(
                                          'https://br.freepik.com/fotos-vetores-gratis/cabelo',
                                          "Licença")));
                                },
                                child: Text(
                                    "Vetores criados por stories - br.freepik.com"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTela(
                                          'https://stories.freepik.com/?utm_source=Stories&utm_medium=referral&utm_campaign=web-attribution&utm_term=copy%20and%20attribute&utm_content=donwload-pop-up',
                                          "Licença")));
                                },
                                child:
                                    Text("Illustration by Stories by Freepik"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTela(
                                          'https://stories.freepik.com/coronavirus?utm_source=Stories&utm_medium=referral&utm_campaign=web-attribution&utm_term=copy%20and%20attribute&utm_content=donwload-pop-up',
                                          "Licença")));
                                },
                                child:
                                    Text("Illustration by Stories by Freepik"),
                              ),
                            ],
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
                      onPressed: () async {
                        await model.logout();
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

  Widget _widgetsDonoSalao(Login login, LoginModelo model) {
    if (login.isDonoSalao) {
      return Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CadastroFuncionamentoTela()));
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
                var response = await http.get(
                    SalaoControle.show(login.salao_id),
                    headers: Util.token(model.token));
                print(response.body);
                Salao salao =
                    Salao.fromJsonApiDados(json.decode(response.body));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditarSalaoTela(salao: salao)));
              },
              child: login.salao_id != null
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
                    builder: (context) =>
                        SolicitacaoCabeleireiroTela(login.salao)));
              },
              child: Row(children: <Widget>[
                Icon(
                  FontAwesome.users,
                  color: Colors.black54,
                ),
                SizedBox(width: 10),
                Text("Cadastrar cabeleireiros", style: TextStyle(fontSize: 18))
              ])),
          Divider(
            color: Colors.black45,
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }
}
