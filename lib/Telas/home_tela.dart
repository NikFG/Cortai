import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tabs/home_tab.dart';
import 'package:agendacabelo/Telas/cabelereiros_tela.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'servico_tela.dart';
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
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: ServicoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Cadastrar serviços"),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}
