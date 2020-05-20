import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Tiles/home_tile.dart';
import 'package:agendacabelo/Util/haversine.dart';
import 'package:agendacabelo/Widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int cont = 0;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(children: [
        Row(
          children: <Widget>[
            Text(
              "  Novidades",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
        Carousel(),
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
              print("To aqui $cont");
              cont++;
              return FutureBuilder<Position>(
                  future: Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.best),
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
                          .map((doc) => HomeTile(
                              SalaoDados.fromDocument(doc), currentLocation))
                          .toList();

                      return Column(
                        children: widgets,
                      );
                    }
                  });
            }
          },
        ),
      ]),
    );
  }

  Future<Null> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
  }
}
