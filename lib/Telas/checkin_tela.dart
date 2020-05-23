import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class CheckinTela extends StatefulWidget {
  @override
  _CheckinTelaState createState() => _CheckinTelaState();
}

class _CheckinTelaState extends State<CheckinTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkin do cliente nomeLegal"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("O valor foi x e será pago via bufunfa virtual :D"),
          SizedBox(
            height: 44,
            width: 250,
            child: SliderButton(
              dismissible: false,
              shimmer: false,
              action: () {

                Navigator.of(context).pop();
              },
              label: Text(
                "Confirmar",
                style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              icon: Container(
                width: 0,
                height: 0,
              ),
              highlightedColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
