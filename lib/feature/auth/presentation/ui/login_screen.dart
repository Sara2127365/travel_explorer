import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/localization/app_localizations.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/core/widget/button_app.dart';
import 'package:travel_explorer/feature/auth/presentation/widget/custom_text_form_field.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
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

                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.mainScreen,
                            );
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
                            children: [
                              const SizedBox(height: 40),

                              Text(
                                localization.welcomeBack,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 40),

                              CustomTextFormField(
                                label: localization.email,
                                controller: emailController,
                                isPassword: false,
                                readOnly: isLoading,
                                prefixIcon: Icons.email,
                              ),

                              const SizedBox(height: 15),

                              CustomTextFormField(
                                label: localization.password,
                                controller: passwordController,
                                isPassword: true,
                                readOnly: isLoading,
                                prefixIcon: Icons.password,
                                suffixIcon: const Icon(
                                  Icons.remove_red_eye_sharp,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.forgetpasswordScreen,
                                          );
                                        },
                                  child: Text(
                                    localization.forgetPassword,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              ButtonApp(
                                text: localization.login,
                                isLoading: isLoading,
                                onPressed: () {
                                  context.read<AuthCubit>().login(
                                        email:
                                            emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );
                                },
                              ),

                              const Spacer(),

                              const SizedBox(height: 30),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.dontHaveAccount,
                                  ),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            Navigator
                                                .pushReplacementNamed(
                                              context,
                                              AppRoutes.registerScreen,
                                            );
                                          },
                                    child: Text(
                                      localization.signUp,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

