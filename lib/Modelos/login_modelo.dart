import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser firebaseUser;
  Map<String, dynamic> usuarioData = Map();

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregarUsuario();
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    await _currentUserUID();
    await _salvarDadosUsuario();
    await _carregarUsuario();
    return user;
  }

  Future<Null> _salvarDadosUsuario() async {
    this.usuarioData = {
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'fotoURL': firebaseUser.photoUrl,
      'nome': firebaseUser.displayName,
      'vistoPorUltimo': DateTime.now(),
      'cabelereiro': isCabelereiro(),
    };
    await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        .setData(usuarioData, merge: true);
  }

  void signOut() async {
    await _auth.signOut();
    usuarioData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _carregarUsuario() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (usuarioData["nome"] == null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("usuarios")
            .document(firebaseUser.uid)
            .get();
        usuarioData = doc.data;
        notifyListeners();
      }
    }
  }

  bool isCabelereiro() {
    if (isLogado()) {
      _carregarUsuario();
      bool result = usuarioData['cabelereiro'];
      return result;
    }
    return false;
  }

  bool isLogado() {

    return firebaseUser != null;
  }

  Future<dynamic> _currentUserUID() async {
    firebaseUser = await _auth.currentUser();
  }
  String getSalao(){
    _carregarUsuario();
    String salao = usuarioData['salao'];
    return salao;
  }

  //TODO
  bool isDonoSalao() {}
}
