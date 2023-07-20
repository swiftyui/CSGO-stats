part of 'steam_user_bloc.dart';

@immutable
abstract class SteamUserState extends Equatable {
  const SteamUserState();

  @override
  List<Object> get props => [];
}

class SteamUserInitial extends SteamUserState {
  @override
  List<Object> get props => [];
}

class SteamUserLoading extends SteamUserState {
  @override
  List<Object> get props => [];
}

class SteamUserLoaded extends SteamUserState {
  final SteamUser steamUser;

  const SteamUserLoaded({
    required this.steamUser,
  });

  @override
  List<Object> get props => [];
}

class SteamUserError extends SteamUserState {
  final String errorMessage;

  const SteamUserError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [];
}
