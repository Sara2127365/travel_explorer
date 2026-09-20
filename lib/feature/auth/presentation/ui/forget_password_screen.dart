
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/widget/button_app.dart';
import 'package:travel_explorer/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_explorer/feature/auth/presentation/cubit/auth_state.dart';
import 'package:travel_explorer/feature/auth/presentation/widget/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نسيت كلمة المرور'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              }

              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'ادخل البريد الإلكتروني المسجل بالفعل',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'سنرسل لك رابطاً لإعادة تعيين كلمة المرور',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  CustomTextFormField(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    isPassword: false,
                    readOnly: isLoading,
                    prefixIcon: Icons.email,
                  ),

                  const SizedBox(height: 25),

                  ButtonApp(
                    text: 'Reset Password',
                    isLoading: isLoading,
                    onPressed: () {
                      context.read<AuthCubit>().sendPasswordResetEmail(
                        email: _emailController.text.trim(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
