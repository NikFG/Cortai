import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
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
                        child: ScopedModelDescendant<LoginModelo>(
                          builder: (context, child, model) {
                            if (model.dados == null) {
                              return CircularProgressIndicator();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Olá, ${!model.isLogado() ? "" : model.dados['nome']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "${!model.isLogado() ? "Entre ou cadastre-se >" : "Sair"}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onTap: () {
                                    if (model.isLogado()) {
                                      model.logOut();
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginTela()));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ))
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(FontAwesome.cut, "Cabelereiros", pageController, 1),
              ScopedModelDescendant<LoginModelo>(
                  builder: (context, child, model) {
                if (model.isCabelereiro())
                  return _cabelereiroTiles();
                else
                  return Container(
                    width: 0,
                    height: 0,
                  );
              }),
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
            Colors.grey[50],
            Theme.of(context).primaryColorLight,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      );

  Widget _cabelereiroTiles() {
    List<Widget> list = new List<Widget>();
    list.add(DrawerTile(
        FontAwesome.calendar_times_o, "Confirmar horários", pageController, 2));
    list.add(DrawerTile(Icons.work, "Cadastrar serviço", pageController, 3));
    list.add(DrawerTile(FontAwesome.circle, "Salão", pageController, 4));
    list.add(DrawerTile(Icons.add, "Criar horário", pageController, 5));
    return Column(
      children: list,
    );
  }
}
