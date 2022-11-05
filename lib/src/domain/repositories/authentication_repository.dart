import 'package:frontend/src/domain/responses/login_response.dart';

abstract class AuthenticationRepository {
  Future<LoginResponse> login(String username);
}
