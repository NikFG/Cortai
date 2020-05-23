import 'package:flutter/material.dart';


class FixedAppBar extends StatelessWidget {

  final double barHeight = 100.0;

  const FixedAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(child: Padding(
            padding: const EdgeInsets.only(left:60.0, top:10, bottom: 10),
            child: Text(
              'Nome do Salao',
              style: TextStyle(
                color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  height: -10,
              ),
            ),

          ),),


        ],
      ),
    );
  }
}