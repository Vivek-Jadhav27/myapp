import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transaction_repo.dart';

class DeleteTransactionUC implements UseCase<void, String> {
  final TransactionRepo repo;

  DeleteTransactionUC(this.repo);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repo.deleteTransaction(params);
  }
}
