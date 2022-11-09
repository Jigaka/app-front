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
}
