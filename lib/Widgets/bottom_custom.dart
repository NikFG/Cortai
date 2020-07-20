import 'package:agendacabelo/Controle/horario_controle.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomCustom extends StatefulWidget {
  final PageController pageController;
  final int index;
  final bool isCabeleireiro;
  final String usuario;

  BottomCustom(
      this.pageController, this.index, this.isCabeleireiro, this.usuario);

  @override
  _BottomCustomState createState() => _BottomCustomState();
}

class _BottomCustomState extends State<BottomCustom> {
  List<BottomNavigationBarItem> itens = [];

  @override
  void initState() {
    super.initState();
    itensUsuario();
    if (widget.isCabeleireiro) {
      itensCabeleireiro(widget.usuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.index,
        onTap: (index) {
          _bottomTapped(index);
        },
        items: itens);
  }

  void _bottomTapped(int index) {
    setState(() {
      widget.pageController.jumpToPage(index);
    });
  }

  TextStyle stylePadrao() {
    return TextStyle(fontSize: 12);
  }

  itensUsuario() {
    var itens = [
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.home),
        title: Text(
          "Início",
          style: stylePadrao(),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.calendar_o),
        title: Text(
          "Agendados",
          style: stylePadrao(),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.user_circle_o),
        title: Text(
          "Perfil",
          style: stylePadrao(),
        ),
      ),
    ];
    this.itens.addAll(itens);
  }

  itensCabeleireiro(String uid) {
    var itens = [
      BottomNavigationBarItem(
        icon: StreamBuilder<QuerySnapshot>(
            stream: HorarioControle.get()
                .where('confirmado', isEqualTo: false)
                .where('cabeleireiro', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Icon(FontAwesome5.calendar_check);
                default:
                  int _numeroConfirmacoes = snapshot.data.documents.length;
                  return Badge(
                    badgeColor: Theme.of(context).primaryColor,
                    showBadge: _numeroConfirmacoes != 0 ? true : false,
                    animationType: BadgeAnimationType.scale,
                    position: BadgePosition(left: 19, bottom: 8),
                    badgeContent: Text(
                      _numeroConfirmacoes.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(FontAwesome5.calendar_check),
                  );
              }
            }),
        title: Text(
          "Confirmar",
          style: stylePadrao(),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.scissors),
        title: Text(
          "Serviços",
          style: stylePadrao(),
        ),
      ),
    ];
    this.itens.addAll(itens);
  }
}
