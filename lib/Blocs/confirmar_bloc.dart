import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortai/Controle/horario_controle.dart';

class ConfirmarBloc extends BlocBase {
  int cont;
  String uid;
  Stream<QuerySnapshot> _confirmarController() {
    return HorarioControle.get()
        .where('confirmado', isEqualTo: false)
        .where('cabeleireiro', isEqualTo: uid)
        .snapshots();
  }
ConfirmarBloc(){
    _confirmarController();
}
  @override
  void dispose() {
    super.dispose();
    
  }
}
