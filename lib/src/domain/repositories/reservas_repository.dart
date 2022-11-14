import 'package:frontend/src/domain/models/Reserva.dart';
import 'package:frontend/src/domain/responses/reserva_response.dart';

abstract class ReservaRepository {
  Future<List<Reserva>> obternerReservasIncial();
  Future<List<Reserva>> obternerReservasFiltros(
    idCliente,
    idFisio,
    desde,
    hasta,
  );
  Future<ReservaResponse> cancelarReserva(idPersona);
}
