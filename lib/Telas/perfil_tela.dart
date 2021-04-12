import 'dart:convert';
import 'dart:io';

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
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

import 'gerenciar_servico_tela.dart';
import 'maps_tela.dart';

class PerfilTela extends StatefulWidget {
  @override
  _PerfilTelaState createState() => _PerfilTelaState();
}

class _PerfilTelaState extends State<PerfilTela> {
  File? _imagem;

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
                      model.dados!.nome,
                      style: TextStyle(
                          fontSize: 20.0.sp, fontWeight: FontWeight.w600),
                    ),
                    subtitle: InkWell(
                        child: Text(
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditarPerfilTela(model.dados!)));
                        }),
                    leading: GestureDetector(
                      onTap: () async {
                        await getImagem();
                        if (_imagem != null) {
                          model.atualizaImagem(
                              file: _imagem!,
                              onSucess: onSuccess,
                              onFail: onFail);
                        }
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: model.dados!.imagem == null
                            ? AssetImage('assets/images/user.png')
                            : MemoryImage(base64Decode(model.dados!.imagem!))
                                as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
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
                                      longitude: value.longitude,
                                      speedAccuracy: 0,
                                      accuracy: 100,
                                      altitude: 0,
                                      timestamp: null,
                                      speed: 0,
                                      heading: 0,
                                    ));
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
                            style: TextStyle(fontSize: 16.0.sp),
                          )
                        ],
                      )),
                  Divider(
                    color: Colors.black87,
                  ),
                  TextButton(
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
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black87,
                  ),
                  _widgetsDonoSalao(model.dados!, model),
                  TextButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationName: "Cortaí",
                            applicationVersion: "1.0",
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTela(
                                          'https://br.freepik.com/fotos-vetores-gratis/cabelo',
                                          "Licença")));
                                },
                                child: Text(
                                    "Vetores criados por stories - br.freepik.com"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTela(
                                          'https://stories.freepik.com/?utm_source=Stories&utm_medium=referral&utm_campaign=web-attribution&utm_term=copy%20and%20attribute&utm_content=donwload-pop-up',
                                          "Licença")));
                                },
                                child:
                                    Text("Illustration by Stories by Freepik"),
                              ),
                              TextButton(
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
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    color: Colors.black45,
                  ),
                  TextButton(
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
                              fontSize: 16.0.sp,
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
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CadastroFuncionamentoTela()));
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
                    fontSize: 16.0.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
          TextButton(
              onPressed: () async {
                var response = await http.get(
                    SalaoControle.show(login.salaoId!),
                    headers: Util.token(model.token));
                print(response.body);
                Salao salao =
                    Salao.fromJsonApiDados(json.decode(response.body));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditarSalaoTela(salao: salao)));
              },
              child: login.salaoId != null
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
                            fontSize: 16.0.sp,
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
                            fontSize: 16.0.sp,
                          ),
                        ),
                      ],
                    )),
          Divider(
            color: Colors.black45,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GerenciarServicoTela()));
              },
              child: Row(children: <Widget>[
                Icon(
                  FontAwesome.scissors,
                  color: Colors.black54,
                ),
                SizedBox(width: 10),
                Text("Editar Serviços", style: TextStyle(fontSize: 16.0.sp))
              ])),
          Divider(
            color: Colors.black45,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SolicitacaoCabeleireiroTela()));
              },
              child: Row(children: <Widget>[
                Icon(
                  FontAwesome.users,
                  color: Colors.black54,
                ),
                SizedBox(width: 10),
                Text("Cadastrar cabeleireiros",
                    style: TextStyle(fontSize: 16.0.sp))
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

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            message: "Informações de usuário atualizadas com sucesso")
        .show(context);
    setState(() {});
  }

  void onFail(String error) async {
    await FlushbarHelper.createError(message: error).show(context);
  }
}
