import 'package:frontend/src/data/data_source/remote/authentication_api.dart';
import 'package:frontend/src/domain/repositories/authentication_repository.dart';
import 'package:frontend/src/domain/responses/login_response.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticacionAPI _api;

  AuthenticationRepositoryImpl(this._api);

  @override
  Future<LoginResponse> login(String username) {
    return _api.login(username);
  }
}
