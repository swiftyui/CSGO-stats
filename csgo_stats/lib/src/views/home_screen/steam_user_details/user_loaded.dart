import 'package:csgo_stats/src/models/steam_user.dart';
import 'package:csgo_stats/src/views/home_screen/steam_user_details/steam_user_avatar.dart';
import 'package:flutter/material.dart';

class UserLoaded extends StatelessWidget {
  final SteamUser steamUser;
  const UserLoaded({
    super.key,
    required this.steamUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SteamUserAvatar(
                    height: 80,
                    width: 80,
                    imageUrl: steamUser.avatarfull,
                  ),
                  _buildUserInfo(context),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(steamUser.personaname ?? "Persona Name"),
          Text(steamUser.realname ?? "Real Name"),
        ],
      ),
    );
  }
}
