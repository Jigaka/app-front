import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/http/http_method.dart';
import 'package:frontend/src/domain/models/Categoria.dart';
import 'package:frontend/src/domain/models/Ficha.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/models/TipoProducto.dart';

class FichasApi {
  final Http _http;

  FichasApi(this._http);

  String addCero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Future<List<Ficha>> getFichasInicial(idPersona) async {
    DateTime date = DateTime.now();
    int year = date.year;
    int month = date.month;
    int day = date.day;
    String fecha = '$year${addCero(month)}${addCero(day)}';

    final result = await _http.request(
      "/fichaClinica",
      method: HttpMethod.get,
    );

    List<Ficha> fichas = [];

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        fichas.add(
          Ficha(
            idFichaClinica: dato['idFichaClinica'],
            motivoConsulta: dato['motivoConsulta'],
            diagnostico: dato['diagnostico'],
            observacion: dato['observacion'],
            empleado: Paciente(
              nombre: dato['idEmpleado']['nombre'],
              idPersona: dato['idEmpleado']['idPersona'],
            ),
            cliente: Paciente(
              nombre: dato['idCliente']['nombre'],
              idPersona: dato['idCliente']['idPersona'],
            ),
            tipoProducto: TipoProducto(
              idTipoProducto: dato['idTipoProducto']['idTipoProducto'],
              descripcion: dato['idTipoProducto']['descripcion'],
              flagVisible: dato['idTipoProducto']['flagVisible'],
              categoria: Categoria(
                idCategoria: dato['idTipoProducto']['idCategoria']
                    ['idCategoria'],
                descripcion: dato['idTipoProducto']['idCategoria']
                    ['descripcion'],
                flagVisible: dato['idTipoProducto']['idCategoria']
                    ['flagVisible'],
                posicion: dato['idTipoProducto']['idCategoria']['posicion'],
              ),
            ),
            fechaHoraCadena: dato['fechaHoraCadena'],
          ),
        );
      }
    }

    if (result.statusCode == 500) {
      return [];
    }

    return fichas;
  }
}
