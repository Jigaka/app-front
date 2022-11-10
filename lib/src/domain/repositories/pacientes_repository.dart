import 'package:frontend/src/domain/models/paciente.dart';

abstract class PacientesRepository {
  Future<List<Paciente>> obtenerPacientes();
}
