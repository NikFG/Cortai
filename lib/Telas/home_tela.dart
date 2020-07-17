import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:agendacabelo/Tiles/home_tab.dart';
import 'package:agendacabelo/Telas/perfil_tela.dart';
import 'package:agendacabelo/Util/push_notification.dart';
import 'package:agendacabelo/Widgets/bottom_custom.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'gerenciar_servico_tela.dart';
import 'agendado_tela.dart';
import 'confirmar_tela.dart';

class HomeTela extends StatefulWidget {
  final int paginaInicial;

  HomeTela({this.paginaInicial});

  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.paginaInicial != null) {
      index = widget.paginaInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: index);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados.isDonoSalao && model.dados.salao == null) {
          return EditarSalaoTela(model.dados.id);
        }
        PushNotification.servico(model.dados.id, context);
        return PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              this.index = index;
            });
          },
          children: <Widget>[
            Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20),
                child: HomeTab(),
              ),
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
            ),
            DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomNavigationBar: BottomCustom(_pageController, index,
                    model.dados.isCabeleireiro, model.dados.id),
                body: AgendadoTela(),
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: Container(
                    width: 0,
                    height: 0,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "Em andamento",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Poppins'),
                        ),
                      ),
                      Tab(
                          child: Text(
                        "Finalizados",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ))
                    ],
                  ),
                  title: Text(
                    "Agendados",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: FlatButton(
                            onPressed: () async {
                              var snapshots =
                                  await ServicoControle.get().getDocuments();

                              for (int i = 0;
                                  i < snapshots.documents.length;
                                  i++) {
                                ServicoControle.get()
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
            ),
            Scaffold(
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
              body: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                child: PerfilTela(),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomNavigationBar: BottomCustom(_pageController, index,
                    model.dados.isCabeleireiro, model.dados.id),
                body: ConfirmarTela(),
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: Container(
                    width: 0,
                    height: 0,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "A confirmar",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Poppins'),
                        ),
                      ),
                      Tab(
                          child: Text(
                        "Confirmados",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ))
                    ],
                  ),
                  title: Text(
                    "Confirmar horários",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: FlatButton(
                            onPressed: () async {
                              var snapshots =
                                  await ServicoControle.get().getDocuments();

                              for (int i = 0;
                                  i < snapshots.documents.length;
                                  i++) {
                                ServicoControle.get()
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
            ),
            Scaffold(
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
              body: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20),
                child: GerenciarServicoTela(),
              ),
            ),
          ],
        );
      },
    );
  }
}
