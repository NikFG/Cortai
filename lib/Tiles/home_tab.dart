import 'dart:convert';
import 'package:agendacabelo/Controle/shared_preferences_controle.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/home_tile.dart';
import 'package:agendacabelo/Widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      'https://us-central1-agendamento-cortes.cloudfunctions.net/calculaDistancia';
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
                  TextField(
                    controller: endereco,
                  ),
                  FlatButton(
                    onPressed: () async {
                      local = await Geolocator()
                          .placemarkFromAddress(endereco.text);
                      await SharedPreferencesControle.setEndereco(
                          endereco.text);
                      cidade = local.first.subAdministrativeArea;
                      SharedPreferencesControle.setCidade(cidade);
                      await SharedPreferencesControle.setPosition(
                          local.first.position);
                      var latLng = SharedPreferencesControle.getPosition();
                      url =
                          "$_link?cidade=$cidade&lat=${latLng.latitude.toString()}&lng=${latLng.longitude.toString()}";
                      setState(() {});
                    },
                    child: Text("Ok"),
                  )
                ],
              )
            : FutureBuilder<http.Response>(
                future: http.get(url),
                builder: (context, response) {
                  if (!response.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (response.data.statusCode == 404) {
                      return Center(
                        child: Text(response.data.body),
                      );
                    }
                    List<dynamic> dados = json.decode(response.data.body);
                    List<Widget> widgets = dados
                        .map((s) => HomeTile(
                            SalaoDados.fromJson(s), s['distancia'] as double))
                        .toList();
                    return Column(
                      children: widgets,
                    );
                  }
                },
              ), /*FutureBuilder<Position>(
                future: Geolocator()
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best),
                builder: (context, localizacao) {
                  if (!localizacao.hasData && local.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var currentLocation = localizacao.data;

                    if (local.isNotEmpty)
                      currentLocation = local.first.position;
                    var lat = currentLocation.latitude;
                    var lng = currentLocation.longitude;

                    return FutureBuilder<List<Placemark>>(
                      future:
                          Geolocator().placemarkFromPosition(currentLocation),
                      builder: (context, placemark) {
                        if (!placemark.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          String cidade =
                              placemark.data.first.subAdministrativeArea;
                          var url =
                              "$_link?cidade=$cidade&lat=${lat.toString()}&lng=${lng.toString()}";

                          return ;
                        }
                      },
                    );
                  }
                }),*/
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
