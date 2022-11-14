import 'package:frontend/src/data/data_source/remote/ficha_api.dart';
import 'package:frontend/src/domain/models/Ficha.dart';
import 'package:frontend/src/domain/repositories/ficha_repository.dart';

class FichasRepositoryImpl implements FichaRepository {
  final FichasApi _api;

  FichasRepositoryImpl(
    this._api,
  );

  @override
  Future<List<Ficha>> obternerFichasIncial() {
    return _api.getFichasInicial(
      323,
    );
  }
}
