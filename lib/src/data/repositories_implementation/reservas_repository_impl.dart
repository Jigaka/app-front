import 'package:frontend/src/data/data_source/remote/reservas_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/domain/models/Reserva.dart';
import 'package:frontend/src/domain/repositories/reservas_repository.dart';
import 'package:frontend/src/domain/responses/reserva_response.dart';

class ReservasRepositoryImpl implements ReservaRepository {
  final ReservasApi _api;

  ReservasRepositoryImpl(
    this._api,
  );

  @override
  Future<List<Reserva>> obternerReservasIncial() {
    return _api.getReservasInicial(
      323,
    );
  }

  @override
  Future<List<Reserva>> obternerReservasFiltros(
    idCliente,
    idFisio,
    desde,
    hasta,
  ) {
    return _api.getReservasFiltro(idCliente, idFisio, desde, hasta);
  }

  @override
  Future<ReservaResponse> cancelarReserva(idReserva) {
    return _api.cancelarReserva(idReserva);
  }
}
