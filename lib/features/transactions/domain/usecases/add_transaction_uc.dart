import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repo.dart';
import '../../../../core/error/failure.dart';


class AddTransactionUC implements UseCase<void, TransactionEntity> {
  final TransactionRepo repo;

  AddTransactionUC(this.repo);

  @override
  Future<Either<Failure, void>> call(TransactionEntity params) async {
    return await repo.addTransaction(params);
  }
}
