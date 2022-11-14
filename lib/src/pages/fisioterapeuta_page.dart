import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/repositories_implementation/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';

class FisioterapeutaPage extends StatefulWidget {
  static String id = 'fisioterapeuta_page';

  const FisioterapeutaPage({super.key});

  @override
  State<FisioterapeutaPage> createState() => _FisioterapeutaState();
}

class _FisioterapeutaState extends State<FisioterapeutaPage> {
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

    pacientesRest!.obtenerFisioterapeutas().then(
      (value) {
        setState(
          () {
            pacientes = value;
            isLoading = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fisioterapeutas',
        ),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(
      children: [
        Expanded(
          child: pacientes.isEmpty
              ? const Center(
                  child: Text(
                    "Sin datos",
                  ),
                )
              : ListView.builder(
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
    );
  }
}
