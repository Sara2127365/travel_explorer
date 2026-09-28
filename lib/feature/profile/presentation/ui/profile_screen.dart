
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:travel_explorer/core/di/service_locaor.dart';
import 'package:travel_explorer/core/localization/app_localizations.dart';
import 'package:travel_explorer/core/routes/app_routes.dart';
import 'package:travel_explorer/core/widget/header.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/locale_cubit.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/profile_state.dart';
import 'package:travel_explorer/feature/profile/presentation/cubit/theme_cubit.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

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

            final isDarkMode =
                context.watch<ThemeCubit>().state == ThemeMode.dark;

            final currentLocale =
                context.watch<LocaleCubit>().state.languageCode;

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
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
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

                    // Dark Mode
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(localization.darkMode),
                      secondary: const Icon(Icons.dark_mode),
                      value: isDarkMode,
                      onChanged: (_) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),

                    const SizedBox(height: 10),

                    // Language
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language),
                      title: Text(localization.language),
                      trailing: DropdownButton<String>(
                        value: currentLocale,
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(localization.english),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: Text(localization.arabic),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<LocaleCubit>()
                                .changeLanguage(value);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProfileCubit>().logout();
                        },
                        icon: const Icon(Icons.logout),
                        label: Text(localization.logout),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text(localization.noUserData),
            ),
          );
        },
      ),
    );
  }
}
