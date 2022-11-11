import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';
import 'package:frontend/src/utils/dialog.dart';

class RegistrarPacientePage extends StatefulWidget {
  static String id = 'registrar_paciente_id';
  final String? restorationId;
  const RegistrarPacientePage({super.key, this.restorationId});

  @override
  State<RegistrarPacientePage> createState() => _RegistrarPacientePageState();
}

class _RegistrarPacientePageState extends State<RegistrarPacientePage>
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
          'Registrar paciente',
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
                icon: Icon(Icons.person),
                hintText: 'nombre de la persona',
                labelText: 'Nombre',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: apellidoController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'apellido de la persona',
                labelText: 'Apellido',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un apellido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'example@email.com',
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un email';
                }
                if (!value.contains("@")) {
                  return 'ingresa un correo valido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: telefonoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: '09XX XXX XXX',
                labelText: 'Telefono',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un numero de telefono';
                }
                return null;
              },
            ),
            TextFormField(
              controller: rucController,
              decoration: const InputDecoration(
                icon: Icon(Icons.numbers),
                hintText: '456789-8',
                labelText: 'Ruc',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un numero de ruc';
                }
                return null;
              },
            ),
            TextFormField(
              controller: cedulaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.perm_identity),
                hintText: '456789',
                labelText: 'Cedula',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un numero de ruc';
                }
                return null;
              },
            ),
            TextFormField(
              controller: personaController,
              decoration: const InputDecoration(
                icon: Icon(Icons.type_specimen),
                hintText: 'FISICA',
                labelText: 'Tipo de persona',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ingresa un numero de ruc';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 40.0),
              child: OutlinedButton(
                onPressed: () {
                  _restorableDatePickerRouteFuture.present();
                },
                child: const Text('Ingresar de Nacimiento'),
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Paciente paciente = Paciente(
                        nombre: nombreController.text,
                        apellido: apellidoController.text,
                        email: emailController.text,
                        telefono: telefonoController.text,
                        ruc: rucController.text,
                        cedula: cedulaController.text,
                        tipoPersona: personaController.text,
                        fechaNacimiento: getFecha(),
                      );

                      ProgressDialog.show(context);
                      Paciente pacienteResponse = await pacientesRest!
                          .registrarPaciente(paciente.toJson());
                      ProgressDialog.dissmiss(context);
                      if (pacienteResponse.nombre.contains('existe')) {
                        _formKey.currentState!.reset();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Paciente ya registrado"),
                          ),
                        );
                      } else if (pacienteResponse.nombre
                          .contains('tipoPersona')) {
                        personaController.text = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tipo persona no valido"),
                          ),
                        );
                      } else if (pacienteResponse.idPersona != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Paciente ${pacienteResponse.nombre} registrado'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("error en el registro del paciente"),
                          ),
                        );
                      }
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
