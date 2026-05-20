import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

abstract interface class ExpenseRepository {
  Stream<List<RawNotification>> watchRawNotifications();

  Stream<List<ExpenseTransaction>> watchExpenses();

  Future<RawNotification?> getRawNotificationBySourceHash(String sourceHash);

  Future<RawNotification?> getRawNotificationById(String id);

  Future<List<ExpenseTransaction>> getExpenses();

  Future<ExpenseTransaction?> getExpenseById(String id);

  Future<List<TransactionCandidate>> getCandidatesForRawNotification(
    String rawNotificationId,
  );

  Future<TransactionCandidate?> getTransactionCandidateById(String id);

  Future<ClassificationResult?> getClassificationResultByCandidateId(
    String candidateId,
  );

  Future<void> saveRawNotification(RawNotification rawNotification);

  Future<void> saveTransactionCandidate(TransactionCandidate candidate);

  Future<void> saveClassificationResult(ClassificationResult classification);

  Future<void> saveExpense(ExpenseTransaction expense);

  Future<void> updateExpense(ExpenseTransaction expense);
}
