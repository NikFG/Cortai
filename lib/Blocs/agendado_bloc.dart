import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';

class AgendadoBloc extends BlocBase {
  Map<String, dynamic> map = {};
  final _agendadoController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get outAgendado => _agendadoController.stream;
  final _urlController = StreamController<String>();
  AgendadoBloc() {

  }


  @override
  void dispose() {
    super.dispose();
    _agendadoController.close();
    _urlController.close();
  }
}
