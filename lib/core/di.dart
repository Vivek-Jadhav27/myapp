import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/auth/data/datasources/auth_ds.dart';
import 'package:myapp/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:myapp/features/auth/domain/usecases/login_uc.dart';
import 'package:myapp/features/auth/domain/usecases/register_uc.dart';
import 'package:myapp/features/auth/domain/usecases/signout_uc.dart';
import 'package:myapp/features/auth/presentation/provider/auth_notifier.dart';

final sl = GetIt.instance;

void init() {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Auth
  sl.registerLazySingleton<AuthDS>(() => AuthDSImpl(sl()));
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
  sl.registerLazySingleton(() => LoginUC(sl()));
  sl.registerLazySingleton(() => RegisterUC(sl()));
  sl.registerLazySingleton(() => SignOutUC(sl()));
  sl.registerFactory(
    () => AuthNotifier(
      loginUC: sl(),
      registerUC: sl(),
      signOutUC: sl(),
    ),
  );
}
