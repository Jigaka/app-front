import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/reservas_api.dart';
import 'package:frontend/src/data/repositories_implementation/reservas_repository_impl.dart';
import 'package:frontend/src/domain/repositories/reservas_repository.dart';
import 'package:frontend/src/domain/responses/reserva_response.dart';
import 'package:frontend/src/utils/backdrop_widget.dart';
import 'package:frontend/src/utils/items_page.dart';
import 'package:frontend/src/utils/items_filters.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/repositories_implementation/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/models/Reserva.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';

class RerservasPage extends StatefulWidget {
  static String id = 'reservas_page';

  const RerservasPage({super.key});

  @override
  State<RerservasPage> createState() => _RerservasPageState();
}

class _RerservasPageState extends State<RerservasPage> {
  String filter = "none";
  List<Reserva> reservas = [];
  List<Paciente> pacientes = [];
  List<Paciente> fisios = [];
  PacientesRepository? pacientesRest;
  ReservaRepository? reservasRest;
  bool isLoading = true;
  TextEditingController myTextController = TextEditingController();

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

    reservasRest!.obternerReservasIncial().then(
      (value) {
        setState(
          () {
            reservas = value;
            reservas.sort();
            isLoading = false;
          },
        );
      },
    );
  }

  void onCancelReserva(context, idReserva, reserva, pos) {
    reservasRest!.cancelarReserva(idReserva).then((value) {
      if (value == ReservaResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reserva cancelada exitosamente"),
          ),
        );
      }
      if (value == ReservaResponse.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo cancelar la reserva"),
          ),
        );
        reservas.add(reserva);
        reservas.sort();
        setState(() {});
      }
    });
  }

  List<String> onEditReserva(context, idReserva, reserva, pos, obs, asistio) {
    bool flagAsistio = asistio == 'S';
    bool enviar = false;
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          myTextController.text = obs;
          return AlertDialog(
            title: const Text('Editar reserva'),
            content: Column(
              children: [
                TextFormField(
                  controller: myTextController,
                  decoration: const InputDecoration(
                    hintText: 'ingrese su observacion',
                    labelText: 'Observacion',
                  ),
                ),
                const Text('Asistio?'),
                Checkbox(
                  value: flagAsistio,
                  onChanged: (value) {
                    if (!flagAsistio) {
                      setState(() {
                        asistio = 'S';
                      });
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  enviar = true;
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
    return enviar
        ? [myTextController.text, flagAsistio ? 'S' : 'N']
        : ["m", 'm'];
  }

  void onFilterChange(int idFisio, int idCliente, String desde, String hasta) {
    setState(
      () {
        isLoading = true;
        reservasRest!
            .obternerReservasFiltros(idCliente, idFisio, desde, hasta)
            .then(
          (value) {
            setState(
              () {
                reservas = value;
                isLoading = false;
              },
            );
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
          : BackdropWidget(
              frontLayer: ItemsPage(
                filter: filter,
                reservas: reservas,
                cancelReserva: onCancelReserva,
                editReserva: onEditReserva,
              ),
              frontTitle: const Text("Reservas"),
              backLayer: ItemsFilters(
                pacientes: pacientes,
                fisios: fisios,
                onFilterChange: onFilterChange,
              ),
              backTitle: const Text("Filtrar"),
            ),
    );
  }
}
