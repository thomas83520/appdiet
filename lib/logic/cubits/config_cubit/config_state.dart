part of 'config_cubit.dart';

enum ConfigStateStatus { loading, loaded }

class ConfigState extends Equatable {
  const ConfigState(
      {required this.state,
      required this.enforceVersion,
      required this.currentVersion,
      required this.needUpdate});

  final ConfigStateStatus state;
  final String enforceVersion;
  final String currentVersion;
  final bool needUpdate;

  @override
  List<Object> get props => [state, enforceVersion, currentVersion, needUpdate];
}
