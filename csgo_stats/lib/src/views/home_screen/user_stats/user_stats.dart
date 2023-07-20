import 'package:csgo_stats/src/blocs/steam_user_bloc/steam_user_bloc.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/initial_user.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/loading_user.dart';
import 'package:csgo_stats/src/views/home_screen/user_stats/initial_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserStats extends StatefulWidget {
  const UserStats({super.key});

  @override
  State<UserStats> createState() => _UserStats();
}

class _UserStats extends State<UserStats> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SteamUserBloc>(context).add(LoadSteamUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SteamUserBloc, SteamUserState>(
        builder: (context, state) {
      if (state is SteamUserInitial) {
        return InitialStats();
      } else if (state is SteamUserLoading) {
        return const LoadingSteamUser();
      } else if (state is SteamUserLoaded) {
        return Container(
          width: 200,
          height: 200,
          color: Colors.green,
        );
      } else if (state is SteamUserError) {
        return Container(
          width: 200,
          height: 200,
          color: Colors.red,
        );
      } else {
        return Container(
          width: 200,
          height: 200,
          color: Colors.red,
        );
      }
    });
  }
}
