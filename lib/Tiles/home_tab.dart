import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/home_tile.dart';
import 'package:agendacabelo/Util/haversine.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _current = 0;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

    return ListView(children: [
      CarouselSlider(
        items: imgList
            .map((item) => Container(
                  height: 100,
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  'No. ${imgList.indexOf(item)} image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ))
            .toList(),
        options: CarouselOptions(
            autoPlayInterval: Duration(seconds: 3),
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.5,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Salões",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins"),
            ),
          )
        ],
      ),
      FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('saloes').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return FutureBuilder<Position>(
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
                    var lista = snapshot.data.documents.toList();
                    lista.sort((a, b) {
                      double distanciaA = Haversine.distancia(
                          lat1: currentLocation.latitude,
                          lon1: currentLocation.longitude,
                          lat2: a.data['latitude'],
                          lon2: a.data['longitude']);
                      double distanciaB = Haversine.distancia(
                          lat1: currentLocation.latitude,
                          lon1: currentLocation.longitude,
                          lat2: b.data['latitude'],
                          lon2: b.data['longitude']);

                      return distanciaA.compareTo(distanciaB);
                    });

                    List<Widget> widgets = lista
                        .map((doc) => HomeTile(SalaoDados.fromDocument(doc)))
                        .toList();

                    return Column(
                      children: widgets,
                    );
                  }
                });
          }
        },
      ),
    ]);
  }

  Future<Null> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}
