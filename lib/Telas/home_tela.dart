import 'package:agendacabelo/Tabs/home_tab.dart';
import 'package:agendacabelo/Telas/criar_horario_tela.dart';
import 'package:agendacabelo/Telas/salao_tela.dart';
import 'package:agendacabelo/Util/push_notification.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'servico_tela.dart';
import 'confirmar_tela.dart';

class HomeTela extends StatelessWidget {
  final String usuario_id;

  HomeTela({this.usuario_id});

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: 0);
    PushNotification push = PushNotification();
    if (usuario_id != null) push.servico(usuario_id, context);
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
          drawer: DrawerCustom(_pageController),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: SalaoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Escolha seu salão"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: ConfirmarTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Confirmar horários"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: ServicoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Cadastrar serviços"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: SalaoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Salão"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: CriarHorarioTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Criar horário"),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}
