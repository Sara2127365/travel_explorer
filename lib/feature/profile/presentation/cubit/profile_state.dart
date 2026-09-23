abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class SuccessProfileState extends ProfileState {
  final Map<String, dynamic> userData;

  SuccessProfileState(this.userData);
}

class FailureProfileState extends ProfileState {
  final String message;

  FailureProfileState(this.message);
}

class LogoutSuccessProfileState extends ProfileState {}