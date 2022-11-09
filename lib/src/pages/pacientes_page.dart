import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';
import 'package:frontend/src/utils/dialog.dart';

class PacientesPage extends StatefulWidget {
  static String id = 'pacientes_page';

  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesState();
}

class _PacientesState extends State<PacientesPage> {
  List<Paciente> pacientes = [];
  bool isLoading = true;

  PacientesRepository? pacientesRest;
  @override
  void initState() {
    super.initState();
    final http = Http();

    pacientesRest = PacientesRepositoryImpl(
      PacientesApi(http),
    );

    pacientesRest!.obtenerPacientes().then((value) {
      setState(() {
        pacientes = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Administracion de pacientes'),
        ),
        body: Stack(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pacientes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue, width: 1),
                      ),
                    ),
                    child: ListTile(
                      trailing: const Icon(Icons.person),
                      title: Text(
                          '${pacientes[index].nombre} ${pacientes[index].apellido ?? ""}'),
                    ),
                  );
                },
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ));
  }
}
