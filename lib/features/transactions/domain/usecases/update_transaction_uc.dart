import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repo.dart';

class UpdateTransactionUC implements UseCase<void, TransactionEntity> {
  final TransactionRepo repo;

  UpdateTransactionUC(this.repo);

  @override
  Future<Either<Failure, void>> call(TransactionEntity params) async {
    return await repo.updateTransaction(params);
  }
}
