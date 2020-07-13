import 'package:agendacabelo/Dados/login_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser _firebaseUser;

//  Map<String, dynamic> dados = Map();
  bool isCarregando = false;
  LoginDados dados;

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregarUsuario();
  }

  //Criar conta com email e senha
  void signUp(
      {@required LoginDados loginDados,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: loginDados.email, password: senha)
        .then((user) async {
      await _getUID();
      loginDados.id = _firebaseUser.uid;
      this.dados = loginDados;
      await _salvarDadosUsuarioEmail();
      notifyListeners();
      onSuccess();
    }).catchError((e) async {
      print(e);
      isCarregando = false;
      notifyListeners();
      onFail();
    });
  }

  Future<Null> _salvarDadosUsuarioEmail() async {
    await Firestore.instance
        .collection("usuarios")
        .document(_firebaseUser.uid)
        .setData(dados.toMap());
  }

  //Login no firebase via email/senha
  void emailSignIn(
      {@required String email,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isCarregando = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((user) async {
      _carregarUsuario();
      isCarregando = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      isCarregando = false;
      notifyListeners();
      onFail();
    });
  }

  //Login no firebase via Google
  Future<Null> googleSignIn() async {
    notifyListeners();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential).then((_) async {
      await _getUID();
      await _salvarDadosUsuarioGoogle();
      notifyListeners();
    }).catchError((e) {
      isCarregando = false;
      notifyListeners();
    });
  }

  //Dados salvos do usuário
  Future<Null> _salvarDadosUsuarioGoogle() async {
    Map<String, dynamic> dados = Map();
    if (await _carregarUsuario() == false) {
      dados = {
        'uid': _firebaseUser.uid,
        'email': _firebaseUser.email,
        'fotoURL': _firebaseUser.photoUrl,
        'nome': _firebaseUser.displayName,
        'vistoPorUltimo': DateTime.now(),
        'cabeleireiro': false,
      };
      this.dados = LoginDados.fromMap(dados);
    } else {
      await _carregarUsuario();
      dados['vistoPorUltimo'] = DateTime.now();
    }
    await Firestore.instance
        .collection("usuarios")
        .document(_firebaseUser.uid)
        .setData(dados, merge: true);
    notifyListeners();
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    dados = null;
    _firebaseUser = null;
    notifyListeners();
  }

  //Carregar os dados do firebase caso o usuário esteja logando no sistema,
  // ou então necessite dos dados para atulizar alguma informação
  // ignore: missing_return
  Future<bool> _carregarUsuario() async {
    bool result;
    if (_firebaseUser == null) {
      _firebaseUser = await _auth.currentUser();
    }
    if (_firebaseUser != null) {
      if (dados == null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("usuarios")
            .document(_firebaseUser.uid)
            .get();
        if (doc.data == null) {
          result = false;
        } else {
          result = true;
          dados = LoginDados.fromMap(doc.data);
        }
        notifyListeners();
        return result;
      }
    }
  }

  //verifica se o usuário está ou não logado no sistema
  bool isLogado() {
    return _firebaseUser != null;
  }

  Future<dynamic> _getUID() async {
    _firebaseUser = await _auth.currentUser();
  }

  recuperarSenha(String email) async {
    return await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => true)
        .catchError((e) {
      print(e);
      return false;
    });
  }
}
