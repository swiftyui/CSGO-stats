import 'package:csgo_stats/src/theme/theme_cubit.dart';
import 'package:csgo_stats/src/views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CSGOStatsApp extends StatelessWidget {
  /// {@macro app}
  const CSGOStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
