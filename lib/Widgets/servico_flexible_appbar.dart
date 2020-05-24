import 'package:flutter/widgets.dart';

class ServicoFlexibleAppBar extends StatelessWidget {
  final double appBarHeight = 66.0;
  final double menorValor;
  final double maiorValor;
  final String distancia;
  final String nomeSalao;

  ServicoFlexibleAppBar(
      {@required this.nomeSalao,
      @required this.menorValor,
      @required this.maiorValor,
      @required this.distancia});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        height: statusBarHeight + appBarHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /* Container(
                      child: Text(
                        "Salao",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xCCFFFFFF),
                          fontFamily: 'Poppins',
                          fontSize: 48,
                        ),
                      ),
                    ),*/
                    Container(
                      child: Text(
                        nomeSalao,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Poppins',
                          fontSize: 36,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                            child: Text(
                              "R\$${menorValor.toStringAsFixed(2).replaceAll('.', ',')} "
                              "~ R\$${maiorValor.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: TextStyle(
                                color: Color(0xB6FFFFFF),
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        // child: Icon(),

                                        ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        "${distancia}KM",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
            ),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment(0.9, 0.0),
            end: Alignment(0.9, 0.9),
            colors: <Color>[
              Color(0x60000000),
              Color(0x00000000),
            ],
          ),
        ));
  }
}
