import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/http/http_method.dart';
import 'package:frontend/src/domain/models/Paciente.dart';

class PacientesApi {
  final Http _http;

  PacientesApi(this._http);

  Future<List<Paciente>> obtenerPacientes() async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.get,
      queryParameters: {
        'inicio': '0',
        'cantidad': '3',
        'orderBy': 'apellido',
        'orderDir': 'desc',
      },
    );

    List<Paciente> pacientes = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        pacientes.add(Paciente.fromJson(dato));
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return pacientes;
  }

  Future<List<Paciente>> obtenerPacientesByNombre(String nombre) async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.get,
      queryParameters: {
        'ejemplo': '{"nombre":"$nombre"}',
      },
    );

    List<Paciente> pacientes = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        pacientes.add(Paciente.fromJson(dato));
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return pacientes;
  }

  Future<List<Paciente>> obtenerPacientesByNombreParcial(String nombre) async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.get,
      queryParameters: {
        'like': 'S',
        'ejemplo': '{"nombre":"$nombre"}',
      },
    );

    List<Paciente> pacientes = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        pacientes.add(Paciente.fromJson(dato));
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return pacientes;
  }

  Future<List<Paciente>> obtenerFisioterapeutas() async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.get,
      queryParameters: {'ejemplo': '{"soloUsuariosDelSistema":true}'},
    );

    List<Paciente> pacientes = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        pacientes.add(Paciente.fromJson(dato));
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return pacientes;
  }

  Future<Paciente> registrarPaciente(dynamic body) async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.post,
      body: body,
    );

    if (result.error == null) {
      Paciente paciente = Paciente.fromJson(result.data);
      return paciente;
    }

    if (result.statusCode == 500) {
      if (result.error!.data == "El registro ya existe.") {
        return Paciente(nombre: 'existe');
      }

      if (result.error!.data == "Valor de tipo persona no valido") {
        return Paciente(nombre: 'tipoPersona');
      }
    }

    return Paciente(nombre: 'nombre');
  }
}
