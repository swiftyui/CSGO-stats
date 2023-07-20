part of 'steam_user_bloc.dart';

@immutable
abstract class SteamUserEvent extends Equatable {
  const SteamUserEvent();

  @override
  List<Object> get props => [];
}

class LoadSteamUser extends SteamUserEvent {
  @override
  List<Object> get props => [];
}

class SignInToSteam extends SteamUserEvent {
  @override
  List<Object> get props => [];
}
