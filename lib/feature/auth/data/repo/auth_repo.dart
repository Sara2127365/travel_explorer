import 'package:travel_explorer/feature/auth/data/datasource/auth_remote_data_source.dart';

class AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepo(this.authRemoteDataSource);

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await authRemoteDataSource.register(email, password, name);
  }

  Future<void> login({required String email, required String password}) async {
    await authRemoteDataSource.login(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await authRemoteDataSource.sendPasswordResetEmail(email: email);
  }
}
