import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/ficha_api.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/data_source/remote/reservas_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/repositories_implementation/fichas_repository_implementation.dart';
import 'package:frontend/src/data/repositories_implementation/pacientes_repository_impl.dart';
import 'package:frontend/src/data/repositories_implementation/reservas_repository_impl.dart';
import 'package:frontend/src/domain/models/Ficha.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/ficha_repository.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';
import 'package:frontend/src/domain/repositories/reservas_repository.dart';
import 'package:frontend/src/pages/ficha_clinica_items.dart';
import 'package:frontend/src/pages/item_ficha_page.dart';
import 'package:frontend/src/pages/registrar_ficha_page.dart';
import 'package:frontend/src/utils/backdrop_widget.dart';

class FichaPage extends StatefulWidget {
  static String id = 'fica_page';
  const FichaPage({super.key});

  @override
  State<FichaPage> createState() => _FichaPageState();
}

class _FichaPageState extends State<FichaPage> {
  bool isLoading = true;

  PacientesRepository? pacientesRest;
  ReservaRepository? reservasRest;
  FichaRepository? fichasRest;

  List<Paciente> pacientes = [];
  List<Paciente> fisios = [];
  List<Ficha> fichas = [];

  @override
  void initState() {
    super.initState();
    final http = Http();

    pacientesRest = PacientesRepositoryImpl(
      PacientesApi(
        http,
      ),
    );

    reservasRest = ReservasRepositoryImpl(
      ReservasApi(
        http,
      ),
    );

    fichasRest = FichasRepositoryImpl(FichasApi(http));

    pacientesRest!.obtenerFisioterapeutas().then((value) {
      setState(() {
        fisios = value;
      });
    });

    pacientesRest!.obtenerPacientes().then(
      (value) {
        setState(
          () {
            pacientes = value;
          },
        );
      },
    );

    fichasRest!.obternerFichasIncial().then(
      (value) {
        setState(() {
          fichas = value;
          isLoading = false;
        });
      },
    );
  }

  void onFilterChange(int idFisio, int idCliente, String desde, String hasta) {
    setState(
      () {
        isLoading = true;
        fichasRest!.obternerFichasIncial().then(
          (value) {
            setState(() {
              fichas = value;
              isLoading = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Backdrop Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: BackdropWidget(
                frontLayer: ItemsFichaPage(
                  fichas: fichas,
                ),
                frontTitle: const Text("Fichas"),
                backLayer: ItemsFichaFilters(
                  pacientes: pacientes,
                  fisios: fisios,
                  onFilterChange: onFilterChange,
                ),
                backTitle: const Text("Filtrar"),
              ),
              floatingActionButton: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrarFichaPage.id);
                },
                child: const Text('Add'),
              ),
            ),
    );
  }
}
