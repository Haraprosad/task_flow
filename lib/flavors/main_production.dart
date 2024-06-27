// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:task_flow/core/constants/key_constants.dart';
// import 'env_config.dart';
// import 'environment.dart';

// void main() async{
//   await dotenv.load(fileName: KeyConstants.envProduction);
  
//   EnvConfig.instantiate(
//     baseUrl: dotenv.env[KeyConstants.envKeyBaseUrl]!,
//     token: dotenv.env[KeyConstants.envKeyToken]!,
//     todoSectionId: dotenv.env[KeyConstants.envKeyTodoSectionId]!,
//     inProgressSectionId: dotenv.env[KeyConstants.envKeyInProgressSectionId]!,
//     doneSectionId: dotenv.env[KeyConstants.envKeyDoneSectionId]!, 
//     environmentType: EnvironmentType.PRODUCTION 
//   );

//   await runMainApp();
// }
