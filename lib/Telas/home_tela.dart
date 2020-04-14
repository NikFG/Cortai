import 'package:agendacabelo/Tabs/home_tab.dart';
import 'package:agendacabelo/Telas/cabelereiros_tela.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:flutter/material.dart';

import 'confirmar_tela.dart';

class HomeTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: 0);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: CabelereirosTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Cabelereiros"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: ConfirmarTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Confirmar horários"),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}
