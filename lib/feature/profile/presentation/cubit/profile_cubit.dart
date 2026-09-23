import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/profile/data/repo/profile_repo.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(InitialProfileState());

  Future<void> getUserData() async {
    emit(LoadingProfileState());

    try {
      final userData = await profileRepo.getUser();

      if (userData == null) {
        emit(FailureProfileState('User not found'));
        return;
      }

      emit(SuccessProfileState(userData));
    } catch (e) {
      emit(FailureProfileState(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await profileRepo.logout();

      emit(LogoutSuccessProfileState());
    } catch (e) {
      emit(FailureProfileState(e.toString()));
    }
  }
}
