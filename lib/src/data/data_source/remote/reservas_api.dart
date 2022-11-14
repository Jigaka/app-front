import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/http/http_method.dart';
import 'package:frontend/src/data/helpers/http/http_result.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/models/Reserva.dart';
import 'package:frontend/src/domain/responses/reserva_response.dart';

class ReservasApi {
  final Http _http;

  ReservasApi(this._http);

  String addCero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Future<List<Reserva>> getReservasInicial(idPersona) async {
    DateTime date = DateTime.now();
    int year = date.year;
    int month = date.month;
    int day = date.day;
    String fecha = '$year${addCero(month)}${addCero(day)}';

    final result = await _http.request(
      "/reserva",
      method: HttpMethod.get,
      queryParameters: {
        'ejemplo':
            '{"idEmpleado":{"idPersona":$idPersona},"fechaDesdeCadena":"$fecha","fechaHastaCadena":"$fecha"}'
      },
    );

    List<Reserva> reservas = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        reservas.add(
          Reserva(
            idReserva: dato["idReserva"],
            cliente: Paciente(
              nombre: dato["idCliente"]["nombre"],
              idPersona: dato["idCliente"]["idPersona"],
            ),
            empledado: Paciente(
              nombre: dato["idEmpleado"]["nombre"],
              idPersona: dato["idEmpleado"]["idPersona"],
            ),
            fechaCadena: dato["fechaCadena"],
            horaFinCadena: dato["horaFinCadena"],
            horaInicioCadena: dato["horaInicioCadena"],
            observacion: dato["observacion"] ?? '',
            flagAsistio: dato['flagAsistio'] ?? 'N',
          ),
        );
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return reservas;
  }

  Future<List<Reserva>> getReservasFiltro(
      idCliente, idFisio, desde, hasta) async {
    DateTime date = DateTime.now();
    int year = date.year;
    int month = date.month;
    int day = date.day;
    String fecha = '$year${addCero(month)}${addCero(day)}';

    final HttpResult result;
    if (idFisio != 0 && desde != 'no' && hasta != 'no') {
      result = await _http.request(
        "/reserva",
        method: HttpMethod.get,
        queryParameters: {
          'ejemplo':
              '{"idEmpleado":{"idPersona":$idFisio},"fechaDesdeCadena":"${desde != 'no' ? desde : fecha}","fechaHastaCadena":"${hasta != 'no' ? hasta : fecha}"}'
        },
      );
    } else if (idCliente != 0) {
      result = await _http.request(
        "/reserva",
        method: HttpMethod.get,
        queryParameters: {'ejemplo': '{"idCliente":{"idPersona":$idCliente}}'},
      );
    } else {
      result = await _http.request(
        "/reserva",
        method: HttpMethod.get,
        queryParameters: {
          'ejemplo':
              '{"idEmpleado":{"idPersona":323},"fechaDesdeCadena":"${desde != 'no' ? desde : fecha}","fechaHastaCadena":"${hasta != 'no' ? hasta : fecha}"}'
        },
      );
    }

    List<Reserva> reservas = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        reservas.add(
          Reserva(
              idReserva: dato["idReserva"],
              cliente: Paciente(
                nombre: dato["idCliente"]["nombre"],
                idPersona: dato["idCliente"]["idPersona"],
              ),
              empledado: Paciente(
                nombre: dato["idEmpleado"]["nombre"],
                idPersona: dato["idEmpleado"]["idPersona"],
              ),
              fechaCadena: dato["fechaCadena"],
              horaFinCadena: dato["horaFinCadena"],
              horaInicioCadena: dato["horaInicioCadena"]),
        );
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return reservas;
  }

  Future<ReservaResponse> cancelarReserva(idReserva) async {
    final result =
        await _http.request("/reserva/$idReserva", method: HttpMethod.delete);

    if (result.error == null) {
      return ReservaResponse.ok;
    }
    return ReservaResponse.denied;
  }
}
