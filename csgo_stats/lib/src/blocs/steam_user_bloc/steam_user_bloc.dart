import 'package:bloc/bloc.dart';
import 'package:csgo_stats/src/models/steam_user.dart';
import 'package:csgo_stats/src/services/steam_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'steam_user_event.dart';
part 'steam_user_state.dart';

class SteamUserBloc extends Bloc<SteamUserEvent, SteamUserState> {
  SteamUserBloc() : super(SteamUserInitial()) {
    on<LoadSteamUser>(_loadSteamUser);
    on<SignInToSteam>(_signInToSteam);
  }

  Future<void> _loadSteamUser(
    LoadSteamUser event,
    Emitter<SteamUserState> emit,
  ) async {
    emit(SteamUserLoading());
    SteamService.ensureInitialized();
    if (SteamService.instance.steamUserId.isEmpty) {
      emit(SteamUserInitial());
      return;
    } else {
      SteamUser steamUser = await SteamService.instance.getSteamUser();
      emit(SteamUserLoaded(steamUser: steamUser));
    }
  }

  Future<void> _signInToSteam(
    SignInToSteam event,
    Emitter<SteamUserState> emit,
  ) async {
    emit(SteamUserLoading());
    SteamService.ensureInitialized();
    try {
      SteamUser? steamUser = await SteamService.instance.signInToSteam();
      if (steamUser == null) {
        emit(SteamUserInitial());
      } else {
        emit(SteamUserLoaded(steamUser: steamUser));
      }
    } on SteamServiceException catch (_) {
      emit(SteamUserInitial());
    }
  }
}
