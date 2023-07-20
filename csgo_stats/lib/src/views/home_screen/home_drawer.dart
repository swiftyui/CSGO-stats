import 'package:csgo_stats/src/services/steam_service.dart';
import 'package:csgo_stats/src/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Future<void> _launchUrl({required Uri uri}) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _signInSignOut(context),
                    _buildDrawerButton(
                      context: context,
                      title: 'Report Abusive Content',
                      iconData: FontAwesomeIcons.exclamation,
                      onTap: () => _launchUrl(
                        uri: Uri.parse(
                          'https://648094a89e50b80ae2aaea25--euphonious-marzipan-307f69.netlify.app/',
                        ),
                      ),
                    ),
                    _buildDrawerButton(
                      context: context,
                      title: 'Change Theme',
                      iconData: FontAwesomeIcons.paintRoller,
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _signInSignOut(BuildContext context) {
    if (SteamService.instance.steamUserId.isEmpty) {
      return _buildDrawerButton(
        context: context,
        title: 'Sign in to Steam',
        iconData: FontAwesomeIcons.steam,
        onTap: () async {
          await SteamService.instance.signInToSteam();
        },
      );
    } else {
      return _buildDrawerButton(
        context: context,
        title: 'Sign out of Steam',
        iconData: FontAwesomeIcons.steam,
        onTap: () async {
          await SteamService.instance.signOutOfSteam();
        },
      );
    }
  }

  Widget _buildDrawerButton({
    required BuildContext context,
    required String title,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      onTap: onTap,
      dense: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.background),
      ),
      leading: Icon(
        iconData,
        size: 30,
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
