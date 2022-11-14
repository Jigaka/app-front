import 'package:flutter/cupertino.dart';
import 'package:frontend/src/domain/models/Paciente.dart';

class Reserva {
  String fechaCadena;
  String horaInicioCadena;
  String horaFinCadena;
  Paciente empledado;
  Paciente cliente;
  int idReserva;
  String? observacion;
  String? flagAsistio;

  Reserva({
    required this.idReserva,
    required this.cliente,
    required this.empledado,
    required this.fechaCadena,
    required this.horaFinCadena,
    required this.horaInicioCadena,
    this.observacion,
    this.flagAsistio,
  });
}
