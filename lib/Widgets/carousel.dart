import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _index = 0;
  List<String> imgList = [
    'assets/images/Saude.png',
    'assets/images/BarberMan.png',
    'assets/images/BarberMan2.png'
  ];
  List<String> txtList = [
    'Mantenha-se seguro, siga as recomendações de saúde da OMS.',
    'Encontre os melhores profissionais perto de você.',
    'Não corte nem lá nem cá, Cortaí! Economize tempo e dinheiro',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imgList
          .map((item) => Container(
                height: 150,
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image(
                          image: AssetImage(
                            item,
                          ),
                          width: 1000,
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // height:50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).accentColor,
                                  Theme.of(context).primaryColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              txtList[_index],
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                //fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )),
              ))
          .toList(),
      options: CarouselOptions(
          autoPlayInterval: Duration(seconds: 5),
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.5,
          onPageChanged: (index, reason) {
            setState(() {
              _index = index;
            });
          }),
    );
  }
}
