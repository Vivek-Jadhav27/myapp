import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repo.dart';

class GetTransactionsUC implements UseCase<List<TransactionEntity>, GetTransactionsParams> {
  final TransactionRepo repo;

  GetTransactionsUC(this.repo);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(GetTransactionsParams params) async {
    return await repo.getTransactions(params.userId, params.date);
  }
}

class GetTransactionsParams extends Equatable {
  final String userId;
  final DateTime date;

  const GetTransactionsParams({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}
