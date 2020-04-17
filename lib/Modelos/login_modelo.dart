import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser firebaseUser;
  Map<String, dynamic> dados = Map();

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

    return user;
  }

  Future<Null> _salvarDadosUsuario() async {
    if (await _carregarUsuario() == false) {
      this.dados = {
        'uid': firebaseUser.uid,
        'email': firebaseUser.email,
        'fotoURL': firebaseUser.photoUrl,
        'nome': firebaseUser.displayName,
        'vistoPorUltimo': DateTime.now(),
        'cabelereiro': false,
      };
    } else {
      await _carregarUsuario();
      this.dados['vistoPorUltimo'] = DateTime.now();
    }
    await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        .setData(dados, merge: true);
    notifyListeners();
  }

  void logOut() async {
    await _auth.signOut();
    dados = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<bool> _carregarUsuario() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      bool result;
      if (this.dados["nome"] == null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("usuarios")
            .document(firebaseUser.uid)
            .get();
        if (doc.data == null) {
          result = false;
        } else {
          result = true;
          dados = doc.data;
        }
        notifyListeners();
        return result;
      }
    }
  }

  bool isCabelereiro() {
    if (isLogado()) {
      bool result = dados['cabelereiro'];
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

  String getSalao() {
    String salao = dados['salao'];
    return salao;
  }
}
