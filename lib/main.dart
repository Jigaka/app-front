import 'package:flutter/material.dart';
import 'package:frontend/src/pages/login_page.dart';
import 'package:frontend/src/pages/pacientes_page.dart';
import 'package:frontend/src/pages/principal.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var estaLogueado = prefs.getString("login") ?? 'no';
  runApp(MyApp(estaLogueado));
}

class MyApp extends StatelessWidget {
  final String estaLogueado;
  const MyApp(this.estaLogueado, {super.key});

  @override
  Widget build(BuildContext context) {
    String initialRoute =
        estaLogueado == 'yes' ? PrincipalPage.id : LoginPage.id;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App frontend',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: initialRoute,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        PrincipalPage.id: (context) => PrincipalPage(),
        PacientesPage.id: (context) => PacientesPage(),
      },
    );
  }
}
