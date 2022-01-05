import 'dart:core';

import 'package:appdiet/data/repository/config_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  ConfigCubit()
      : super(ConfigState(
            state: ConfigStateStatus.loading,
            enforceVersion: '',
            currentVersion: '',
            needUpdate: false));

  void initConfig() async {
    final String currentVersion = await ConfigRepository.packageVersion;
    final String enforceVersion = await ConfigRepository.enforcedVersion;
    final bool needUpdate = await ConfigRepository.needUpdate;

    emit(ConfigState(
        currentVersion: currentVersion,
        enforceVersion: enforceVersion,
        needUpdate: needUpdate,
        state: ConfigStateStatus.loaded));
  }
}
