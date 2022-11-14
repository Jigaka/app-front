import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/repositories_implementation/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';
import 'package:frontend/src/utils/dialog.dart';

class RegistrarFichaPage extends StatefulWidget {
  static String id = 'registrar_ficha_id';
  final String? restorationId;
  const RegistrarFichaPage({super.key, this.restorationId});

  @override
  State<RegistrarFichaPage> createState() => _RegistrarFichaPageState();
}

class _RegistrarFichaPageState extends State<RegistrarFichaPage>
    with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final rucController = TextEditingController();
  final cedulaController = TextEditingController();
  final personaController = TextEditingController();

  PacientesRepository? pacientesRest;

  @override
  void initState() {
    super.initState();
    final http = Http();

    pacientesRest = PacientesRepositoryImpl(
      PacientesApi(http),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar ficha',
        ),
      ),
      body: _getBody(),
    );
  }

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  String addCero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Widget _getBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                icon: Icon(Icons.slow_motion_video),
                hintText: 'dolor en el rodilla',
                labelText: 'Motivo de la consulta',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un motivo';
                }
                return null;
              },
            ),
            TextFormField(
              controller: apellidoController,
              decoration: const InputDecoration(
                icon: Icon(Icons.lens_outlined),
                hintText: 'lesion leve',
                labelText: 'Diagnostico',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un diagnostico';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.join_full),
                hintText: 'nada grave',
                labelText: 'Observacion',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa una observacion';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.emoji_people),
                hintText: 'id del empleado',
                labelText: 'Empleado',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un empleado';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.circle_notifications),
                hintText: 'id del cliente',
                labelText: 'Cliente',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un cliente';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.production_quantity_limits),
                hintText: 'id del tipo de producto',
                labelText: 'Producto',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un producto';
                }
                return null;
              },
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ProgressDialog.show(context);
                      await Future.delayed(Duration(seconds: 2));
                      ProgressDialog.dissmiss(context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFecha() {
    return '${_selectedDate.value.year}-${addCero(_selectedDate.value.month)}-${addCero(_selectedDate.value.day)} ${addCero(_selectedDate.value.hour)}:${addCero(_selectedDate.value.minute)}:${addCero(_selectedDate.value.second)}';
  }
}
