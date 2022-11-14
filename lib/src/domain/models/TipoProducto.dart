import 'package:frontend/src/domain/models/Categoria.dart';

class TipoProducto {
  int? idTipoProducto;
  String? descripcion;
  String? flagVisible;
  Categoria? categoria;
  int? posicion;

  TipoProducto({
    this.idTipoProducto,
    this.categoria,
    this.descripcion,
    this.flagVisible,
    this.posicion,
  });
}
