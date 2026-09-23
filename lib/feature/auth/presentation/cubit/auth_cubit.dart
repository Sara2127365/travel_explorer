import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/auth/data/repo/auth_repo.dart';
import 'package:travel_explorer/feature/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (email.isEmpty) {
      emit(AuthFailure('رجاء ادخل الايميل'));
      return;
    }
    if (name.isEmpty) {
      emit(AuthFailure('رجاء ادخل الاسم '));
      return;
    }
    if (password.isEmpty) {
      emit(AuthFailure('رجاء اخل كلمة المرور'));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(AuthFailure('صيغة البريد الالكترونى غير صحيحة'));
      return;
    }
    if (password.length < 6) {
      emit(AuthFailure('كلمة المرور على الاقل  6 احرف '));
      return;
    }

    emit(AuthLoading());
    try {
      await authRepo.register(email: email, password: password, name: name);
      emit(AuthSuccess('Account created successfully'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty) {
      emit(AuthFailure('رجاء ادخل البريد الالكترونى'));
      return;
    }
    if (password.isEmpty) {
      emit(AuthFailure(' رجاء ادخل كلمةالمرور'));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(AuthFailure('صيغة البريد الالكترونى غير صحيحة'));
      return;
    }

    emit(AuthLoading());

    try {
      await authRepo.login(email: email, password: password);

      emit(AuthSuccess('Login successful'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    if (email.isEmpty) {
      emit(AuthFailure('رجاء ادخل البريد الالكترونى '));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(AuthFailure('صيغة البريد الالكترونى  غير صحيحة '));
      return;
    }
    emit(AuthLoading());
    try {
      await authRepo.sendPasswordResetEmail(email: email);
      emit( AuthSuccess('تم إرسال رابط إعادة تعيين كلمة المرور إلى البريد الإلكتروني'),
    );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  
}
