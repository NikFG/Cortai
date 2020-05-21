import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

class ServicoTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const IconCorte = 'assets/icons/corte.svg';
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                  )),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: Text(
                      "Salao o Taisu",
                        style: Theme.of(context).textTheme.display1.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            fontFamily: 'Poppins'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .99,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 40.0),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child:
                                    SvgPicture.asset("assets/icons/corte.svg"),
                              ),
                              Spacer(),
                              Text(
                                "Corte",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child:
                                    SvgPicture.asset("assets/icons/barba.svg"),
                              ),
                              Spacer(),
                              Text(
                                "Barba",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 40.0),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child:
                                    SvgPicture.asset("assets/icons/corte.svg"),
                              ),
                              Spacer(),
                              Text(
                                "Barba & Corte",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 40.0),
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child:
                                    SvgPicture.asset("assets/icons/corte.svg"),
                              ),
                              Spacer(),
                              Text(
                                "Hidratação",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), 
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}
