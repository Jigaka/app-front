import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';

class PacientesRepositoryImpl implements PacientesRepository {
  final PacientesApi _api;

  PacientesRepositoryImpl(this._api);

  @override
  Future<List<Paciente>> obtenerPacientes() {
    return _api.obtenerPacientes();
  }

  @override
  Future<List<Paciente>> obtenerPacientesByNombre(String nombre) {
    return _api.obtenerPacientesByNombre(nombre);
  }

  @override
  Future<List<Paciente>> obtenerPacientesByNombreParcial(String nombre) {
    return _api.obtenerPacientesByNombreParcial(nombre);
  }

  @override
  Future<List<Paciente>> obtenerFisioterapeutas() {
    return _api.obtenerFisioterapeutas();
  }

  @override
  Future<Paciente> registrarPaciente(body) {
    return _api.registrarPaciente(body);
  }
}
