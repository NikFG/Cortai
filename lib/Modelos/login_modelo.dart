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
  bool isCarregando = false;

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregarUsuario();
  }

  //Criar conta com email e senha
  void signUp(
      {@required Map<String, dynamic> usuarioData, @required String senha}) {
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: usuarioData["email"], password: senha)
        .then((user) async {
      await _getUID();
      usuarioData['uid'] = firebaseUser.uid;
      this.dados = usuarioData;
      await _salvarDadosUsuarioEmail();
      notifyListeners();
    }).catchError((e) async {
      print(e);
      isCarregando = false;
      notifyListeners();
    });
  }

  Future<Null> _salvarDadosUsuarioEmail() async {
    await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        .setData(this.dados);
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
    if (await _carregarUsuario() == false) {
      this.dados = {
        'uid': firebaseUser.uid,
        'email': firebaseUser.email,
        'fotoURL': firebaseUser.photoUrl,
        'nome': firebaseUser.displayName,
        'vistoPorUltimo': DateTime.now(),
        'cabeleireiro': false,
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

  //Carregar os dados do firebase caso o usuário esteja logando no sistema,
  // ou então necessite dos dados para atulizar alguma informação
  // ignore: missing_return
  Future<bool> _carregarUsuario() async {
    bool result;
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
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

  bool isCabeleireiro() {
    if (isLogado()) {
      bool result = dados['cabeleireiro'];
      return result;
    }
    return false;
  }

  //verifica se o usuário está ou não logado no sistema
  bool isLogado() {
    return firebaseUser != null;
  }

  Future<dynamic> _getUID() async {
    firebaseUser = await _auth.currentUser();
  }

  String getSalao() {
    String salao = dados['salao'];
    return salao;
  }

  void recuperarSenha(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}
