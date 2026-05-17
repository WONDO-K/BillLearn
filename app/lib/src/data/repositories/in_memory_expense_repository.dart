import 'dart:async';

import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';

class InMemoryExpenseRepository implements ExpenseRepository {
  final List<RawNotification> _rawNotifications = [];
  final List<TransactionCandidate> _candidates = [];
  final List<ClassificationResult> _classifications = [];
  final List<ExpenseTransaction> _expenses = [];

  final _rawController = StreamController<List<RawNotification>>.broadcast();
  final _expenseController =
      StreamController<List<ExpenseTransaction>>.broadcast();

  @override
  Stream<List<RawNotification>> watchRawNotifications() async* {
    yield List.unmodifiable(_rawNotifications);
    yield* _rawController.stream;
  }

  @override
  Stream<List<ExpenseTransaction>> watchExpenses() async* {
    yield List.unmodifiable(_expenses);
    yield* _expenseController.stream;
  }

  @override
  Future<RawNotification?> getRawNotificationBySourceHash(
    String sourceHash,
  ) async {
    for (final rawNotification in _rawNotifications) {
      if (rawNotification.sourceHash == sourceHash) {
        return rawNotification;
      }
    }
    return null;
  }

  @override
  Future<List<ExpenseTransaction>> getExpenses() async {
    return List.unmodifiable(_expenses);
  }

  @override
  Future<ExpenseTransaction?> getExpenseById(String id) async {
    for (final expense in _expenses) {
      if (expense.id == id) {
        return expense;
      }
    }
    return null;
  }

  @override
  Future<List<TransactionCandidate>> getCandidatesForRawNotification(
    String rawNotificationId,
  ) async {
    return List.unmodifiable(
      _candidates.where(
        (candidate) => candidate.rawNotificationId == rawNotificationId,
      ),
    );
  }

  @override
  Future<TransactionCandidate?> getTransactionCandidateById(String id) async {
    for (final candidate in _candidates) {
      if (candidate.id == id) {
        return candidate;
      }
    }
    return null;
  }

  @override
  Future<ClassificationResult?> getClassificationResultByCandidateId(
    String candidateId,
  ) async {
    for (final classification in _classifications) {
      if (classification.candidateIds.contains(candidateId)) {
        return classification;
      }
    }
    return null;
  }

  @override
  Future<void> saveRawNotification(RawNotification rawNotification) async {
    _rawNotifications.add(rawNotification);
    _rawController.add(List.unmodifiable(_rawNotifications));
  }

  @override
  Future<void> saveTransactionCandidate(TransactionCandidate candidate) async {
    _candidates.removeWhere((item) => item.id == candidate.id);
    _candidates.add(candidate);
  }

  @override
  Future<void> saveClassificationResult(
    ClassificationResult classification,
  ) async {
    _classifications.removeWhere((item) => item.id == classification.id);
    _classifications.add(classification);
  }

  @override
  Future<void> saveExpense(ExpenseTransaction expense) async {
    _expenses.add(expense);
    _expenseController.add(List.unmodifiable(_expenses));
  }

  @override
  Future<void> updateExpense(ExpenseTransaction expense) async {
    final index = _expenses.indexWhere((item) => item.id == expense.id);
    if (index == -1) {
      _expenses.add(expense);
    } else {
      _expenses[index] = expense;
    }
    _expenseController.add(List.unmodifiable(_expenses));
  }

  Future<void> dispose() async {
    await _rawController.close();
    await _expenseController.close();
  }
}
