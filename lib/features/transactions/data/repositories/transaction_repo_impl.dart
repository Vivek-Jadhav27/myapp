import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repo.dart';
import '../datasources/transaction_ds.dart';
import '../models/transaction_model.dart';

class TransactionRepoImpl implements TransactionRepo {
  final TransactionDS dataSource;

  TransactionRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        amount: transaction.amount,
        date: transaction.date,
        category: transaction.category,
        description: transaction.description,
        type: transaction.type,
      );
      await dataSource.addTransaction(transactionModel);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
      String userId, DateTime date) async {
    try {
      final transactions = await dataSource.getTransactions(userId, date);
      return Right(transactions);
    } on ServerException {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(TransactionEntity transaction) async {
    try {
      final transactionModel = TransactionModel(
        id: transaction.id,
        userId: transaction.userId,
        amount: transaction.amount,
        date: transaction.date,
        category: transaction.category,
        description: transaction.description,
        type: transaction.type,
      );
      await dataSource.updateTransaction(transactionModel);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
    try {
      await dataSource.deleteTransaction(transactionId);
      return const Right(null);
    } on ServerException {
          return Left(ServerFailure(""));
    }
  }
}
