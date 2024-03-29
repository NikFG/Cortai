import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/calendario_tela.dart';
import 'package:cortai/Telas/editar_salao_tela.dart';
import 'package:cortai/Telas/perfil_tela.dart';
import 'package:cortai/Util/onesignal_service.dart';
import 'package:cortai/Widgets/bottom_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'agendado_tela.dart';
import 'confirmar_tela.dart';
import 'home_tela.dart';

class IndexTela extends StatefulWidget {
  final int paginaInicial;

  IndexTela({this.paginaInicial = 0});

  @override
  _IndexTelaState createState() => _IndexTelaState();
}

class _IndexTelaState extends State<IndexTela> {
  late int index;
  late OneSignalService oss;

  @override
  void initState() {
    super.initState();
    oss = OneSignalService.init();
    index = widget.paginaInicial;
  }

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: index);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null) {
          oss.gravaIdExterna(model.dados!.isCabeleireiro,
              model.dados!.isDonoSalao, model.dados!.id!);

          if (model.dados!.isDonoSalao && model.dados!.salaoId == null) {
            return EditarSalaoTela();
          }

          return Scaffold(
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados!.isCabeleireiro, model.dados!.id!, model.token),
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 20),
                    child: HomeTela(),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Scaffold(
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
                          indicatorColor: Theme
                              .of(context)
                              .primaryColor,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                "Em andamento",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                                child: Text(
                                  "Finalizados",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        ),
                        title: Text(
                          "Agenda",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        centerTitle: true,
                        actions: <Widget>[
                          PopupMenuButton(
                            icon: Icon(FontAwesome.ellipsis),
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                value: 1,
                                child: TextButton(
                                  onPressed: () async {
                                    // var snapshots =
                                    //     await ServicoControle.get().getDocuments();
                                    //
                                    // for (int i = 0;
                                    //     i < snapshots.documents.length;
                                    //     i++) {
                                    //   ServicoControle.get()
                                    //       .document(
                                    //           snapshots.documents[i].documentID)
                                    //       .updateData({
                                    //     "confirmado": true,
                                    //   });
                                    // }
                                  },
                                  child: Text("Confirmar todos"),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: TextButton(
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
                  model.dados!.isCabeleireiro
                      ? DefaultTabController(
                    length: 2,
                    child: Scaffold(
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
                          indicatorColor: Theme
                              .of(context)
                              .primaryColor,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                "A confirmar",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Tab(
                                child: Text(
                                  "Confirmados",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                        ),
                        title: Text(
                          "Confirmar horários",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        centerTitle: true,
                        actions: <Widget>[
                          PopupMenuButton(
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                value: 1,
                                child: TextButton(
                                  onPressed: () async {
                                    //TODO: Confirmar todos de uma vez
                                    // var snapshots =
                                    //     await ServicoControle.get().getDocuments();
                                    //
                                    // for (int i = 0;
                                    //     i < snapshots.documents.length;
                                    //     i++) {
                                    //   ServicoControle.get()
                                    //       .document(
                                    //           snapshots.documents[i].documentID)
                                    //       .updateData({
                                    //     "confirmado": true,
                                    //   });
                                    // }
                                  },
                                  child: Text("Confirmar todos"),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text("Cancelar todos"),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                      : PerfilTela(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 20),
                    child: CalendarioTela(),
                  ),
                  PerfilTela(),
                ],
              ));
        } else {
          model.listeners();
          return Center();
        }
      },
    );
  }
}
