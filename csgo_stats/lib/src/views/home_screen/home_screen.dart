import 'package:csgo_stats/src/blocs/steam_user_bloc/steam_user_bloc.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CS:GO Stats'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            BlocProvider(
              create: (context) => SteamUserBloc(),
              child: const UserDetails(),
            ),
          ],
        ),
      ),
    );
  }
}
