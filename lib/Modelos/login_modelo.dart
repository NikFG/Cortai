import 'package:cortai/Dados/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

/*
* Classe modelo para ScopedModel.
* Gravar as sessões e os dados de login para serem usados em qualquer parte do código.
* */
class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser _firebaseUser;

  bool isCarregando = false;
  Login dados;

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregarUsuario();
  }

  //Criar conta com email e senha
  void criarContaEmail(
      {@required Login login,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(email: login.email, password: senha)
        .then((user) async {
      await _getUID();
      login.id = _firebaseUser.uid;
      this.dados = login;
      await _salvarDadosUsuarioEmail();
      await _firebaseUser.sendEmailVerification();
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
  void logarEmail(
      {@required String email,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required VoidCallback onVerifyEmail}) {
    isCarregando = true;
    notifyListeners();

      _auth
          .signInWithEmailAndPassword(email: email, password: senha)
          .then((user) async {
        if (user.user.isEmailVerified) {
          _carregarUsuario();
          isCarregando = false;
          notifyListeners();
          onSuccess();
        } else {
          logout();
          notifyListeners();
          await user.user.sendEmailVerification();
          onVerifyEmail();
          isCarregando = false;
        }
      }).catchError((e) {
        isCarregando = false;
        notifyListeners();
        onFail();
      });
  }

  //Login no firebase via Google
  Future<Null> logarGoogle() async {
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

  Future<Null> _salvarDadosUsuarioGoogle() async {
    isCarregando = true;
    if (await _carregarUsuario() == false) {
      this.dados = Login(
          id: _firebaseUser.uid,
          email: _firebaseUser.email,
          imagemUrl: _firebaseUser.photoUrl,
          nome: _firebaseUser.displayName,
          isCabeleireiro: false,
          isDonoSalao: false,
          salao: null,
          telefone: null);
    } else {
      await _carregarUsuario();
    }
    await Firestore.instance
        .collection("usuarios")
        .document(_firebaseUser.uid)
        .setData(this.dados.toMap(), merge: true);
    notifyListeners();
    isCarregando = false;
  }

  Future<Null> logout() async {
    await _auth.signOut();
    dados = null;
    _firebaseUser = null;
    notifyListeners();
  }

  /*Carregar os dados do firebase caso o usuário esteja logando no sistema,
  * ou então necessite dos dados para atulizar alguma informação
  */
  //ignore: missing_return
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
          dados = Login.fromDocument(doc);
        }
        notifyListeners();
        return result;
      }
    }
  }

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
