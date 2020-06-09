import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomCustom extends StatefulWidget {
  final PageController pageController;
  final int index;

  BottomCustom(this.pageController, this.index);

  @override
  _BottomCustomState createState() => _BottomCustomState();
}

class _BottomCustomState extends State<BottomCustom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      onTap: (index) {
        _bottomTapped(index);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Início"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          title: Text("Marcados"),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome5.calendar_check),
          title: Text("Confirmar"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_cut),
          title: Text("Serviços"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          title: Text("Salão"),
        ),
      ],
    );
  }

  void _bottomTapped(int index) {
    setState(() {
      widget.pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
