import 'package:flutter_application_1/api/user_api.dart';
import 'package:get_it/get_it.dart';

GetIt servicelocator = GetIt.instance;

void setupLocator() {
   servicelocator.registerSingleton<UserService>(UserService(),
      signalsReady: true);
}