import 'package:cloud_firestore/cloud_firestore.dart';

class CabeleireiroControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('usuarios');
  }

/*static void store(CabeleireiroDados dados, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
        .document(salao)
        .collection('funcionamento')
        .add(dados.toMap())
        .then((value) {
      print(value);
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }

  static void update(CabeleireiroDados dados, String salao,
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    await _firestore
        .collection('saloes')
        .document(salao)
        .collection('funcionamento')
        .document(dados.diaSemana)
        .updateData(dados.toMap())
        .then((value) {
      onSuccess();
    }).catchError((e) {
      print(e);
      onFail();
    });
  }*/
}
