import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/models/TipoProducto.dart';

class Ficha {
  int? idFichaClinica;
  String? motivoConsulta;
  String? diagnostico;
  String? observacion;
  Paciente? empleado;
  Paciente? cliente;
  TipoProducto? tipoProducto;
  String? fechaHoraCadena;

  Ficha({
    this.idFichaClinica,
    this.motivoConsulta,
    this.diagnostico,
    this.observacion,
    this.empleado,
    this.cliente,
    this.tipoProducto,
    this.fechaHoraCadena,
  });
}
