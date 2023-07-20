class SteamUser {
  late String? steamid;
  late String? personaname;
  late String? avatar;
  late String? avatarmedium;
  late String? avatarfull;
  late String? realname;

  SteamUser({
    this.steamid,
    this.personaname,
    this.avatar,
    this.avatarmedium,
    this.avatarfull,
    this.realname,
  });

  SteamUser.fromJson(Map json) {
    steamid = json['steamid'];
    personaname = json['personaname'];
    avatar = json['avatar'];
    avatarmedium = json['avatarmedium'];
    avatarfull = json['avatarfull'];
    realname = json['realname'];
  }
}
