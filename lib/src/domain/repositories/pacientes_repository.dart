import 'package:frontend/src/domain/models/Paciente.dart';

abstract class PacientesRepository {
  Future<List<Paciente>> obtenerPacientes();
  Future<List<Paciente>> obtenerPacientesByNombre(String nombre);
  Future<List<Paciente>> obtenerPacientesByNombreParcial(String nombre);
  Future<List<Paciente>> obtenerFisioterapeutas();
  Future<Paciente> registrarPaciente(dynamic body);
}
