import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/http/http_method.dart';
import 'package:frontend/src/domain/responses/login_response.dart';

class AuthenticacionAPI {
  final Http _http;

  AuthenticacionAPI(this._http);

  Future<LoginResponse> login(String username) async {
    final result = await _http.request(
      "/persona",
      method: HttpMethod.get,
      queryParameters: {'ejemplo': '{"soloUsuariosDelSistema":true}'},
    );

    if (result.error == null) {
      List<dynamic> datos = result.data['lista'];
      for (dynamic dato in datos) {
        if (dato['usuarioLogin'] == username) {
          return LoginResponse.ok;
        }
      }
    }

    if (result.statusCode == 500) {
      return LoginResponse.unknownError;
    }

    return LoginResponse.accessDenied;
  }
}
