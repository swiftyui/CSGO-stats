import 'package:csgo_stats/src/blocs/steam_user_bloc/steam_user_bloc.dart';
import 'package:csgo_stats/src/views/home_screen/home_drawer.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/user_details.dart';
import 'package:csgo_stats/src/views/home_screen/user_stats/user_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('CS:GO Stats'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const FaIcon(
              Icons.menu,
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: false,
      body: BlocProvider(
        create: (context) => SteamUserBloc(),
        child: const Column(
          children: [
            UserDetails(),
            Expanded(
              child: UserStats(),
            )
          ],
        ),
      ),
      endDrawer: const HomeDrawer(),
    );
  }
}
