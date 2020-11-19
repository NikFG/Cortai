import 'dart:convert';
import 'dart:math';

import 'package:cortai/Dados/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

/*
* Classe modelo para ScopedModel.
* Gravar as sessões e os dados de login para serem usados em qualquer parte do código.
* */
class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String url = "http://192.168.0.108:8000/api/";
  static User _firebaseUser;

  // static FirebaseUser _firebaseUser;

  bool isCarregando = false;
  Login dados;
  String token = "";

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
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    notifyListeners();
    var dio = Dio();

    try {
      FormData formData = new FormData.fromMap(login.toMap());
      var response = await dio.post(url + "auth/user/create", data: formData);
      if (response.statusCode == 200)
        onSuccess();
      else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  //Login no firebase via email/senha
  void logarEmail(
      {@required String email,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required VoidCallback onVerifyEmail}) async {
    print(email);
    print(senha);
    isCarregando = true;
    notifyListeners();
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap({"email": email, "password": senha});
      var response = await dio.post(url + "auth/login", data: formData);
      print(response.statusMessage);
      print(response.data);

      isCarregando = false;
      notifyListeners();
      _carregarUsuarioNew(response.data['user'], response.data['access_token']);
      onSuccess();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  void logarEmailOld(
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
      if (user.user.emailVerified) {
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
  Future<Null> logarGoogle(VoidCallback onSucess, VoidCallback onFail) async {
    isCarregando = true;
    try {
      notifyListeners();
      GoogleSignInAccount googleUser =
          await _googleSignIn.signIn().catchError((e) => null);
      if (googleUser == null) {
        isCarregando = false;
        throw Exception("Erro ao logar");
      }
      GoogleSignInAuthentication googleAuth =
          await googleUser.authentication.catchError((e) {
        return null;
      });

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential).then((_) async {
        await _getUID();
        await _salvarDadosUsuarioGoogle();
        notifyListeners();
        isCarregando = false;
        onSucess();
      }).catchError((e) {
        isCarregando = false;
        notifyListeners();
        onFail();
      });
    } catch (e) {
      isCarregando = false;
      print(e);
      onFail();
    }
  }

  Future<Null> _salvarDadosUsuarioGoogle() async {
    if (await _carregarUsuario() == false) {
      this.dados = Login(
          id: _firebaseUser.uid as int,
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
    notifyListeners();
  }

  Future<Null> logout() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    dados = null;
    _firebaseUser = null;
    notifyListeners();
  }

  _carregarUsuarioNew(Map<String, dynamic> login, String token) {
    this.token = token;
    dados = Login.fromJson(login);
  }

  /*Carregar os dados do firebase caso o usuário esteja logando no sistema,
  * ou então necessite dos dados para atulizar alguma informação
  */
  //ignore: missing_return
  Future<bool> _carregarUsuario() async {
    bool result;
    if (_firebaseUser == null) {
      _firebaseUser = _auth.currentUser;
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
    return token.isNotEmpty;
  }

  Future<dynamic> _getUID() {
    _firebaseUser = _auth.currentUser;
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
