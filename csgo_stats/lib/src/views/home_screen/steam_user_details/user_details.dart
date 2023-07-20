import 'package:csgo_stats/src/blocs/steam_user_bloc/steam_user_bloc.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/initial_user.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/loading_user.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/user_loaded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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
        return const InitialSteamUser();
      } else if (state is SteamUserLoading) {
        return const LoadingSteamUser();
      } else if (state is SteamUserLoaded) {
        return const UserLoaded();
      } else if (state is SteamUserError) {
        return const InitialSteamUser();
      } else {
        return const InitialSteamUser();
      }
    });
  }
}
