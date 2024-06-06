import 'package:chaos_thought_feast/services/fire_db_auth_service.dart';
import 'package:chaos_thought_feast/services/fire_db_service.dart';
import 'package:get_it/get_it.dart';
import 'package:chaos_thought_feast/services/navigation_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<IFirebaseAuthService>(() => AuthService());
  locator.registerLazySingleton<IFireDBService>(() => RealFireDBService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService(
    fireDBService: locator<IFireDBService>(),
    firebaseAuthService: locator<IFirebaseAuthService>(),
  ));
}