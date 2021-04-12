import 'dart:async';

import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

const API_KEY = "AIzaSyBN_mWl_3BjJLCPkKzCKaCqu2Wv8pe0UFw";

class MapsTela extends StatefulWidget {
  final ValueChanged<String> enderecoChanged;
  final ValueChanged<LatLng> latLngChanged;
  final ValueChanged<String> cidadeChanged;
  final String endereco;
  final double lat;
  final double lng;

  MapsTela(
      {required this.enderecoChanged,
      required this.latLngChanged,
      required this.cidadeChanged,
      this.endereco = "",
      this.lat = 0,
      this.lng = 0});

  @override
  _MapsTelaState createState() => _MapsTelaState();
}

class _MapsTelaState extends State<MapsTela> {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: API_KEY);
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  var procuraController = TextEditingController();
  var latLng;

  @override
  void initState() {
    super.initState();
    latLng = LatLng(widget.lat, widget.lng);
    procuraController.text = widget.endereco;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        color: Theme.of(context).primaryColor,
        icon: Icon(Icons.my_location),
        onPressed: recarregaMaps,
      ),
      appBar: AppBar(
        title: Text("Selecione o endereço"),
        centerTitle: true,
        leading: Util.leadingScaffold(context),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.enderecoChanged(procuraController.text);
              widget.latLngChanged(latLng);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) async {
              mapController = controller;
              if (widget.lat != 0) {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: latLng, zoom: 20.0)));
                setState(() {
                  _markers.add(marker(LatLng(widget.lat, widget.lng)));
                });
              } else
                recarregaMaps();
            },
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onTap: (latLng) async {
              setState(() {
                this.latLng = latLng;
              });
              _marcarMapaPrevisao();
              widget.cidadeChanged("");
              var coordinates =
                  new Coordinates(latLng.latitude, latLng.longitude);
              var endereco = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              procuraController.text = endereco.first.addressLine;
              widget.cidadeChanged(endereco.first.subAdminArea);
            },
            initialCameraPosition: CameraPosition(target: latLng, zoom: 1),
            markers: _markers,
//                );
//              }
//            },
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: GestureDetector(
                  onTap: _barraPesquisaPlaces,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: procuraController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Digite seu endereço',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, top: 15),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _barraPesquisaPlaces,
                          iconSize: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  recarregaMaps() async {
    procuraController.text = '';
    setState(() {
      _markers.clear();
    });

    PermissionStatus status = SharedPreferencesControle.getPermissionStatus();
    var latlng;
    if (status.isGranted) {
      var location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      latlng = LatLng(location.latitude, location.longitude);
    }
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latlng == null ? LatLng(0, 0) : latlng, zoom: 20.0)));
  }

  void onError(response) {
    print(response.errorMessage);
  }

  Future<void> _barraPesquisaPlaces() async {
    Prediction? p = await PlacesAutocomplete.show(
      hint: 'Digite seu endereço',
      startText: procuraController.text,
      context: context,
      apiKey: API_KEY,
      mode: Mode.overlay,
      onError: onError,
      language: "pt",
    );
    _mostraPrevisao(p);
  }

  Future<Null> _mostraPrevisao(Prediction? p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      latLng = LatLng(lat, lng);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      widget.cidadeChanged(placemarks.first.subAdministrativeArea!);

      procuraController.text = p.description!;
      _marcarMapaPrevisao();
    }
  }

  Future<Null> _marcarMapaPrevisao() async {
    setState(() {
      _markers.add(marker(latLng));
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 20)));
  }

  marker(LatLng latLng) {
    return Marker(markerId: MarkerId('home'), position: latLng);
  }
}
