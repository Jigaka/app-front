import 'package:frontend/src/domain/models/Paciente.dart';

abstract class PacientesRepository {
  Future<List<Paciente>> obtenerPacientes();
}
