import 'package:agendacabelo/Tiles/home_tab.dart';
import 'package:agendacabelo/Telas/gerenciar_salao_tela.dart';
import 'package:agendacabelo/Util/push_notification.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'marcado_tela.dart';
import 'criar_servico_tela.dart';
import 'confirmar_tela.dart';

class HomeTela extends StatelessWidget {
  final String usuario_id;
  final int paginaInicial;

  HomeTela({ this.usuario_id, this.paginaInicial});

  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(initialPage: paginaInicial == null ? 0 : paginaInicial);
    if (usuario_id != null) PushNotification.servico(usuario_id, context);
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
          body: MarcadoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Horários marcados"),
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

            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: FlatButton(
                      onPressed: () async {
                        var snapshots = await Firestore.instance
                            .collection('servicos')
                            .getDocuments();

                        for (int i = 0; i < snapshots.documents.length; i++) {
                          Firestore.instance
                              .collection('servicos')
                              .document(snapshots.documents[i].documentID)
                              .updateData({
                            "confirmado": true,
                          });
                        }
                      },
                      child: Text("Confirmar todos"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text("Cancelar todos"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: CriarServicoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Cadastrar serviços"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          drawer: DrawerCustom(_pageController),
          body: GerenciarSalaoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Gerenciar salão"),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}
