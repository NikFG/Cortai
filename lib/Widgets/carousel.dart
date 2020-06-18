import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: SalaoControle.get().orderBy('nome').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var imgList =
              snapshot.data.documents.map((e) => e.data['imagem']).toList();
          return CarouselSlider(
            items: imgList
                .map((item) => Container(
                      height: 150,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  item,
                                  fit: BoxFit.fill,
                                  width: 1000.0,
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      '${snapshot.data.documents[_current].data['nome']}',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
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
          );
        }
      },
    );
  }
}
