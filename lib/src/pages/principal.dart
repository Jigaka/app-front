import 'package:flutter/material.dart';
import 'package:frontend/src/pages/ficha_clinica_page.dart';
import 'package:frontend/src/pages/pacientes_page.dart';
import 'package:frontend/src/pages/reservas_page.dart';

class PrincipalPage extends StatelessWidget {
  static String id = 'principal_page';
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinica"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _botonesGrandes(
            context,
            "Administracion de pacientes",
            () => Navigator.pushNamed(
              context,
              PacientesPage.id,
            ),
          ),
          _botonesGrandes(
            context,
            "Reserva de turnos",
            () => Navigator.pushNamed(
              context,
              RerservasPage.id,
            ),
          ),
          _botonesGrandes(
            context,
            "Ficha clinica",
            () => Navigator.pushNamed(
              context,
              FichaPage.id,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonesGrandes(BuildContext context, String title, Function funcion) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        child: Container(
          constraints: BoxConstraints.expand(
            height:
                Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 200.0,
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Center(
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white)),
          ),
        ),
        onTap: () => funcion(),
      ),
    );
  }
}
