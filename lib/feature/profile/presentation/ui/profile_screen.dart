import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/core/widget/header.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getUserData(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccessProfileState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
              (route) => false,
            );
          }

          if (state is FailureProfileState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingProfileState) {
            return const Scaffold(
             
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is SuccessProfileState) {
            final userData = state.userData;

            final name = userData['name'] ?? 'User';
            final email = userData['email'] ?? '';

            return Scaffold(
              appBar: Header(),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProfileCubit>().logout();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text('No user data'),
            ),
          );
        },
      ),
    );
  }
}