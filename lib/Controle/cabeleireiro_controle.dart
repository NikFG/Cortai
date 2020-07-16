import 'package:cloud_firestore/cloud_firestore.dart';

class CabeleireiroControle {
  static Firestore _firestore = Firestore.instance;

  static CollectionReference get() {
    return _firestore.collection('usuarios');
  }
}
