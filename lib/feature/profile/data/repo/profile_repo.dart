

import 'package:travel_explorer/feature/profile/data/datasource/profile_remote_data_source.dart';

class ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepo(this.profileRemoteDataSource);

  Future<Map<String, dynamic>?> getUser() async {
    return profileRemoteDataSource.getUser();
  }

  Future<void> logout() async {
    await profileRemoteDataSource.logout();
  }
}
