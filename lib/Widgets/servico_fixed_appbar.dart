import 'package:flutter/material.dart';

class FixedAppBar extends StatelessWidget {
  final double barHeight = 100.0;
  final String nome;

  const FixedAppBar(this.nome);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0, top: 10, bottom: 10),
              child: Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
