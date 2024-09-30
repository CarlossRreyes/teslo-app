

import 'package:teslo_shop/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl({
    AuthDataSource? dataSource    
  }) : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    // TODO: implement login
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    return dataSource.register(email, password, fullName);
  }


}