import 'package:agendacabelo/Tabs/home_tab.dart';
import 'package:agendacabelo/Telas/cabelereiros_tela.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:flutter/material.dart';

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
            centerTitle: true,
          ),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: CabelereirosTela(),
          backgroundColor: Colors.blue,
          appBar: AppBar(
            title: Text("Cabelereiros"),
            centerTitle: true,
          ),
        )
      ],
    );
  }
}
