import 'package:equatable/equatable.dart';

class SteamUser extends Equatable {
  final String? steamid;
  final String? personaname;
  final String? avatar;
  final String? avatarmedium;
  final String? avatarfull;
  final String? realname;

  const SteamUser({
    this.steamid,
    this.personaname,
    this.avatar,
    this.avatarmedium,
    this.avatarfull,
    this.realname,
  });

  factory SteamUser.fromJson(Map json) {
    return SteamUser(
      steamid: json['steamid'],
      personaname: json['personaname'],
      avatar: json['avatar'],
      avatarmedium: json['avatarmedium'],
      avatarfull: json['avatarfull'],
      realname: json['realname'],
    );
  }

  @override
  List<Object?> get props => [
        steamid,
        personaname,
        avatar,
        avatarmedium,
        avatarfull,
        realname,
      ];
}
