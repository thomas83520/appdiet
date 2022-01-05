import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ConfigRepository {
  static Future<bool> get needUpdate async {
    final String packageVersion = await _packageVersion;
    final String enforcedVersion = await _enforcedVersion;

    final List<int> currentVersion = packageVersion
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> minimalVersion = enforcedVersion
        .split('.')
        .map((String number) => int.parse(number))
        .toList();

    for (int i = 0; i < 3; i++) {
      if (minimalVersion[i] > currentVersion[i]) {
        return true;
      }
    }
    return false;
  }

  static Future<String> get _enforcedVersion async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 1)));
    await remoteConfig.fetch();
    await remoteConfig.activate();
    return remoteConfig.getString('ENFORCED_VERSION');
  }

  static Future<String> get _packageVersion async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
