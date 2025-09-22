import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/auth/data/datasources/auth_ds.dart';
import 'package:myapp/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';
import 'package:myapp/features/auth/domain/usecases/login_uc.dart';
import 'package:myapp/features/auth/domain/usecases/register_uc.dart';
import 'package:myapp/features/auth/domain/usecases/signout_uc.dart';
import 'package:myapp/features/auth/presentation/provider/auth_notifier.dart';
import 'package:myapp/features/transactions/data/datasources/transaction_ds.dart';
import 'package:myapp/features/transactions/data/repositories/transaction_repo_impl.dart';
import 'package:myapp/features/transactions/domain/repositories/transaction_repo.dart';
import 'package:myapp/features/transactions/domain/usecases/add_transaction_uc.dart';
import 'package:myapp/features/transactions/domain/usecases/delete_transaction_uc.dart';
import 'package:myapp/features/transactions/domain/usecases/get_transactions_uc.dart';
import 'package:myapp/features/transactions/domain/usecases/update_transaction_uc.dart';
import 'package:myapp/features/transactions/presentation/provider/transaction_provider.dart';

final sl = GetIt.instance;

void init() {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

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

  // Transactions
  sl.registerLazySingleton<TransactionDS>(
      () => TransactionDSImpl(firestore: sl()));
  sl.registerLazySingleton<TransactionRepo>(() => TransactionRepoImpl(dataSource: sl()));
  sl.registerLazySingleton(() => AddTransactionUC(sl()));
  sl.registerLazySingleton(() => GetTransactionsUC(sl()));
  sl.registerLazySingleton(() => UpdateTransactionUC(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUC(sl()));
  sl.registerFactory(
    () => TransactionProvider(
      addTransactionUC: sl(),
      getTransactionsUC: sl(),
      updateTransactionUC: sl(),
      deleteTransactionUC: sl(),
    ),
  );
}
