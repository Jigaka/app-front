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
}
