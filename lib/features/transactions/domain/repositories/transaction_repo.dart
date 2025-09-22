import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/transaction.dart';

abstract class TransactionRepo {
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(String userId, DateTime date);
  Future<Either<Failure, void>> updateTransaction(TransactionEntity transaction);
  Future<Either<Failure, void>> deleteTransaction(String transactionId);
}
