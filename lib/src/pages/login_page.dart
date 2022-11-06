import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/authentication_api.dart';
import 'package:frontend/src/data/helpers/authentication_repository_implementation.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/domain/repositories/authentication_repository.dart';
import 'package:frontend/src/domain/responses/login_response.dart';
import 'package:frontend/src/pages/principal.dart';
import 'package:frontend/src/utils/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationRepository? auth;
  @override
  void initState() {
    super.initState();
    final http = Http();

    auth = AuthenticationRepositoryImpl(
      AuthenticacionAPI(http),
    );
  }

  String username = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                'assets/img/apepu256.png',
                height: 400,
              ),
            ),
            Text(
              "Apepu",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.0,
            ),
            _userTextField(),
            SizedBox(
              height: 20.0,
            ),
            _bottonLogin()
          ],
        ),
      )),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 0, 60, 0),
        child: TextField(
          decoration: InputDecoration(
              icon: Icon(Icons.verified_user),
              hintText: 'usuario login',
              labelText: 'Username'),
          onChanged: (text) {
            username = text;
          },
        ),
      );
    });
  }

  Widget _bottonLogin() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text(
              "Iniciar sesion",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () {
            _login(context);
          });
    });
  }

  Future<void> _login(BuildContext context) async {
    ProgressDialog.show(context);
    LoginResponse ok = await auth!.login(username);
    ProgressDialog.dissmiss(context);
    if (LoginResponse.ok == ok) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('login', 'yes');

      Navigator.pushNamedAndRemoveUntil(
        context,
        PrincipalPage.id,
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("usuario invalido"),
        ),
      );
    }
  }
}
