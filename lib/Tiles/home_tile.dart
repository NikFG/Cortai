import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:agendacabelo/Dados/cabelereiro_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:agendacabelo/Telas/salao_tela.dart';

class HomeTile extends StatefulWidget {
  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  int _current = 0;

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
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(item,
                                fit: BoxFit.cover, width: 1000.0),
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
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        children: <Widget>[
          Text(
            "  Salões",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Celminhos Barber's",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "4.0",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.black38, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(200)",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre RS 15.00 ~ RS 100.00",
                              style:
                                  TextStyle(fontSize: 9, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalaoTela()));
                        },
                      ),
                      Text(
                        'Ver mais',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Celminhos Barber's",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "4.0",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.black38, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(200)",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre RS 15.00 ~ RS 100.00",
                              style:
                                  TextStyle(fontSize: 9, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalaoTela()));
                        },
                      ),
                      Text(
                        'Ver mais',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Celminhos Barber's",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "4.0",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.black38, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(200)",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre RS 15.00 ~ RS 100.00",
                              style:
                                  TextStyle(fontSize: 9, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalaoTela()));
                        },
                      ),
                      Text(
                        'Ver mais',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: new DecorationImage(
                        image: new NetworkImage(
                            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width - 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Celminhos Barber's",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "4.0",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.amber, size: 10.0),
                                Icon(Icons.star,
                                    color: Colors.black38, size: 10.0),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "(200)",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Entre RS 15.00 ~ RS 100.00",
                              style:
                                  TextStyle(fontSize: 9, color: Colors.black38),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalaoTela()));
                        },
                      ),
                      Text(
                        'Ver mais',
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
