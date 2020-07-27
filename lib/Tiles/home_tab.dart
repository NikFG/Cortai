import 'dart:convert';
import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Telas/web_view_tela.dart';
import 'package:cortai/Tiles/home_tile.dart';
import 'package:cortai/Widgets/carousel.dart';
import 'package:cortai/Widgets/custom_form_field.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:cortai/Widgets/maps_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  PermissionStatus _permissionStatus;
  ScrollController _scrollController = ScrollController();
  List<Placemark> local;
  var endereco = TextEditingController();

  String cidade = SharedPreferencesControle.getCidade();
  var _link =
      'https://us-central1-cortai-349b0.cloudfunctions.net/calculaDistancia';
  var url = '';

  @override
  void initState() {
    super.initState();
    _permissionStatus = SharedPreferencesControle.getPermissionStatus();
    getEndereco();

    String latitude =
        SharedPreferencesControle.getPosition().latitude.toString();
    String longitude =
        SharedPreferencesControle.getPosition().longitude.toString();
    url = "$_link?cidade=$cidade&lat=$latitude&lng=$longitude";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
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
        Carousel(),
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
        getPermissaoLocal()
            ? Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MapsTela(
                                latLngChanged: (LatLng value) async {
                                  await SharedPreferencesControle.setPosition(
                                      Position(
                                          latitude: value.latitude,
                                          longitude: value.longitude));
                                },
                                cidadeChanged: (String value) async {
                                  await SharedPreferencesControle.setCidade(
                                      value);
                                },
                                enderecoChanged: (String value) async {
                                  await SharedPreferencesControle.setEndereco(
                                      endereco.text);
                                  await getEndereco();
                                  setState(() {});
                                },
                              )));
                    },
                    child: AbsorbPointer(
                      child: CustomFormField(
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
              )
            : FutureBuilder<http.Response>(
                future: http.get(url),
                builder: (context, response) {
                  if (!response.hasData) {
                    return CustomShimmer(3);
                  } else {
                    if (response.data.statusCode == 404) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              response.data.body,
                              textAlign: TextAlign.justify,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WebViewTela(
                                        'https://docs.google.com/forms/d/e/1FAIpQLSdbwi9TmLX0YPW6B7TFJCHnFwuUe80lgPPbBu0mhzrvMgJSbw/viewform?usp=sf_link',
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
                    List<dynamic> dados = json.decode(response.data.body);
                    List<Widget> widgets = dados
                        .map((s) => HomeTile(
                            Salao.fromJson(s), s['distancia'] as double))
                        .toList();
                    return Column(
                      children: widgets,
                    );
                  }
                },
              ),
      ],
    );
  }

  getPermissaoLocal() {
    if ((_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) &&
        cidade.isEmpty &&
        endereco.text.isEmpty) {
      return true;
    }
    return false;
  }

  getEndereco() async {
    if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
      String endereco = SharedPreferencesControle.getEndereco();
      if (endereco != null) if (endereco.isNotEmpty) {
        this.endereco.text = endereco;
        local = await Geolocator().placemarkFromAddress(endereco);
      }
    }
  }
}
