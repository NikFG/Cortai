import 'dart:convert';

import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/home_store.dart';
import 'package:cortai/Telas/web_view_tela.dart';
import 'package:cortai/Tiles/home_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/carousel_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:cortai/Widgets/shimmer_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import 'maps_tela.dart';

class HomeTela extends StatefulWidget {
  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  late HomeStore store;
  var endereco = TextEditingController();

  String cidade = SharedPreferencesControle.getCidade();

  var param = '';

  @override
  void initState() {
    store = HomeStore();
    store.status = SharedPreferencesControle.getPermissionStatus();
    store.setEndereco(SharedPreferencesControle.getEndereco());
    if (store.endereco.isNotEmpty) {
      store.latitude =
          SharedPreferencesControle.getPosition().latitude.toString();
      store.longitude =
          SharedPreferencesControle.getPosition().longitude.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                "Novidades",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"),
              ),
            ),
          ],
        ),
        CarouselCustom(),
        Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Salões",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins"),
            )),
        Observer(
          builder: (context) {
            if (store.getPermissao) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MapsTela(
                                latLngChanged: (LatLng value) async {
                                  await SharedPreferencesControle.setPosition(
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
                                  store.latitude = value.latitude.toString();
                                  store.longitude = value.longitude.toString();
                                },
                                cidadeChanged: (String value) async {
                                  await SharedPreferencesControle.setCidade(
                                      value);
                                  cidade = value;
                                },
                                enderecoChanged: (String value) async {
                                  await SharedPreferencesControle.setEndereco(value);
                                  await store.setEndereco(value);
                                },
                              )));
                    },
                    child: AbsorbPointer(
                      child: FormFieldCustom(
                        controller: endereco,
                        inputType: TextInputType.text,
                        hint: "Digite seu endereço",
                        icon: Icon(FontAwesome.map),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (store.latitude != null && store.longitude != null) {
              param =
                  "?cidade=$cidade&latitude=${store.latitude!}&longitude=${store.longitude!}";

              return ScopedModelDescendant<LoginModelo>(
                builder: (context, child, model) {
                  return FutureBuilder<http.Response>(
                    future: http.get(SalaoControle.get(param),
                        headers: Util.token(model.token)),
                    builder: (context, response) {
                      if (!response.hasData) {
                        return ShimmerCustom(3);
                      } else {
                        if (response.data!.statusCode == 204) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Não há salões para a sua cidade atualmente",
                                  textAlign: TextAlign.justify,
                                ),
                                TextButton(
                                  onPressed: () {
                                    String urlForm =
                                        'https://docs.google.com/forms/d/e/1FAIpQLSdbwi9TmLX0YPW6B7TFJCHnFwuUe80lgPPbBu0mhzrvMgJSbw/viewform?usp=sf_link';
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WebViewTela(
                                                urlForm,
                                                "Sugerir novo salão")));
                                  },
                                  child: Text(
                                    "Sugerir novo salão",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        print(response.data!.body);
                        List<dynamic> dados = json.decode(response.data!.body);

                        List<Widget> widgets = dados
                            .map((s) => HomeTile(Salao.fromJson(s)))
                            .toList();
                        return Column(
                          children: widgets,
                        );
                      }
                    },
                  );
                },
              );
            } else {
              return Center();
            }
          },
        ),
      ],
    );
  }
}
