import 'dart:convert';

import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/home_tile.dart';
import 'package:agendacabelo/Util/haversine.dart';
import 'package:agendacabelo/Widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int cont = 0;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  int limite = 4;
  bool temMais = true;
  bool isLoading = false;
  DocumentSnapshot ultimoSalao;
  List<DocumentSnapshot> saloes = [];
  ScrollController _scrollController = ScrollController();
  static const _link =
      'https://us-central1-agendamento-cortes.cloudfunctions.net/calculaDistancia';

  @override
  void initState() {
    super.initState();
//    getSaloes();
//    _scrollController.addListener(() {
//      double maxScroll = _scrollController.position.maxScrollExtent;
//      double currentScroll = _scrollController.position.pixels;
//      double delta = MediaQuery.of(context).size.height * 0.25;
//      if (maxScroll - currentScroll <= delta) {
//        getSaloes();
//      }
//    });
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
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Novidades",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
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
        FutureBuilder<Position>(
            future: Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.best),
            builder: (context, localizacao) {
              if (!localizacao.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                //TODO Se permissão negada perguntar endereço de casa
                if (_permissionStatus.isUndetermined ||
                    _permissionStatus.isDenied)
                  requestPermission(Permission.location);
                var currentLocation = localizacao.data;
                var lat = currentLocation.latitude;
                var lng = currentLocation.longitude;

                return FutureBuilder<List<Placemark>>(
                  future: Geolocator().placemarkFromPosition(currentLocation),
                  builder: (context, placemark) {
                    if (!placemark.hasData) {
                      return Center();
                    } else {
                      String cidade =
                          placemark.data.first.subAdministrativeArea;
                      var url =
                          "$_link?cidade=$cidade&lat=${lat.toString()}&lng=${lng.toString()}";
                      return FutureBuilder<http.Response>(
                        future: http.get(url),
                        builder: (context, response) {
                          if (!response.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
//                            if (response.data.statusCode == 200)

                            List<dynamic> dados =
                                json.decode(response.data.body);
                            List<Widget> widgets = dados
                                .map((s) => HomeTile(SalaoDados.fromJson(s),
                                    s['distancia'] as double))
                                .toList();

//

                            return Column(
                              children: widgets,
                            );
                          }
                        },
                      );
                    }
                  },
                );

//                List<Widget> widgets = lista
//                    .map((doc) =>
//                        HomeTile(SalaoDados.fromDocument(doc), currentLocation))
//                    .toList();

//                return Column(
//                  children: widgets,
//                );
              }
            }),
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: 0,
                width: 0,
              )
      ],
    );
  }

  Future<Null> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
  }

  getSaloes() async {
    if (!temMais) {
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (ultimoSalao == null) {
      querySnapshot = await SalaoControle.get()
          .where('cidade', isEqualTo: 'Divinópolis')
          .orderBy('cidade')
          .orderBy('nome')
          .limit(limite)
          .getDocuments();
    } else {
      querySnapshot = await SalaoControle.get()
          .where('cidade', isEqualTo: 'Divinópolis')
          .orderBy('cidade')
          .orderBy('nome')
          .startAfterDocument(ultimoSalao)
          .limit(limite)
          .getDocuments();
    }
    if (querySnapshot.documents.length < limite) {
      temMais = false;
    }
    ultimoSalao = querySnapshot.documents[querySnapshot.documents.length - 1];
    saloes.addAll(querySnapshot.documents);
    setState(() {
      isLoading = false;
    });
  }
}
