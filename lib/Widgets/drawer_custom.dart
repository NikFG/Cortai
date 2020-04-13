import 'package:agendacabelo/Telas/cabelereiros_tela.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:agendacabelo/login_service.dart';
import '../Tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDegrade(context),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "App hair",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                           "Olá Pessoa!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            child: Text(
                              "Entre ou cadastre",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginTela()));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(FontAwesome.cut, "Cabelereiros", pageController, 1),
              DrawerTile(FontAwesome.calendar_times_o, "Confirmar horários", pageController, 2),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDegrade(BuildContext context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
           Theme.of(context).primaryColor,

            Colors.grey[50]
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      );
}
