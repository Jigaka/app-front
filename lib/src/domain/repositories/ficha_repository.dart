import 'package:frontend/src/domain/models/Ficha.dart';

abstract class FichaRepository {
  Future<List<Ficha>> obternerFichasIncial();
}
