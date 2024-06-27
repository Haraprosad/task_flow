import 'environment.dart';

class EnvConfig {
  late final String baseUrl;
  late final EnvironmentType environmentType;

  late final String token;
  late final String todoSectionId;
  late final String inProgressSectionId;
  late final String doneSectionId;

  EnvConfig._internal();
  static final EnvConfig instance = EnvConfig._internal();

  bool _lock = false;
  factory EnvConfig.instantiate({
    required String baseUrl,
    required EnvironmentType environmentType,
    required String token,
    required String todoSectionId,
    required String inProgressSectionId,
    required String doneSectionId,
  }) {
    if (instance._lock) return instance;

    instance.baseUrl = baseUrl;
    instance.environmentType = environmentType;
    instance.token = token;
    instance.todoSectionId = todoSectionId;
    instance.inProgressSectionId = inProgressSectionId;
    instance.doneSectionId = doneSectionId;
    instance._lock = true;

    return instance;
  }
}
